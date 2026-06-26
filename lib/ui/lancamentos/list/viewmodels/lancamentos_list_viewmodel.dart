import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_state.dart';
import 'package:zzuna/domain/models/lancamento_resumo_mensal.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_resumo_mensal_usecase.dart';

class LancamentosListViewModel extends ChangeNotifier {
  final LancamentoDetailsUseCase _detailsUseCase;
  final LancamentoFilterUseCase _filterUseCase;
  final LancamentoResumoMensalUseCase _resumoMensalUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoFaturaRepository;
  StreamSubscription? _repositorySubscription;

  List<LancamentoDetails> _allLancamentos = [];
  List<ExtratoFatura> _currentExtratos = [];
  LancamentoFilterDto _currentFilter = LancamentoFilterDto(
    mes: Mes.fromDate(DateTime.now()),
    ano: DateTime.now().year, //
  );

  LancamentoResumoMensal? resumoMensal;

  final Set<String> _selectedLancamentoIds = {};
  Set<String> get selectedLancamentoIds => _selectedLancamentoIds;

  void toggleSelection(String id) {
    if (_selectedLancamentoIds.contains(id)) {
      _selectedLancamentoIds.remove(id);
    } else {
      _selectedLancamentoIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedLancamentoIds.clear();
    notifyListeners();
  }

  void toggleSelectionForList(List<String> ids, bool select) {
    if (select) {
      _selectedLancamentoIds.addAll(ids);
    } else {
      _selectedLancamentoIds.removeAll(ids);
    }
    notifyListeners();
  }

  LancamentosListViewModel(
    this._detailsUseCase,
    this._filterUseCase,
    this._resumoMensalUseCase,
    this._repository,
    this._extratoFaturaRepository,
  ) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<LancamentoResumoMensal> _load() async {
    _selectedLancamentoIds.clear(); // Clear selection when period loads/changes

    final mes = _currentFilter.mes ?? Mes.fromDate(DateTime.now());
    final ano = _currentFilter.ano ?? DateTime.now().year;

    final extratoResult = await _extratoFaturaRepository.search(
      ExtratoFaturaFilterDto(mes: mes, ano: ano), //
    );
    if (extratoResult.isError()) {
      return Failure(extratoResult.exceptionOrNull()!);
    }
    _currentExtratos = extratoResult.getOrThrow();

    final allDetails = await _detailsUseCase.execute(mes: mes, ano: ano);
    _allLancamentos = allDetails;
    _applyFilter();
    return Success(resumoMensal!);
  }

  void _applyFilter() {
    final filtered = _filterUseCase.execute(_allLancamentos, _currentFilter);
    final temFiltroRestritivo =
        _currentFilter.categoriasSelecionadas.isNotEmpty || _currentFilter.centrosSelecionados.isNotEmpty;

    resumoMensal = _resumoMensalUseCase.execute(
      filtered,
      extratos: _currentExtratos,
      contasSelecionadas: _currentFilter.contasSelecionadas,
      cartoesSelecionados: _currentFilter.cartoesSelecionados,
      temFiltroRestritivo: temFiltroRestritivo,
      mes: _currentFilter.mes ?? Mes.fromDate(DateTime.now()),
      ano: _currentFilter.ano ?? DateTime.now().year,
    );
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
