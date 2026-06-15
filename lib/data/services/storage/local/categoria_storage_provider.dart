import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

final categoriaStorageProvider = Provider<LocalStorage<Categoria>>(
  (ref) => LocalStorage<Categoria>(
    collectionName: 'categorias',
    fromJson: (json) => Categoria.fromJson(json),
    toJson: (categoria) => categoria.toJson(),
  ),
);
