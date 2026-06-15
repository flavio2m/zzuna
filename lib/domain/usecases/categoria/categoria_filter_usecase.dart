// lib/domain/usecases/categoria/categoria_filter_usecase.dart
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaFilterUseCase {
  List<Categoria> expandParents(
    List<Categoria> filtered,
    List<Categoria> all,
  ) {
    final Set<Categoria> expandedList = {...filtered};
    final todasMap = {for (final c in all) c.id: c};

    for (final item in filtered) {
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

    return expandedList.toList();
  }
}
