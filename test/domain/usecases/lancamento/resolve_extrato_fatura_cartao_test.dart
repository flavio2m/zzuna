import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';

class FakeContaRepository implements ContaRepository {
  @override
  AsyncResult<Conta> getById(String id) async {
    return Failure(Exception('Not used'));
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCartaoRepository implements CartaoRepository {
  Cartao? cartao;
  @override
  AsyncResult<Cartao> getById(String id) async {
    if (cartao != null && cartao!.id == id) {
      return Success(cartao!);
    }
    return Failure(Exception('Cartao not found'));
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeExtratoFaturaRepository implements ExtratoFaturaRepository {
  List<ExtratoFatura> extratos = [];
  List<ExtratoFaturaDto> createdDtos = [];

  @override
  AsyncResult<List<ExtratoFatura>> searchByPeriodo(
    LancamentoOrigem origem,
    int ano,
    Mes mes,
  ) async {
    final list = extratos.where((e) => e.ano == ano && e.mes == mes).toList();
    return Success(list);
  }

  @override
  AsyncResult<ExtratoFatura> create(ExtratoFaturaDto dto) async {
    createdDtos.add(dto);
      final origemId = dto.origem is LancamentoOrigemCartao ? (dto.origem as LancamentoOrigemCartao).cartaoId : (dto.origem as LancamentoOrigemConta).contaId;
      final entity = ExtratoFatura(
      id: 'ef-${dto.ano}-${dto.mes.numero}',
      origem: dto.origem,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      saldoInicial: dto.saldoInicial,
      saldoFinal: dto.saldoFinal,
      fechado: dto.fechado,
      periodo: int.parse('${dto.ano}${dto.mes.numero.toString().padLeft(2, '0')}'),
      origemKey: origemId,
    );
    extratos.add(entity);
    return Success(entity);
  }

  @override
  AsyncResult<List<ExtratoFatura>> searchPrevious(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int limit = 1,
  }) async {
    return const Success([]);
  }

  @override
  AsyncResult<List<ExtratoFatura>> searchAfter(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int? limit,
  }) async {
    return const Success([]);
  }

  @override
  AsyncResult<Unit> updateAll(List<ExtratoFaturaDto> items) async {
    return const Success(unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ResolveExtratoFaturaUseCase - Regra de Fechamento de Cartão', () {
    late ResolveExtratoFaturaUseCase useCase;
    late FakeCartaoRepository cartaoRepo;
    late FakeContaRepository contaRepo;
    late FakeExtratoFaturaRepository extratoRepo;

    setUp(() {
      cartaoRepo = FakeCartaoRepository();
      contaRepo = FakeContaRepository();
      extratoRepo = FakeExtratoFaturaRepository();
      useCase = ResolveExtratoFaturaUseCase(extratoRepo, contaRepo, cartaoRepo);
    });

    test('Lançamentos devem ser alocados no ExtratoFatura correto baseado no diaFechamento', () async {
      // 1) Cadastrei um cartão CC 1 com dia de fechamento dia 12
      final cartaoId = 'cc-1';
      cartaoRepo.cartao = Cartao(
        id: cartaoId,
        descricao: 'CC 1',
        limite: 1000,
        bancoSigla: 'NUB',
        diaFechamento: 12, // Fecha dia 12
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      );

      final origem = LancamentoOrigem.cartao(cartaoId: cartaoId);
      
      // import 'package:zzuna/domain/enums/lancamento_tipo.dart';
      
      // Cenário 1: 15/07/2026 (dia >= 12) -> Cai no mês atual (07/2026)
      final dto1 = ResolveExtratoFaturaDto(
        data: DateTime(2026, 7, 15),
        origem: origem,
        valor: 100,
        tipo: LancamentoTipo.despesa,
      );
      final result1 = await useCase.execute(dto1);
      expect(result1.isSuccess(), isTrue);
      var extrato1 = result1.getOrThrow();
      expect(extrato1.mes, Mes.julho);
      expect(extrato1.ano, 2026);

      // Cenário 2: 12/07/2026 (dia >= 12) -> Cai no mês atual (07/2026)
      final dto2 = ResolveExtratoFaturaDto(
        data: DateTime(2026, 7, 12),
        origem: origem,
        valor: 100,
        tipo: LancamentoTipo.despesa,
      );
      final result2 = await useCase.execute(dto2);
      expect(result2.isSuccess(), isTrue);
      var extrato2 = result2.getOrThrow();
      expect(extrato2.mes, Mes.julho);
      expect(extrato2.ano, 2026);

      // Cenário 3: 11/07/2026 (dia < 12) -> Cai no mês anterior (06/2026)
      final dto3 = ResolveExtratoFaturaDto(
        data: DateTime(2026, 7, 11),
        origem: origem,
        valor: 100,
        tipo: LancamentoTipo.despesa,
      );
      final result3 = await useCase.execute(dto3);
      expect(result3.isSuccess(), isTrue);
      var extrato3 = result3.getOrThrow();
      expect(extrato3.mes, Mes.junho);
      expect(extrato3.ano, 2026);

      // Cenário 4: 13/06/2026 (dia >= 12) -> Cai no mês atual (06/2026)
      final dto4 = ResolveExtratoFaturaDto(
        data: DateTime(2026, 6, 13),
        origem: origem,
        valor: 100,
        tipo: LancamentoTipo.despesa,
      );
      final result4 = await useCase.execute(dto4);
      expect(result4.isSuccess(), isTrue);
      var extrato4 = result4.getOrThrow();
      expect(extrato4.mes, Mes.junho);
      expect(extrato4.ano, 2026);

      // Verifica no final se apenas 2 Extratos foram criados no banco de testes falso: Junho e Julho
      expect(extratoRepo.createdDtos.length, 2);
      final createdMeses = extratoRepo.createdDtos.map((e) => e.mes).toList();
      expect(createdMeses.contains(Mes.julho), isTrue);
      expect(createdMeses.contains(Mes.junho), isTrue);
    });
  });
}
