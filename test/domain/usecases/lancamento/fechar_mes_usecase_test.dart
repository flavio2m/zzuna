import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/usecases/lancamento/fechar_mes_usecase.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';

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

class FakeLancamentoRepository implements LancamentoRepository {
  List<Lancamento> lancamentos = [];
  @override
  AsyncResult<List<Lancamento>> search(LancamentoFilterDto filter) async {
    if (filter.conciliado == false) {
      return Success(lancamentos.where((l) => !l.conciliado).toList());
    }
    return Success(lancamentos);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeExtratoFaturaRepository implements ExtratoFaturaRepository {
  List<ExtratoFatura> extratosAnteriores = [];
  List<ExtratoFatura> extratosAtuais = [];
  List<ExtratoFatura> extratosFuturos = [];
  List<ExtratoFaturaDto> updatedDtos = [];

  @override
  AsyncResult<List<ExtratoFatura>> searchPrevious(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int limit = 1,
  }) async {
    return Success(extratosAnteriores);
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
  AsyncResult<List<ExtratoFatura>> searchAfter(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int? limit,
  }) async {
    return Success(extratosFuturos);
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
  group('FecharMesUseCase Tests', () {
    late FecharMesUseCase useCase;
    late FakeContaRepository contaRepo;
    late FakeCartaoRepository cartaoRepo;
    late FakeExtratoFaturaRepository extratoRepo;
    late FakeLancamentoRepository lancamentoRepo;

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
      lancamentoRepo = FakeLancamentoRepository();

      useCase = FecharMesUseCase(
        contaRepo,
        cartaoRepo,
        extratoRepo,
        lancamentoRepo,
      );
    });

    test('Deve falhar se o mês anterior não estiver fechado', () async {
      extratoRepo.extratosAnteriores = [
        ExtratoFatura(
          id: 'ef-prev',
          origem: origem,
          ano: 2026,
          mes: Mes.janeiro,
          dataInicio: DateTime(2026, 1, 1),
          dataFim: DateTime(2026, 1, 31),
          saldoInicial: 0,
          saldoFinal: 0,
          fechado: false,
          periodo: 202601,
          origemKey: 'conta_c-1',
        ),
      ];

      final result = await useCase.execute(Mes.fevereiro, 2026);

      expect(result.isError(), isTrue);
      expect(
        result.exceptionOrNull()!.toString(),
        contains('Existe mês anterior não fechado'),
      );
    });

    test(
      'Deve falhar se existirem lançamentos não conciliados no mês',
      () async {
        // Mês anterior fechado (vazio no mock ou explicitly true)
        lancamentoRepo.lancamentos = [
          Lancamento(
            id: 'l-1',
            extratoFaturaId: 'ef-1',
            data: DateTime(2026, 2, 10),
            descricao: 'Nao conciliado',
            origem: origem,
            tipo: LancamentoTipo.despesa,
            itens: const [],
            conciliado: false, // NÃO CONCILIADO
          ),
        ];

        final result = await useCase.execute(Mes.fevereiro, 2026);

        expect(result.isError(), isTrue);
        expect(
          result.exceptionOrNull()!.toString(),
          contains('não conciliados'),
        );
      },
    );

    test('Deve fechar com sucesso e propagar delta', () async {
      extratoRepo.extratosAnteriores = [];
      lancamentoRepo.lancamentos = [
        Lancamento(
          id: 'l-1',
          extratoFaturaId: 'ef-1',
          data: DateTime(2026, 2, 10),
          descricao: 'Receita',
          origem: origem,
          tipo: LancamentoTipo.receita,
          itens: const [
            LancamentoItem(
              numero: 1,
              centroCustoId: '',
              categoriaId: '',
              valor: 100.0,
            ),
          ],
          conciliado: true,
        ),
      ];

      extratoRepo.extratosAtuais = [
        ExtratoFatura(
          id: 'ef-atual',
          origem: origem,
          ano: 2026,
          mes: Mes.fevereiro,
          dataInicio: DateTime(2026, 2, 1),
          dataFim: DateTime(2026, 2, 28),
          saldoInicial: 50.0,
          saldoFinal: 50.0,
          fechado: false,
          periodo: 202602,
          origemKey: 'conta_c-1',
        ),
      ];

      extratoRepo.extratosFuturos = [
        ExtratoFatura(
          id: 'ef-futuro',
          origem: origem,
          ano: 2026,
          mes: Mes.marco,
          dataInicio: DateTime(2026, 3, 1),
          dataFim: DateTime(2026, 3, 31),
          saldoInicial: 50.0,
          saldoFinal: 100.0,
          fechado: false,
          periodo: 202603,
          origemKey: 'conta_c-1',
        ),
      ];

      final result = await useCase.execute(Mes.fevereiro, 2026);

      expect(result.isSuccess(), isTrue);
      expect(extratoRepo.updatedDtos.length, 2);

      // Atual (fechado = true, saldoFinal = 150)
      final atualDto = extratoRepo.updatedDtos.firstWhere(
        (e) => e.id == 'ef-atual',
      );
      expect(atualDto.fechado, isTrue);
      expect(atualDto.saldoFinal, 150.0);

      // Futuro propagou o delta (100) -> 50.0 + 100 = 150, saldoFinal 100 + 100 = 200
      final futuroDto = extratoRepo.updatedDtos.firstWhere(
        (e) => e.id == 'ef-futuro',
      );
      expect(futuroDto.saldoInicial, 150.0);
      expect(futuroDto.saldoFinal, 200.0);
    });
  });
}
