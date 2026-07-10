import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_state.dart';
import 'package:zzuna/domain/models/lancamento_resumo_mensal.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_resumo_mensal_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/sync_recorrencias_mes_usecase.dart';

class LancamentosListViewModel extends ChangeNotifier {
  final LancamentoDetailsUseCase _detailsUseCase;
  final LancamentoFilterUseCase _filterUseCase;
  final LancamentoResumoMensalUseCase _resumoMensalUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoFaturaRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final SyncRecorrenciasMesUseCase _syncRecorrenciasMesUseCase;
  StreamSubscription? _repositorySubscription;

  List<LancamentoDetails> _allLancamentos = [];
  final List<ExtratoFatura> _currentExtratos = [];
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

  bool get allSelected {
    final visibleIds =
        resumoMensal?.dias
            .expand((dia) => dia.lancamentos)
            .map((l) => l.id)
            .toList() ??
        [];
    if (visibleIds.isEmpty) return false;
    return visibleIds.every((id) => _selectedLancamentoIds.contains(id));
  }

  void selectAll() {
    final visibleIds =
        resumoMensal?.dias
            .expand((dia) => dia.lancamentos)
            .map((l) => l.id)
            .toList() ??
        [];
    _selectedLancamentoIds.addAll(visibleIds);
    notifyListeners();
  }

  void toggleSelectAll() {
    if (allSelected) {
      final visibleIds =
          resumoMensal?.dias
              .expand((dia) => dia.lancamentos)
              .map((l) => l.id)
              .toList() ??
          [];
      _selectedLancamentoIds.removeAll(visibleIds);
    } else {
      selectAll();
    }
    notifyListeners();
  }

  bool _pendingLoad = false;

  LancamentosListViewModel(
    this._detailsUseCase,
    this._filterUseCase,
    this._resumoMensalUseCase,
    this._repository,
    this._extratoFaturaRepository,
    this._contaRepository,
    this._cartaoRepository,
    this._syncRecorrenciasMesUseCase,
  ) {
    _repositorySubscription = _repository.observer().listen((event) {
      bool shouldReload = true;

      if (event is RepositoryCreated<Lancamento>) {
        shouldReload = _affectsCurrentOrPastMonth(event.model);
      } else if (event is RepositoryUpdated<Lancamento>) {
        shouldReload = _affectsCurrentOrPastMonth(event.model);
        if (!shouldReload &&
            _allLancamentos.any((l) => l.id == event.model.id)) {
          shouldReload = true;
        }
      }

      if (shouldReload) {
        _triggerLoad();
      }
    });

    loadCommand.addListener(() {
      if (!loadCommand.value.isRunning && _pendingLoad) {
        _pendingLoad = false;
        loadCommand.execute();
      }
    });
  }

  void _triggerLoad() {
    if (loadCommand.value.isRunning) {
      _pendingLoad = true;
    } else {
      _pendingLoad = false;
      loadCommand.execute();
    }
  }

  bool _affectsCurrentOrPastMonth(Lancamento lancamento) {
    final mes = _currentFilter.mes ?? Mes.fromDate(DateTime.now());
    final ano = _currentFilter.ano ?? DateTime.now().year;
    return lancamento.data.year <= ano &&
        (lancamento.data.year < ano || lancamento.data.month <= mes.index);
  }

  late final loadCommand = Command0(_load);

  AsyncResult<LancamentoResumoMensal> _load() async {
    _selectedLancamentoIds.clear(); // Clear selection when period loads/changes

    final mes = _currentFilter.mes ?? Mes.fromDate(DateTime.now());
    final ano = _currentFilter.ano ?? DateTime.now().year;

    await _syncRecorrenciasMesUseCase.execute(mes, ano);

    final contasResult = await _contaRepository.getAll();
    final cartoesResult = await _cartaoRepository.getAll();
    if (contasResult.isError()) {
      return Failure(contasResult.exceptionOrNull()!);
    }
    if (cartoesResult.isError()) {
      return Failure(cartoesResult.exceptionOrNull()!);
    }

    final origens = [
      ...contasResult.getOrThrow().map(
        (c) => LancamentoOrigem.conta(contaId: c.id),
      ),
      ...cartoesResult.getOrThrow().map(
        (c) => LancamentoOrigem.cartao(cartaoId: c.id),
      ),
    ];

    _currentExtratos.clear();
    for (final origem in origens) {
      final extratoResult = await _extratoFaturaRepository
          .searchLatestBeforeOrAt(origem, ano, mes);
      if (extratoResult.isError()) {
        return Failure(extratoResult.exceptionOrNull()!);
      }
      final extratos = extratoResult.getOrThrow();
      if (extratos.isNotEmpty) {
        _currentExtratos.add(extratos.first);
      }
    }

    final allDetails = await _detailsUseCase.execute(mes: mes, ano: ano);
    _allLancamentos = allDetails;
    _applyFilter();
    return Success(resumoMensal!);
  }

  void _applyFilter() {
    final filtered = _filterUseCase.execute(_allLancamentos, _currentFilter);
    final temFiltroRestritivo =
        _currentFilter.categoriasSelecionadas.isNotEmpty ||
        _currentFilter.centrosSelecionados.isNotEmpty;

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
        newFilter.mes != _currentFilter.mes ||
        newFilter.ano != _currentFilter.ano;

    _currentFilter = newFilter;

    if (periodChanged) {
      _triggerLoad();
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
