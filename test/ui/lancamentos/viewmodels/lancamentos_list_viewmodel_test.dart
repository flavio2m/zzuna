import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/ui/lancamentos/list/viewmodels/lancamentos_list_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_resumo_mensal_usecase.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_notifier.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_state.dart';
import 'package:zzuna/data/repositories/base_repository.dart';

class FakeLancamentoDetailsUseCase implements LancamentoDetailsUseCase {
  int executeCallCount = 0;

  @override
  Future<List<LancamentoDetails>> execute({required Mes mes, required int ano}) async {
    executeCallCount++;
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLancamentoFilterUseCase implements LancamentoFilterUseCase {
  @override
  List<LancamentoDetails> execute(List<LancamentoDetails> list, LancamentoFilterDto filter) {
    return list;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLancamentoRepository implements LancamentoRepository {
  @override
  Stream<RepositoryEvent<Lancamento>> observer() => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeExtratoFaturaRepository implements ExtratoFaturaRepository {
  @override
  AsyncResult<List<ExtratoFatura>> search(ExtratoFaturaFilterDto filter) async {
    return const Success([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LancamentoFilterNotifier Navigation Tests', () {
    late LancamentoFilterNotifier notifier;

    setUp(() {
      notifier = LancamentoFilterNotifier();
    });

    test('initial state matches current date', () {
      final now = DateTime.now();
      expect(notifier.state.mes.numero, now.month);
      expect(notifier.state.ano, now.year);
    });

    test('mesAnterior decreases month', () {
      notifier.state = notifier.state.copyWith(mes: Mes.fevereiro, ano: 2026);

      notifier.mesAnterior();

      expect(notifier.state.mes, Mes.janeiro);
      expect(notifier.state.ano, 2026);
    });

    test('mesAnterior wraps to previous year on January', () {
      notifier.state = notifier.state.copyWith(mes: Mes.janeiro, ano: 2026);

      notifier.mesAnterior();

      expect(notifier.state.mes, Mes.dezembro);
      expect(notifier.state.ano, 2025);
    });

    test('mesAnterior does not wrap before minimum limit (January 2025)', () {
      notifier.state = notifier.state.copyWith(mes: Mes.janeiro, ano: 2025);

      notifier.mesAnterior();

      expect(notifier.state.mes, Mes.janeiro);
      expect(notifier.state.ano, 2025);
    });

    test('proximoMes increases month', () {
      notifier.state = notifier.state.copyWith(mes: Mes.janeiro, ano: 2026);

      notifier.proximoMes();

      expect(notifier.state.mes, Mes.fevereiro);
      expect(notifier.state.ano, 2026);
    });

    test('proximoMes wraps to next year on December', () {
      notifier.state = notifier.state.copyWith(mes: Mes.dezembro, ano: 2026);

      notifier.proximoMes();

      expect(notifier.state.mes, Mes.janeiro);
      expect(notifier.state.ano, 2027);
    });

    test('proximoMes does not wrap after maximum limit (December of current year + 2)', () {
      final maxYear = DateTime.now().year + 2;
      notifier.state = notifier.state.copyWith(mes: Mes.dezembro, ano: maxYear);

      notifier.proximoMes();

      expect(notifier.state.mes, Mes.dezembro);
      expect(notifier.state.ano, maxYear);
    });

    test('setTipo updates type and allows resetting to null', () {
      notifier.setTipo(LancamentoTipo.receita);
      expect(notifier.state.tipo, LancamentoTipo.receita);

      notifier.setTipo(null);
      expect(notifier.state.tipo, isNull);
    });

    test('setConciliado updates conciliated and allows resetting to null', () {
      notifier.setConciliado(true);
      expect(notifier.state.conciliado, isTrue);

      notifier.setConciliado(null);
      expect(notifier.state.conciliado, isNull);
    });
  });

  group('LancamentosListViewModel Cache and Filtering Tests', () {
    late LancamentosListViewModel viewModel;
    late FakeLancamentoDetailsUseCase detailsUseCase;

    setUp(() {
      detailsUseCase = FakeLancamentoDetailsUseCase();
      viewModel = LancamentosListViewModel(
        detailsUseCase,
        FakeLancamentoFilterUseCase(),
        LancamentoResumoMensalUseCase(),
        FakeLancamentoRepository(),
        FakeExtratoFaturaRepository(),
      );
    });

    test('updateFilter with same period does not query repository again', () async {
      final initialFilter = LancamentoFilterState(mes: Mes.janeiro, ano: 2026, descricao: '');

      // 1. Initial filter update (triggers load because it is the first time or different period)
      viewModel.updateFilter(initialFilter);
      await Future<void>.delayed(Duration.zero);
      expect(detailsUseCase.executeCallCount, 1);

      // 2. Update filters without changing period (e.g. change description)
      final newFilter = initialFilter.copyWith(descricao: 'Supermercado');
      viewModel.updateFilter(newFilter);
      await Future<void>.delayed(Duration.zero);

      // Call count should still be 1 (filtered in-memory)
      expect(detailsUseCase.executeCallCount, 1);
    });

    test('updateFilter with different period queries repository', () async {
      final initialFilter = LancamentoFilterState(mes: Mes.janeiro, ano: 2026, descricao: '');

      viewModel.updateFilter(initialFilter);
      await Future<void>.delayed(Duration.zero);
      expect(detailsUseCase.executeCallCount, 1);

      // Change month to February
      final newFilter = initialFilter.copyWith(mes: Mes.fevereiro);
      viewModel.updateFilter(newFilter);
      await Future<void>.delayed(Duration.zero);

      // Call count should increase to 2
      expect(detailsUseCase.executeCallCount, 2);
    });
  });
}
