import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/ui/lancamentos/viewmodels/lancamentos_list_viewmodel.dart';

import 'package:zzuna/data/repositories/base_repository.dart';

// Fake implementations for testing VM logic
class FakeLancamentoDetailsUseCase implements LancamentoDetailsUseCase {
  @override
  Future<List<LancamentoDetails>> execute({required Mes mes, required int ano}) async {
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

void main() {
  late LancamentosListViewModel viewModel;

  setUp(() {
    viewModel = LancamentosListViewModel(
      FakeLancamentoDetailsUseCase(),
      FakeLancamentoFilterUseCase(),
      FakeLancamentoRepository(),
    );
  });

  group('LancamentosListViewModel Navigation Tests', () {
    test('initial state', () {
      final now = DateTime.now();
      expect(viewModel.mesSelecionado.numero, now.month);
      expect(viewModel.anoSelecionado, now.year);
    });

    test('mesAnterior decreases month', () {
      viewModel.mesSelecionado = Mes.fevereiro;
      viewModel.anoSelecionado = 2026;

      viewModel.mesAnterior();

      expect(viewModel.mesSelecionado, Mes.janeiro);
      expect(viewModel.anoSelecionado, 2026);
    });

    test('mesAnterior wraps to previous year on January', () {
      viewModel.mesSelecionado = Mes.janeiro;
      viewModel.anoSelecionado = 2026;

      viewModel.mesAnterior();

      expect(viewModel.mesSelecionado, Mes.dezembro);
      expect(viewModel.anoSelecionado, 2025);
    });

    test('mesAnterior does not wrap before minimum limit (January 2025)', () {
      viewModel.mesSelecionado = Mes.janeiro;
      viewModel.anoSelecionado = 2025;

      viewModel.mesAnterior();

      // Should remain at January 2025
      expect(viewModel.mesSelecionado, Mes.janeiro);
      expect(viewModel.anoSelecionado, 2025);
    });

    test('proximoMes increases month', () {
      viewModel.mesSelecionado = Mes.janeiro;
      viewModel.anoSelecionado = 2026;

      viewModel.proximoMes();

      expect(viewModel.mesSelecionado, Mes.fevereiro);
      expect(viewModel.anoSelecionado, 2026);
    });

    test('proximoMes wraps to next year on December', () {
      viewModel.mesSelecionado = Mes.dezembro;
      viewModel.anoSelecionado = 2026;

      viewModel.proximoMes();

      expect(viewModel.mesSelecionado, Mes.janeiro);
      expect(viewModel.anoSelecionado, 2027);
    });

    test('proximoMes does not wrap after maximum limit (December of current year + 2)', () {
      final maxYear = DateTime.now().year + 2;
      viewModel.mesSelecionado = Mes.dezembro;
      viewModel.anoSelecionado = maxYear;

      viewModel.proximoMes();

      // Should remain at December maxYear
      expect(viewModel.mesSelecionado, Mes.dezembro);
      expect(viewModel.anoSelecionado, maxYear);
    });
  });
}
