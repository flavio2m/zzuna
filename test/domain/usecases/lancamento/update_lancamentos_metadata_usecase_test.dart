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
          ids: [created.id],
          descricao: 'Nova Descrição',
        ),
      );
      expect(res.isSuccess(), isTrue);

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.descricao, 'Nova Descrição');
      expect(updated.observacao, 'Obs Antiga');
      expect(updated.data, DateTime(2026, 1, 10));
      expect(updated.origem, origemConta);
      expect(updated.itens.length, 1);
      expect(updated.conciliado, false);
      expect(updated.extratoFaturaId, created.extratoFaturaId);
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
          ids: [created.id],
          observacao: 'Nota importante adicionada',
        ),
      );
      expect(res.isSuccess(), isTrue);

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.descricao, 'Salário');
      expect(updated.observacao, 'Nota importante adicionada');
      expect(updated.data, DateTime(2026, 1, 15));
      expect(updated.tipo, LancamentoTipo.receita);
      expect(updated.extratoFaturaId, created.extratoFaturaId);
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
          ids: [created.id],
          descricao: 'Item 1 Modificado',
          observacao: 'Obs 1 Modificada',
        ),
      );
      expect(res.isSuccess(), isTrue);

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.descricao, 'Item 1 Modificado');
      expect(updated.observacao, 'Obs 1 Modificada');
    });

    test('Should preserve all financial and structural fields', () async {
      final created = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Original',
          origem: origemConta,
          data: DateTime(2026, 1, 25),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 100.0,
            ),
          ],
        ),
      )).getOrThrow();

      await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          ids: [created.id],
          descricao: 'Alterado',
        ),
      );

      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.data, created.data);
      expect(updated.tipo, created.tipo);
      expect(updated.origem, created.origem);
      expect(updated.itens.length, created.itens.length);
      expect(updated.itens.first.valor, created.itens.first.valor);
      expect(updated.grupo, created.grupo);
      expect(updated.conciliado, created.conciliado);
      expect(updated.extratoFaturaId, created.extratoFaturaId);
    });

    test('Should return Failure if any ID is not found', () async {
      final res = await updateMetadataUseCase.execute(
        UpdateLancamentosMetadataDto(
          ids: ['id-inexistente'],
          descricao: 'Teste',
        ),
      );

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull()!.toString(),
        contains('Lançamento com ID id-inexistente não encontrado.'),
      );
    });
  });
}
