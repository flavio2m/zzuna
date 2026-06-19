import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_state.dart';

class LancamentosListViewModel extends ChangeNotifier {
  final LancamentoDetailsUseCase _detailsUseCase;
  final LancamentoFilterUseCase _filterUseCase;
  final LancamentoRepository _repository;
  StreamSubscription? _repositorySubscription;

  List<LancamentoDetails> _allLancamentos = [];
  LancamentoFilterDto _currentFilter = LancamentoFilterDto(mes: Mes.fromDate(DateTime.now()), ano: DateTime.now().year);

  List<LancamentoDetails> lancamentos = [];

  LancamentosListViewModel(this._detailsUseCase, this._filterUseCase, this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<List<LancamentoDetails>> _load() async {
    try {
      final mes = _currentFilter.mes ?? Mes.fromDate(DateTime.now());
      final ano = _currentFilter.ano ?? DateTime.now().year;
      final allDetails = await _detailsUseCase.execute(mes: mes, ano: ano);
      _allLancamentos = allDetails;
      _applyFilter();
      return Success(lancamentos);
    } catch (e) {
      return Failure(Exception('Erro ao carregar lançamentos: $e'));
    }
  }

  void _applyFilter() {
    final filtered = _filterUseCase.execute(_allLancamentos, _currentFilter);
    lancamentos = filtered;
    notifyListeners();
  }

  void updateFilter(LancamentoFilterState filterState) {
    final newFilter = LancamentoFilterDto(
      descricao: filterState.descricao,
      tipo: filterState.tipo,
      conciliado: filterState.conciliado,
      mes: filterState.mes,
      ano: filterState.ano,
      contasSelecionadas: filterState.contasSelecionadas,
      cartoesSelecionados: filterState.cartoesSelecionados,
      centrosSelecionados: filterState.centrosSelecionados,
      categoriasSelecionadas: filterState.categoriasSelecionadas,
    );

    final periodChanged = //
        newFilter.mes != _currentFilter.mes || newFilter.ano != _currentFilter.ano;

    _currentFilter = newFilter;

    if (periodChanged) {
      loadCommand.execute();
    } else {
      _applyFilter();
    }
  }

  void pesquisar() {
    _applyFilter();
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
