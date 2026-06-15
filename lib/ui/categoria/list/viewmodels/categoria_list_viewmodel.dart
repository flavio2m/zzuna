import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_filter_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_filter_usecase.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/utils/comparers/string_comparer.dart';

class CategoriaListViewModel extends ChangeNotifier {
  final CategoriaRepository _repository;
  final CategoriaFilterUseCase _filterUseCase;
  final CategoriaTreeUseCase _treeUseCase;
  StreamSubscription? _repositorySubscription;

  // Itens da barra de filtro
  String? descricaoQuery;
  bool? statusSelecionado;

  /// Árvore de CategoriaDetails respeitando o filtro ativo
  List<CategoriaDetails> categorias = [];

  /// Todas as categorias raiz SEM filtro (usadas nos dropdowns dos modais)
  List<Categoria> categoriasPai = [];

  /// Conjunto de IDs das categorias colapsadas na UI
  final Set<String> collapsedIds = {};

  /// Status de se todas as categorias estão colapsadas
  bool isAllCollapsed = false;

  void toggleCollapsed(String id) {
    if (collapsedIds.contains(id)) {
      collapsedIds.remove(id);
    } else {
      collapsedIds.add(id);
    }
    notifyListeners();
  }

  void toggleAllCollapsed() {
    isAllCollapsed = !isAllCollapsed;
    if (isAllCollapsed) {
      for (final cat in categorias) {
        collapsedIds.add(cat.id);
        _collapseAllRecursive(cat);
      }
    } else {
      collapsedIds.clear();
    }
    notifyListeners();
  }

  void _collapseAllRecursive(CategoriaDetails parent) {
    for (final child in parent.subcategorias) {
      collapsedIds.add(child.id);
      _collapseAllRecursive(child);
    }
  }

  CategoriaListViewModel(this._repository, this._filterUseCase, this._treeUseCase) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<List<CategoriaDetails>> _load() async {
    // 1. Carrega tudo para popular o dropdown de categoria pai
    final todasResult = await _repository.getAll();
    List<Categoria> todas = [];
    if (todasResult.isSuccess()) {
      todas = todasResult.getOrThrow();
      categoriasPai = todas.where((c) => c.categoriaPaiId == null).toList()
        ..sort(
          (a, b) => StringComparer.compareIgnoreAccents(
            a.descricao,
            b.descricao, //
          ),
        );
    }

    // 2. Busca com filtro para popular a listagem
    final filter = CategoriaFilterDto(
      descricao: descricaoQuery ?? '',
      ativo: statusSelecionado, //
    );

    final result = await _repository.search(filter);
    final todasList = todas;

    return result.map((list) {
      List<Categoria> finalFilteredList = list;

      // Se houver qualquer filtro ativo, expande com os ancestrais necessários
      // via UseCase
      if ((descricaoQuery != null && descricaoQuery!.isNotEmpty) ||
          statusSelecionado !=
              null //
              ) {
        finalFilteredList = _filterUseCase.expandParents(list, todasList);
      }

      categorias = _treeUseCase.build(finalFilteredList);
      return categorias;
    });
  }

  void setDescricao(String value) {
    descricaoQuery = value;
  }

  void setStatus(bool? value) {
    statusSelecionado = value;
    loadCommand.execute();
  }

  void pesquisar() {
    loadCommand.execute();
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
