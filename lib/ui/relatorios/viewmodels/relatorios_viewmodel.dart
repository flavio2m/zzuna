import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/models/relatorio/relatorio_mensal_model.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/relatorio/get_relatorio_mensal_usecase.dart';

class RelatoriosViewModel extends ChangeNotifier {
  final LancamentoDetailsUseCase _detailsUseCase;
  final GetRelatorioMensalUseCase _getRelatorioMensalUseCase;
  final LancamentoRepository _repository;
  StreamSubscription? _repositorySubscription;

  Mes _currentMes = Mes.fromDate(DateTime.now());
  int _currentAno = DateTime.now().year;

  RelatorioMensalModel? relatorio;

  LancamentoTipo _selectedTipo = LancamentoTipo.despesa;
  String? _selectedCategoriaPaiIdDespesa;
  String? _selectedCategoriaPaiIdReceita;

  String? _selectedCentroCustoIdDespesa;
  String? _selectedCentroCustoIdReceita;
  String? _selectedCCCategoriaPaiIdDespesa;
  String? _selectedCCCategoriaPaiIdReceita;

  LancamentoTipo get selectedTipo => _selectedTipo;

  List<RelatorioCategoriaPaiGroup> get currentCategoriasPai {
    if (relatorio == null) return const [];
    return _selectedTipo == LancamentoTipo.despesa
        ? relatorio!.categoriasPaiDespesas
        : relatorio!.categoriasPaiReceitas;
  }

  String? get selectedCategoriaPaiId {
    return _selectedTipo == LancamentoTipo.despesa
        ? _selectedCategoriaPaiIdDespesa
        : _selectedCategoriaPaiIdReceita;
  }

  RelatorioCategoriaPaiGroup? get selectedCategoriaPaiGroup {
    final list = currentCategoriasPai;
    if (list.isEmpty) return null;
    final currentId = selectedCategoriaPaiId;
    if (currentId == null) return list.first;
    return list.firstWhere(
      (cat) => cat.categoriaPai.id == currentId,
      orElse: () => list.first,
    );
  }

  // Cost Center Getters
  List<RelatorioCentroCustoGroup> get currentCentrosDeCusto {
    if (relatorio == null) return const [];
    return _selectedTipo == LancamentoTipo.despesa
        ? relatorio!.centrosDeCustoDespesas
        : relatorio!.centrosDeCustoReceitas;
  }

  String? get selectedCentroCustoId {
    return _selectedTipo == LancamentoTipo.despesa
        ? _selectedCentroCustoIdDespesa
        : _selectedCentroCustoIdReceita;
  }

  RelatorioCentroCustoGroup? get selectedCentroCustoGroup {
    final list = currentCentrosDeCusto;
    if (list.isEmpty) return null;
    final currentId = selectedCentroCustoId;
    if (currentId == null) return list.first;
    return list.firstWhere(
      (cc) => cc.centroCusto.id == currentId,
      orElse: () => list.first,
    );
  }

  String? get selectedCCCategoriaPaiId {
    return _selectedTipo == LancamentoTipo.despesa
        ? _selectedCCCategoriaPaiIdDespesa
        : _selectedCCCategoriaPaiIdReceita;
  }

  RelatorioCategoriaPaiGroup? get selectedCCCategoriaPaiGroup {
    final ccGroup = selectedCentroCustoGroup;
    if (ccGroup == null || ccGroup.categoriasPai.isEmpty) return null;
    final currentId = selectedCCCategoriaPaiId;
    if (currentId == null) return ccGroup.categoriasPai.first;
    return ccGroup.categoriasPai.firstWhere(
      (cat) => cat.categoriaPai.id == currentId,
      orElse: () => ccGroup.categoriasPai.first,
    );
  }

  late final loadCommand = Command0(_load);

  RelatoriosViewModel(
    this._detailsUseCase,
    this._getRelatorioMensalUseCase,
    this._repository,
  ) {
    _repositorySubscription = _repository.observer().listen((event) {
      if (event is RepositoryCreated<Lancamento> ||
          event is RepositoryUpdated<Lancamento> ||
          event is RepositoryDeleted<Lancamento>) {
        loadCommand.execute();
      }
    });
  }

  void updateFilter(Mes mes, int ano) {
    if (_currentMes != mes || _currentAno != ano) {
      _currentMes = mes;
      _currentAno = ano;
      loadCommand.execute();
    }
  }

  void selectTipo(LancamentoTipo tipo) {
    if (_selectedTipo != tipo) {
      _selectedTipo = tipo;
      _ensureValidDefaults();
      notifyListeners();
    }
  }

  void selectCategoriaPai(String id) {
    if (_selectedTipo == LancamentoTipo.despesa) {
      if (_selectedCategoriaPaiIdDespesa != id) {
        _selectedCategoriaPaiIdDespesa = id;
        notifyListeners();
      }
    } else {
      if (_selectedCategoriaPaiIdReceita != id) {
        _selectedCategoriaPaiIdReceita = id;
        notifyListeners();
      }
    }
  }

  void selectCentroCusto(String id) {
    if (_selectedTipo == LancamentoTipo.despesa) {
      if (_selectedCentroCustoIdDespesa != id) {
        _selectedCentroCustoIdDespesa = id;
        _selectedCCCategoriaPaiIdDespesa = null;
        _ensureValidCcCategoryDefaults();
        notifyListeners();
      }
    } else {
      if (_selectedCentroCustoIdReceita != id) {
        _selectedCentroCustoIdReceita = id;
        _selectedCCCategoriaPaiIdReceita = null;
        _ensureValidCcCategoryDefaults();
        notifyListeners();
      }
    }
  }

  void selectCCCategoriaPai(String id) {
    if (_selectedTipo == LancamentoTipo.despesa) {
      if (_selectedCCCategoriaPaiIdDespesa != id) {
        _selectedCCCategoriaPaiIdDespesa = id;
        notifyListeners();
      }
    } else {
      if (_selectedCCCategoriaPaiIdReceita != id) {
        _selectedCCCategoriaPaiIdReceita = id;
        notifyListeners();
      }
    }
  }

  void _ensureValidDefaults() {
    if (relatorio == null) return;

    final catList = currentCategoriasPai;
    if (_selectedTipo == LancamentoTipo.despesa) {
      if (catList.isNotEmpty &&
          (_selectedCategoriaPaiIdDespesa == null ||
              !catList.any(
                (c) => c.categoriaPai.id == _selectedCategoriaPaiIdDespesa,
              ))) {
        _selectedCategoriaPaiIdDespesa = catList.first.categoriaPai.id;
      }
    } else {
      if (catList.isNotEmpty &&
          (_selectedCategoriaPaiIdReceita == null ||
              !catList.any(
                (c) => c.categoriaPai.id == _selectedCategoriaPaiIdReceita,
              ))) {
        _selectedCategoriaPaiIdReceita = catList.first.categoriaPai.id;
      }
    }

    final ccList = currentCentrosDeCusto;
    if (_selectedTipo == LancamentoTipo.despesa) {
      if (ccList.isNotEmpty &&
          (_selectedCentroCustoIdDespesa == null ||
              !ccList.any(
                (c) => c.centroCusto.id == _selectedCentroCustoIdDespesa,
              ))) {
        _selectedCentroCustoIdDespesa = ccList.first.centroCusto.id;
      }
    } else {
      if (ccList.isNotEmpty &&
          (_selectedCentroCustoIdReceita == null ||
              !ccList.any(
                (c) => c.centroCusto.id == _selectedCentroCustoIdReceita,
              ))) {
        _selectedCentroCustoIdReceita = ccList.first.centroCusto.id;
      }
    }

    _ensureValidCcCategoryDefaults();
  }

  void _ensureValidCcCategoryDefaults() {
    final ccGroup = selectedCentroCustoGroup;
    if (ccGroup == null || ccGroup.categoriasPai.isEmpty) {
      if (_selectedTipo == LancamentoTipo.despesa) {
        _selectedCCCategoriaPaiIdDespesa = null;
      } else {
        _selectedCCCategoriaPaiIdReceita = null;
      }
      return;
    }

    if (_selectedTipo == LancamentoTipo.despesa) {
      if (_selectedCCCategoriaPaiIdDespesa == null ||
          !ccGroup.categoriasPai.any(
            (c) => c.categoriaPai.id == _selectedCCCategoriaPaiIdDespesa,
          )) {
        _selectedCCCategoriaPaiIdDespesa =
            ccGroup.categoriasPai.first.categoriaPai.id;
      }
    } else {
      if (_selectedCCCategoriaPaiIdReceita == null ||
          !ccGroup.categoriasPai.any(
            (c) => c.categoriaPai.id == _selectedCCCategoriaPaiIdReceita,
          )) {
        _selectedCCCategoriaPaiIdReceita =
            ccGroup.categoriasPai.first.categoriaPai.id;
      }
    }
  }

  AsyncResult<RelatorioMensalModel> _load() async {
    try {
      final lancamentos = await _detailsUseCase.execute(
        mes: _currentMes,
        ano: _currentAno,
      );

      relatorio = _getRelatorioMensalUseCase.execute(lancamentos);
      _ensureValidDefaults();

      notifyListeners();
      return Success(relatorio!);
    } catch (e) {
      return Failure(Exception('Erro ao carregar relatório: $e'));
    }
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
