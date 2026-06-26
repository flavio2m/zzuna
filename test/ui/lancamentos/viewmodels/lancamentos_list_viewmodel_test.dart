import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
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
  List<LancamentoDetails> returnList = [];

  @override
  Future<List<LancamentoDetails>> execute({required Mes mes, required int ano}) async {
    executeCallCount++;
    return returnList;
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

  group('LancamentosListViewModel Selection Tests', () {
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

    final extratoFake = ExtratoFaturaDetails(
      id: 'ef-1',
      origem: LancamentoOrigemContaDetail(
        conta: ContaDetails(
          id: 'c-1',
          descricao: 'Conta 1',
          ativo: true,
          dataInicial: DateTime(2026, 1, 1),
          banco: const Banco(descricao: 'Banco 1', sigla: 'B1', icon: BancoIcon.outros),
        ),
      ),
      ano: 2026,
      mes: Mes.janeiro,
      dataInicio: DateTime(2026, 1, 1),
      dataFim: DateTime(2026, 1, 31),
      saldoInicial: 0.0,
      saldoFinal: 0.0,
      fechado: false,
    );

    LancamentoDetails buildLancamento(String id) {
      return LancamentoDetails(
        id: id,
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 1, 15),
        descricao: 'Lancamento $id',
        extratoFatura: extratoFake,
        origem: LancamentoOrigemContaDetail(
          conta: ContaDetails(
            id: 'c-1',
            descricao: 'Conta 1',
            ativo: true,
            dataInicial: DateTime(2026, 1, 1),
            banco: const Banco(descricao: 'Banco 1', sigla: 'B1', icon: BancoIcon.outros),
          ),
        ),
        itens: const [],
        conciliado: true,
      );
    }

    test('allSelected is false when there are no visible items', () {
      expect(viewModel.allSelected, isFalse);
    });

    test('selectAll and toggleSelectAll work correctly with visible items', () async {
      detailsUseCase.returnList = [
        buildLancamento('1'),
        buildLancamento('2'),
      ];

      // Load items
      viewModel.updateFilter(const LancamentoFilterState(
        mes: Mes.janeiro,
        ano: 2026,
        descricao: '',
      ));
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.allSelected, isFalse);
      expect(viewModel.selectedLancamentoIds, isEmpty);

      // Select all
      viewModel.selectAll();
      expect(viewModel.allSelected, isTrue);
      expect(viewModel.selectedLancamentoIds, containsAll(['1', '2']));

      // Toggle select all (should deselect since all are selected)
      viewModel.toggleSelectAll();
      expect(viewModel.allSelected, isFalse);
      expect(viewModel.selectedLancamentoIds, isEmpty);

      // Toggle select all again (should select all)
      viewModel.toggleSelectAll();
      expect(viewModel.allSelected, isTrue);
      expect(viewModel.selectedLancamentoIds, containsAll(['1', '2']));
    });
  });
}
