import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/sync_recorrencias_mes_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/enums/tipo_lancamento_grupo.dart';

class MockContaRepository implements ContaRepository {
  List<Conta> contas = [];
  @override
  AsyncResult<List<Conta>> getAll() async => Success(contas);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockCartaoRepository implements CartaoRepository {
  List<Cartao> cartoes = [];
  @override
  AsyncResult<List<Cartao>> getAll() async => Success(cartoes);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockExtratoRepository implements ExtratoFaturaRepository {
  List<ExtratoFatura> extratos = [];
  bool createCalled = false;

  @override
  AsyncResult<List<ExtratoFatura>> searchByPeriodo(
    LancamentoOrigem origem,
    int ano,
    Mes mes,
  ) async {
    final res = extratos
        .where((e) => e.origem == origem && e.ano == ano && e.mes == mes)
        .toList();
    return Success(res);
  }

  @override
  AsyncResult<List<ExtratoFatura>> searchPrevious(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int limit = 1,
  }) async {
    final numTarget = ano * 100 + mes.numero;
    final res =
        extratos
            .where(
              (e) =>
                  e.origem == origem &&
                  (e.ano * 100 + e.mes.numero) < numTarget,
            )
            .toList()
          ..sort(
            (a, b) => (b.ano * 100 + b.mes.numero).compareTo(
              a.ano * 100 + a.mes.numero,
            ),
          );
    return Success(res);
  }

  @override
  AsyncResult<ExtratoFatura> create(ExtratoFaturaDto dto) async {
    createCalled = true;
    final newExtrato = ExtratoFatura(
      id: dto.id ?? 'new-id',
      origem: dto.origem,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      saldoInicial: dto.saldoInicial,
      saldoFinal: dto.saldoFinal,
      fechado: dto.fechado,
      periodo: dto.ano * 100 + dto.mes.numero,
      origemKey: 'mock-key',
    );
    extratos.add(newExtrato);
    return Success(newExtrato);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockLancamentoRepository implements LancamentoRepository {
  List<Lancamento> lancamentos = [];

  @override
  AsyncResult<List<Lancamento>> searchByExtratoFaturaId(
    String extratoFaturaId, {
    TipoLancamentoGrupo? tipoGrupo,
  }) async {
    var filtered = lancamentos
        .where((l) => l.extratoFaturaId == extratoFaturaId)
        .toList();
    if (tipoGrupo != null) {
      filtered = filtered.where((l) {
        final grupo = l.grupo;
        if (grupo == null) return false;
        return switch (tipoGrupo) {
          TipoLancamentoGrupo.parcelamento =>
            grupo is LancamentoGrupoParcelamento,
          TipoLancamentoGrupo.transferencia =>
            grupo is LancamentoGrupoTransferencia,
          TipoLancamentoGrupo.replicacao => grupo is LancamentoGrupoReplicacao,
          TipoLancamentoGrupo.recorrencia =>
            grupo is LancamentoGrupoRecorrencia,
        };
      }).toList();
    }
    return Success(filtered);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockApplyRecorrenciasUseCase implements ApplyRecorrenciasUseCase {
  bool executeCalled = false;
  @override
  AsyncResult<Unit> execute(
    LancamentoOrigem origem,
    ExtratoFatura novoExtrato,
  ) async {
    executeCalled = true;
    return const Success(unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SyncRecorrenciasMesUseCase', () {
    late MockContaRepository contaRepo;
    late MockCartaoRepository cartaoRepo;
    late MockExtratoRepository extratoRepo;
    late MockLancamentoRepository lancamentoRepository;
    late MockApplyRecorrenciasUseCase applyRecorrencias;
    late SyncRecorrenciasMesUseCase usecase;

    setUp(() {
      contaRepo = MockContaRepository();
      cartaoRepo = MockCartaoRepository();
      extratoRepo = MockExtratoRepository();
      lancamentoRepository = MockLancamentoRepository();
      applyRecorrencias = MockApplyRecorrenciasUseCase();

      usecase = SyncRecorrenciasMesUseCase(
        contaRepo,
        cartaoRepo,
        extratoRepo,
        lancamentoRepository,
        applyRecorrencias,
      );
    });

    test(
      'Deve sincronizar recorrência se houver extrato anterior com recorrência ativa e nenhum no mês atual',
      () async {
        final conta = Conta(
          id: 'conta1',
          descricao: 'Conta Teste',
          ativo: true,
          dataInicial: DateTime(2026, 1, 1),
          bancoSigla: 'BB',
        );
        contaRepo.contas.add(conta);

        final origem = LancamentoOrigem.conta(contaId: conta.id);

        final prevExtrato = ExtratoFatura(
          id: 'ext1',
          origem: origem,
          ano: 2026,
          mes: Mes.julho,
          dataInicio: DateTime(2026, 7, 1),
          dataFim: DateTime(2026, 7, 31),
          saldoInicial: 0,
          saldoFinal: 100,
          fechado: false,
          periodo: 202607,
          origemKey: 'conta_conta1',
        );
        extratoRepo.extratos.add(prevExtrato);

        final lancamentoRecorrente = Lancamento(
          id: 'lan1',
          tipo: LancamentoTipo.despesa,
          data: DateTime(2026, 7, 10),
          descricao: 'Netflix',
          extratoFaturaId: 'ext1',
          origem: origem,
          itens: [],
          conciliado: false,
          grupo: const LancamentoGrupo.recorrencia(
            grupoId: 'grupo1',
            ativo: true,
            diaDoMes: 5,
            tipo: TipoRecorrencia.mensal,
            sequencia: 1,
          ),
          anoMes: 202607,
        );
        lancamentoRepository.lancamentos.add(lancamentoRecorrente);

        await usecase.execute(Mes.agosto, 2026);

        expect(extratoRepo.createCalled, isTrue);
        expect(applyRecorrencias.executeCalled, isTrue);
        expect(extratoRepo.extratos.length, 2);
        final novoExtrato = extratoRepo.extratos.last;
        expect(novoExtrato.mes, Mes.agosto);
        expect(novoExtrato.ano, 2026);
      },
    );

    test(
      'Não deve criar extrato se o extrato anterior não tiver recorrência ativa',
      () async {
        final conta = Conta(
          id: 'conta1',
          descricao: 'Conta Teste',
          ativo: true,
          dataInicial: DateTime(2026, 1, 1),
          bancoSigla: 'BB',
        );
        contaRepo.contas.add(conta);

        final origem = LancamentoOrigem.conta(contaId: conta.id);

        final prevExtrato = ExtratoFatura(
          id: 'ext1',
          origem: origem,
          ano: 2026,
          mes: Mes.julho,
          dataInicio: DateTime(2026, 7, 1),
          dataFim: DateTime(2026, 7, 31),
          saldoInicial: 0,
          saldoFinal: 100,
          fechado: false,
          periodo: 202607,
          origemKey: 'conta_conta1',
        );
        extratoRepo.extratos.add(prevExtrato);

        final lancamentoNaoRecorrente = Lancamento(
          id: 'lan1',
          tipo: LancamentoTipo.despesa,
          data: DateTime(2026, 7, 10),
          descricao: 'Pão',
          extratoFaturaId: 'ext1',
          origem: origem,
          itens: [],
          conciliado: false,
          grupo: null,
          anoMes: 202607,
        );
        lancamentoRepository.lancamentos.add(lancamentoNaoRecorrente);

        await usecase.execute(Mes.agosto, 2026);

        expect(extratoRepo.createCalled, isFalse);
        expect(applyRecorrencias.executeCalled, isFalse);
        expect(extratoRepo.extratos.length, 1);
      },
    );
  });
}
