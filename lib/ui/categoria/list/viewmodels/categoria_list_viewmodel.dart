import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_filter_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaListViewModel extends ChangeNotifier {
  final CategoriaRepository _repository;
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

  CategoriaListViewModel(this._repository) {
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
        ..sort((a, b) => _compareDescriptions(a.descricao, b.descricao));
    }

    // 2. Busca com filtro para popular a listagem
    final filter = CategoriaFilterDto(
      descricao: descricaoQuery ?? '',
      ativo: statusSelecionado,
    );

    final result = await _repository.search(filter);
    final todasList = todas;

    return result.map((list) {
      // Cria um conjunto para evitar duplicados e adiciona os resultados do filtro
      final Set<Categoria> expandedList = {...list};

      // Se houver qualquer filtro ativo, adiciona os ancestrais dos itens filtrados
      if ((descricaoQuery != null && descricaoQuery!.isNotEmpty) || statusSelecionado != null) {
        final todasMap = {for (final c in todasList) c.id: c};

        for (final item in list) {
          String? parentId = item.categoriaPaiId;
          while (parentId != null) {
            final parent = todasMap[parentId];
            if (parent != null) {
              expandedList.add(parent);
              parentId = parent.categoriaPaiId;
            } else {
              break;
            }
          }
        }
      }

      categorias = _buildTree(expandedList.toList());
      return categorias;
    });
  }

  /// Constrói uma árvore rica de CategoriaDetails a partir da lista plana
  List<CategoriaDetails> _buildTree(List<Categoria> flatList) {
    // 1. Cria representações parciais (sem filhos) de todas as categorias
    // para podermos usar como categoriaPai ao construir os nós
    final Map<String, CategoriaDetails> partialNodes = {};

    CategoriaDetails? getOrCreateParent(String? parentId) {
      if (parentId == null) return null;
      if (partialNodes.containsKey(parentId)) return partialNodes[parentId];

      final parentCat = flatList.where((c) => c.id == parentId).firstOrNull;
      if (parentCat == null) return null;

      final parentOfParent = getOrCreateParent(parentCat.categoriaPaiId);
      final parentNode = CategoriaDetails(
        id: parentCat.id,
        descricao: parentCat.descricao,
        ativo: parentCat.ativo,
        categoriaPai: parentOfParent,
        subcategorias: [],
      );
      partialNodes[parentId] = parentNode;
      return parentNode;
    }

    // Inicializa todos os nós parciais
    for (final c in flatList) {
      getOrCreateParent(c.id);
    }

    // 2. Constrói recursivamente a árvore com os filhos populados
    CategoriaDetails buildNode(Categoria c) {
      final children = flatList.where((child) => child.categoriaPaiId == c.id).toList();
      children.sort((a, b) => _compareDescriptions(a.descricao, b.descricao));

      final parentNode = getOrCreateParent(c.categoriaPaiId);

      return CategoriaDetails(
        id: c.id,
        descricao: c.descricao,
        ativo: c.ativo,
        categoriaPai: parentNode,
        subcategorias: children.map(buildNode).toList(),
      );
    }

    final allIds = flatList.map((c) => c.id).toSet();
    final rootNodes = flatList.where((c) => c.categoriaPaiId == null || !allIds.contains(c.categoriaPaiId)).toList();
    rootNodes.sort((a, b) => _compareDescriptions(a.descricao, b.descricao));

    return rootNodes.map(buildNode).toList();
  }

  /// Compara descrições de forma insensível a caixa e acentuação (adequado para português)
  int _compareDescriptions(String a, String b) {
    String normalize(String s) {
      return s.toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ç', 'c');
    }
    return normalize(a).compareTo(normalize(b));
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
