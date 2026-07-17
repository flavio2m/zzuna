import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/data/services/storage/cached/cached_storage_decorator.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

final categoriaStorageProvider = Provider<BaseStorage<Categoria>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<Categoria>(
      collectionName: 'categorias',
      fromJson: (json) => Categoria.fromJson(json),
      toJson: (categoria) => categoria.toJson(),
    );
  } else {
    return CachedStorageDecorator<Categoria>(
      collectionName: 'categorias',
      // ttl: const Duration(minutes: 60),
      innerStorage: FirebaseRealtimeStorage<Categoria>(
        collectionName: 'categorias',
        fromJson: (json) => Categoria.fromJson(json),
        toJson: (categoria) => categoria.toJson(),
      ),
    );
  }
});
