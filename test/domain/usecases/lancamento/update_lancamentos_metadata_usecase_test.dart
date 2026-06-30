import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/update_lancamentos_metadata_dto.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_metadata_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late CreateLancamentoUseCase createLancamentoUseCase;
  late UpdateLancamentosMetadataUseCase updateMetadataUseCase;

  late LancamentoOrigem origemConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    final extratoStorage = createTestExtratoFaturaStorage();
    final lancamentoStorage = createTestLancamentoStorage();

    contaRepository = ContaRepository(contaStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    resolveUseCase = ResolveExtratoFaturaUseCase(
      extratoRepository,
      contaRepository,
      CartaoRepository(cartaoStorage),
    );

    createLancamentoUseCase = CreateLancamentoUseCase(
      resolveUseCase,
      lancamentoRepository,
      LancamentoValidator(),
    );

    updateMetadataUseCase = UpdateLancamentosMetadataUseCase(lancamentoRepository);

    final conta = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta Principal',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );

    origemConta = LancamentoOrigem.conta(contaId: conta.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('UpdateLancamentosMetadataUseCase Tests', () {
    test('Should update only description when only description is provided', () async {
      final created = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Descrição Antiga',
          observacao: 'Obs Antiga',
          origem: origemConta,
          data: DateTime(2026, 1, 10),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 50.0,
            ),
          ],
        ),
      )).getOrThrow();

      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          id: created.id,
          descricao: 'Nova Descrição',
          observacao: created.observacao,
        ),
      );
      expect(res.isSuccess(), isTrue);

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.descricao, 'Nova Descrição');
      expect(updated.observacao, 'Obs Antiga');
    });

    test('Should update only observation when only observation is provided', () async {
      final created = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Salário',
          observacao: 'Sem notas',
          origem: origemConta,
          data: DateTime(2026, 1, 15),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-2',
              centroCustoId: 'cc-2',
              valor: 2000.0,
            ),
          ],
        ),
      )).getOrThrow();

      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          id: created.id,
          descricao: created.descricao,
          observacao: 'Nota importante adicionada',
        ),
      );
      expect(res.isSuccess(), isTrue);

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.descricao, 'Salário');
      expect(updated.observacao, 'Nota importante adicionada');
    });

    test('Should update both description and observation simultaneously', () async {
      final created = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Item 1',
          observacao: 'Obs 1',
          origem: origemConta,
          data: DateTime(2026, 1, 20),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 30.0,
            ),
          ],
        ),
      )).getOrThrow();

      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          id: created.id,
          descricao: 'Item 1 Modificado',
          observacao: 'Obs 1 Modificada',
        ),
      );
      expect(res.isSuccess(), isTrue);

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.descricao, 'Item 1 Modificado');
      expect(updated.observacao, 'Obs 1 Modificada');
    });

    test('Should return Failure if ID is not found', () async {
      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          id: 'id-inexistente',
          descricao: 'Teste',
        ),
      );

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull()!.toString(),
        contains('Lançamento com ID id-inexistente não encontrado.'),
      );
    });

    test('Should search by group, update current and future launches, and ignore past launches', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento A',
          origem: origemConta,
          data: DateTime(2026, 1, 1),
          grupo: const LancamentoGrupo.replicacao(grupoId: 'grupo-123', parcela: 1, totalParcelas: 3),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 10.0)],
        ),
      )).getOrThrow();

      final l2 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento B',
          origem: origemConta,
          data: DateTime(2026, 2, 1),
          grupo: const LancamentoGrupo.replicacao(grupoId: 'grupo-123', parcela: 2, totalParcelas: 3),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 10.0)],
        ),
      )).getOrThrow();

      final l3 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento C',
          origem: origemConta,
          data: DateTime(2026, 3, 1),
          grupo: const LancamentoGrupo.replicacao(grupoId: 'grupo-123', parcela: 3, totalParcelas: 3),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 10.0)],
        ),
      )).getOrThrow();

      // Atualizar grupo a partir de B (l2)
      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          id: l2.id,
          descricao: 'Novo Grupo',
        ),
      );
      expect(res.isSuccess(), isTrue);

      final checkA = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      final checkB = (await lancamentoRepository.getById(l2.id)).getOrThrow();
      final checkC = (await lancamentoRepository.getById(l3.id)).getOrThrow();

      expect(checkA.descricao, 'Lançamento A'); // Ignorado porque é anterior à data de B
      expect(checkB.descricao, 'Novo Grupo (2/3)'); // Atualizado com sufixo
      expect(checkC.descricao, 'Novo Grupo (3/3)'); // Atualizado com sufixo
    });

    test('Should abort and return failure if any of the target launches is reconciled', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento A',
          origem: origemConta,
          data: DateTime(2026, 1, 1),
          grupo: const LancamentoGrupo.replicacao(grupoId: 'grupo-123', parcela: 1, totalParcelas: 3),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 10.0)],
        ),
      )).getOrThrow();

      var l2 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento B',
          origem: origemConta,
          data: DateTime(2026, 2, 1),
          grupo: const LancamentoGrupo.replicacao(grupoId: 'grupo-123', parcela: 2, totalParcelas: 3),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 10.0)],
        ),
      )).getOrThrow();

      var l3 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento C',
          origem: origemConta,
          data: DateTime(2026, 3, 1),
          grupo: const LancamentoGrupo.replicacao(grupoId: 'grupo-123', parcela: 3, totalParcelas: 3),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 10.0)],
        ),
      )).getOrThrow();

      // Conciliar l3 (lançamento futuro)
      final l3Dto = LancamentoDto.fromEntity(l3);
      l3Dto.conciliado = true;
      await lancamentoRepository.update(l3Dto);

      // Tentar atualizar o grupo a partir de l2
      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          id: l2.id,
          descricao: 'Falha',
        ),
      );

      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Há lançamentos conciliados e a operação foi abortada.'));

      // Verificar que nenhum foi alterado
      final checkA = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      final checkB = (await lancamentoRepository.getById(l2.id)).getOrThrow();
      final checkC = (await lancamentoRepository.getById(l3.id)).getOrThrow();

      expect(checkA.descricao, 'Lançamento A');
      expect(checkB.descricao, 'Lançamento B');
      expect(checkC.descricao, 'Lançamento C');
    });
  });
}
