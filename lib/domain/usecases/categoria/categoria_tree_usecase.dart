import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/utils/comparers/string_comparer.dart';

class CategoriaTreeUseCase {
  List<CategoriaDetails> build(List<Categoria> categorias) {
    // 1. Cria representações parciais (sem filhos) de todas as categorias
    // para podermos usar como categoriaPai ao construir os nós
    final Map<String, CategoriaDetails> partialNodes = {};

    CategoriaDetails? getOrCreateParent(String? parentId) {
      if (parentId == null) return null;
      if (partialNodes.containsKey(parentId)) return partialNodes[parentId];

      final parentCat = categorias.where((c) => c.id == parentId).firstOrNull;
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
    for (final c in categorias) {
      getOrCreateParent(c.id);
    }

    // 2. Constrói recursivamente a árvore com os filhos populados
    CategoriaDetails buildNode(Categoria c) {
      final children = categorias
          .where(
            (child) => child.categoriaPaiId == c.id, //
          )
          .toList();
      children.sort(
        (a, b) => StringComparer.compareIgnoreAccents(
          a.descricao,
          b.descricao, //
        ),
      );

      final parentNode = getOrCreateParent(c.categoriaPaiId);

      return CategoriaDetails(
        id: c.id,
        descricao: c.descricao,
        ativo: c.ativo,
        categoriaPai: parentNode,
        subcategorias: children.map(buildNode).toList(),
      );
    }

    final allIds = categorias.map((c) => c.id).toSet();
    final rootNodes = categorias
        .where(
          (c) => c.categoriaPaiId == null || !allIds.contains(c.categoriaPaiId), //
        )
        .toList();
    rootNodes.sort(
      (a, b) => StringComparer.compareIgnoreAccents(
        a.descricao,
        b.descricao, //
      ),
    );

    return rootNodes.map(buildNode).toList();
  }
}
