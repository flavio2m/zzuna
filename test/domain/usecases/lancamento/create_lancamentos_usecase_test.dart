import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturasUseCase resolveUseCase;
  late CreateLancamentosUseCase createLancamentosUseCase;
  late LocalStorage<ExtratoFatura> extratoStorage;
  late LocalStorage<Lancamento> lancamentoStorage;

  late LancamentoOrigem origemConta;
  late DateTime dataInicialConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    extratoStorage = createTestExtratoFaturaStorage();
    lancamentoStorage = createTestLancamentoStorage();

    contaRepository = ContaRepository(contaStorage);
    cartaoRepository = CartaoRepository(cartaoStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    resolveUseCase = ResolveExtratoFaturasUseCase(
      extratoRepository,
      contaRepository,
      cartaoRepository,
    );

    createLancamentosUseCase = CreateLancamentosUseCase(
      resolveUseCase,
      lancamentoRepository,
      LancamentoValidator(),
    );

    dataInicialConta = DateTime(2026, 1, 1);

    final conta = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta Principal',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: dataInicialConta,
      ),
    );

    origemConta = LancamentoOrigem.conta(contaId: conta.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('CreateLancamentosUseCase Tests', () {
    test('Should return error if any DTO is invalid', () async {
      final dtos = [
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Salário', // Válido
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 5000.0,
            ),
          ],
        ),
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: '', // Inválido (descrição vazia)
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
      ];

      final res = await createLancamentosUseCase.execute(dtos);
      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Descrição é obrigatória'));

      // Validar que NADA foi persistido
      final lancamentos = (await lancamentoStorage.getAll()).getOrThrow();
      expect(lancamentos, isEmpty);
    });

    test('Should resolve and create multiple launches in batch', () async {
      final dtos = [
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Receita 1',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 100.0,
            ),
          ],
        ),
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Despesa 1',
          origem: origemConta,
          data: DateTime(2026, 2, 10), // Outro mês
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 40.0,
            ),
          ],
        ),
      ];

      final res = await createLancamentosUseCase.execute(dtos);
      expect(res.isSuccess(), isTrue);

      final createdList = res.getOrThrow();
      expect(createdList, hasLength(2));
      expect(createdList[0].extratoFaturaId, isNotEmpty);
      expect(createdList[1].extratoFaturaId, isNotEmpty);
      expect(createdList[0].extratoFaturaId, isNot(createdList[1].extratoFaturaId));

      // Verificar no repositório de lançamentos
      final storedLaunches = (await lancamentoStorage.getAll()).getOrThrow();
      expect(storedLaunches, hasLength(2));

      // Verificar no repositório de extratos
      final storedExtratos = (await extratoStorage.getAll()).getOrThrow()
        ..sort((a, b) => a.periodo.compareTo(b.periodo));

      expect(storedExtratos, hasLength(2)); // Jan e Fev
      expect(storedExtratos[0].mes, Mes.janeiro);
      expect(storedExtratos[0].saldoFinal, 100.0);

      expect(storedExtratos[1].mes, Mes.fevereiro);
      expect(storedExtratos[1].saldoInicial, 100.0); // herdado de jan
      expect(storedExtratos[1].saldoFinal, 60.0); // 100 - 40 = 60
    });

    test('Should properly persist and propagate LancamentoGrupo.parcelamento in real launch creation flow', () async {
      const grupoId = 'grupo-parcelamento-1';
      final dtos = List.generate(3, (index) {
        final i = index + 1;
        return LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Notebook Gaming ($i/3)',
          origem: origemConta,
          data: DateTime(2026, index + 1, 15),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-tech',
              centroCustoId: 'cc-pessoal',
              valor: 1000.0,
            ),
          ],
          grupo: LancamentoGrupo.parcelamento(
            grupoId: grupoId,
            parcela: i,
            totalParcelas: 3,
          ),
        );
      });

      final result = await createLancamentosUseCase.execute(dtos);
      expect(result.isSuccess(), isTrue);

      final created = result.getOrThrow();
      expect(created, hasLength(3));

      // Validar entidades retornadas pelo UseCase
      for (int i = 0; i < 3; i++) {
        expect(created[i].grupo, isNotNull);
        expect(created[i].grupo, isA<LancamentoGrupoParcelamento>());
        final p = created[i].grupo as LancamentoGrupoParcelamento;
        expect(p.grupoId, equals(grupoId));
        expect(p.parcela, equals(i + 1));
        expect(p.totalParcelas, equals(3));
      }

      // Validar persistência e recuperação do repositório/storage
      final stored = (await lancamentoStorage.getAll()).getOrThrow()
        ..sort((a, b) => a.data.compareTo(b.data));

      expect(stored, hasLength(3));
      for (int i = 0; i < 3; i++) {
        final p = stored[i].grupo as LancamentoGrupoParcelamento;
        expect(p.grupoId, equals(grupoId));
        expect(p.parcela, equals(i + 1));
        expect(p.totalParcelas, equals(3));
      }
    });

    test('Should properly persist and propagate LancamentoGrupo.replicacao', () async {
      const grupoId = 'grupo-rep-1';
      final dtos = List.generate(2, (index) {
        return LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Assinatura Software',
          origem: origemConta,
          data: DateTime(2026, index + 1, 1),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-sub',
              centroCustoId: 'cc-trabalho',
              valor: 50.0,
            ),
          ],
          grupo: LancamentoGrupo.replicacao(
            grupoId: grupoId,
            parcela: index + 1,
            totalParcelas: 2,
          ),
        );
      });

      final result = await createLancamentosUseCase.execute(dtos);
      expect(result.isSuccess(), isTrue);

      final stored = (await lancamentoStorage.getAll()).getOrThrow();
      for (int i = 0; i < stored.length; i++) {
        final l = stored[i];
        expect(l.grupo, isNotNull);
        expect(l.grupo, isA<LancamentoGrupoReplicacao>());
        final rep = l.grupo as LancamentoGrupoReplicacao;
        expect(rep.grupoId, equals(grupoId));
        expect(rep.parcela, equals(i + 1));
        expect(rep.totalParcelas, equals(2));
      }
    });
  });
}
