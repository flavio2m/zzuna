import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/usecases/lancamento/reabrir_mes_usecase.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';

class FakeContaRepository implements ContaRepository {
  List<Conta> contas = [];
  @override
  AsyncResult<List<Conta>> getAll() async => Success(contas);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCartaoRepository implements CartaoRepository {
  @override
  AsyncResult<List<Cartao>> getAll() async => const Success([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeExtratoFaturaRepository implements ExtratoFaturaRepository {
  List<ExtratoFatura> extratosProximos = [];
  List<ExtratoFatura> extratosAtuais = [];
  List<ExtratoFaturaDto> updatedDtos = [];

  @override
  AsyncResult<List<ExtratoFatura>> searchNext(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int limit = 1,
  }) async {
    return Success(extratosProximos);
  }

  @override
  AsyncResult<List<ExtratoFatura>> searchByPeriodo(
    LancamentoOrigem origem,
    int ano,
    Mes mes,
  ) async {
    return Success(extratosAtuais);
  }

  @override
  AsyncResult<Unit> updateAll(List<ExtratoFaturaDto> items) async {
    updatedDtos.addAll(items);
    return const Success(unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ReabrirMesUseCase Tests', () {
    late ReabrirMesUseCase useCase;
    late FakeContaRepository contaRepo;
    late FakeCartaoRepository cartaoRepo;
    late FakeExtratoFaturaRepository extratoRepo;

    final conta = Conta(
      id: 'c-1',
      descricao: 'Conta 1',
      ativo: true,
      dataInicial: DateTime(2026, 1, 1),
      bancoSigla: 'B',
    );

    final origem = LancamentoOrigem.conta(contaId: 'c-1');

    setUp(() {
      contaRepo = FakeContaRepository()..contas = [conta];
      cartaoRepo = FakeCartaoRepository();
      extratoRepo = FakeExtratoFaturaRepository();

      useCase = ReabrirMesUseCase(contaRepo, cartaoRepo, extratoRepo);
    });

    test('Deve falhar se o próximo mês estiver fechado', () async {
      extratoRepo.extratosProximos = [
        ExtratoFatura(
          id: 'ef-next',
          origem: origem,
          ano: 2026,
          mes: Mes.marco,
          dataInicio: DateTime(2026, 3, 1),
          dataFim: DateTime(2026, 3, 31),
          saldoInicial: 0,
          saldoFinal: 0,
          fechado: true,
          periodo: 202603,
          origemKey: 'conta_c-1',
        ),
      ];

      final result = await useCase.execute(Mes.fevereiro, 2026);

      expect(result.isError(), isTrue);
      expect(
        result.exceptionOrNull()!.toString(),
        contains('mês seguinte já está fechado'),
      );
    });

    test('Deve reabrir com sucesso marcando fechado = false', () async {
      extratoRepo.extratosProximos = [];

      extratoRepo.extratosAtuais = [
        ExtratoFatura(
          id: 'ef-atual',
          origem: origem,
          ano: 2026,
          mes: Mes.fevereiro,
          dataInicio: DateTime(2026, 2, 1),
          dataFim: DateTime(2026, 2, 28),
          saldoInicial: 50.0,
          saldoFinal: 100.0,
          fechado: true,
          periodo: 202602,
          origemKey: 'conta_c-1',
        ),
      ];

      final result = await useCase.execute(Mes.fevereiro, 2026);

      expect(result.isSuccess(), isTrue);
      expect(extratoRepo.updatedDtos.length, 1);

      // Deve ter sido alterado para false
      final atualDto = extratoRepo.updatedDtos.first;
      expect(atualDto.id, 'ef-atual');
      expect(atualDto.fechado, isFalse);
    });

    test('Deve ignorar se já estiver aberto', () async {
      extratoRepo.extratosProximos = [];

      extratoRepo.extratosAtuais = [
        ExtratoFatura(
          id: 'ef-atual',
          origem: origem,
          ano: 2026,
          mes: Mes.fevereiro,
          dataInicio: DateTime(2026, 2, 1),
          dataFim: DateTime(2026, 2, 28),
          saldoInicial: 50.0,
          saldoFinal: 100.0,
          fechado: false,
          periodo: 202602,
          origemKey: 'conta_c-1',
        ),
      ];

      final result = await useCase.execute(Mes.fevereiro, 2026);

      expect(result.isSuccess(), isTrue);
      expect(
        extratoRepo.updatedDtos.isEmpty,
        isTrue,
      ); // não enviou nada para updateAll
    });
  });
}
