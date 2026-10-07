import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
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

  CategoriaListViewModel(
    this._repository,
    this._filterUseCase,
    this._treeUseCase,
  ) {
    _repositorySubscription = _repository.observer().listen((event) {
      if (event is RepositoryUpdated<Categoria>) {
        _handleRepositoryUpdated(event.model);
      } else {
        loadCommand.execute();
      }
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

  void _handleRepositoryUpdated(Categoria updated) {
    // Se a listagem ainda não foi carregada em memória, roda a carga completa
    if (categorias.isEmpty && categoriasPai.isEmpty) {
      loadCommand.execute();
      return;
    }

    final existingPaiId = _findCategoriaPaiId(updated.id);

    // Se houve mudança de nível hierárquico (mudança de pai), é uma mudança estrutural na árvore
    if (existingPaiId != updated.categoriaPaiId) {
      loadCommand.execute();
      return;
    }

    // Se a categoria não estiver em memória (ex: filtrada), recarrega
    if (!_containsCategoria(updated.id)) {
      loadCommand.execute();
      return;
    }

    // Atualização pontual em memória (ex: percentual de orçamento, cor, descrição, ativo)
    // Atualiza imediatamente sem disparar loadCommand nem exibir loading
    _updateCategoriaPontual(updated);
  }

  bool _containsCategoria(String id) {
    if (categoriasPai.any((c) => c.id == id)) return true;
    for (final root in categorias) {
      if (root.id == id) return true;
      if (_hasInSubcategorias(root.subcategorias, id)) return true;
    }
    return false;
  }

  bool _hasInSubcategorias(List<CategoriaDetails> subs, String id) {
    for (final s in subs) {
      if (s.id == id) return true;
      if (_hasInSubcategorias(s.subcategorias, id)) return true;
    }
    return false;
  }

  String? _findCategoriaPaiId(String id) {
    for (final p in categoriasPai) {
      if (p.id == id) return p.categoriaPaiId;
    }
    for (final root in categorias) {
      if (root.id == id) return root.categoriaPai?.id;
      final found = _findInSubcategorias(root.subcategorias, id);
      if (found != null) return found;
    }
    return null;
  }

  String? _findInSubcategorias(List<CategoriaDetails> subs, String id) {
    for (final s in subs) {
      if (s.id == id) return s.categoriaPai?.id;
      final childFound = _findInSubcategorias(s.subcategorias, id);
      if (childFound != null) return childFound;
    }
    return null;
  }

  void _updateCategoriaPontual(Categoria updated) {
    // 1. Atualiza em categoriasPai se for categoria raiz
    final paiIndex = categoriasPai.indexWhere((c) => c.id == updated.id);
    if (paiIndex != -1) {
      final updatedList = List<Categoria>.from(categoriasPai);
      updatedList[paiIndex] = updated;
      categoriasPai = updatedList;
    }

    // 2. Atualiza pontualmente na árvore de categorias mantendo a hierarquia intacta
    categorias = categorias
        .map((node) => _updateNodeDetails(node, updated))
        .toList();

    notifyListeners();
  }

  CategoriaDetails _updateNodeDetails(
    CategoriaDetails node,
    Categoria updated,
  ) {
    if (node.id == updated.id) {
      final updatedNode = node.copyWith(
        descricao: updated.descricao,
        ativo: updated.ativo,
        percentualOrcamento: updated.percentualOrcamento,
        natureza: updated.natureza,
        cor: updated.cor,
      );
      if (node.subcategorias.isNotEmpty) {
        return updatedNode.copyWith(
          subcategorias: updatedNode.subcategorias
              .map((child) => child.copyWith(categoriaPai: updatedNode))
              .toList(),
        );
      }
      return updatedNode;
    }

    if (node.subcategorias.isEmpty) {
      return node;
    }

    return node.copyWith(
      subcategorias: node.subcategorias
          .map((child) => _updateNodeDetails(child, updated))
          .toList(),
    );
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
