import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/data/services/storage/cached/cached_storage_decorator.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';

final listaComprasStorageProvider = Provider<BaseStorage<ListaCompras>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<ListaCompras>(
      collectionName: 'listas_compras',
      fromJson: (json) => ListaCompras.fromJson(json),
      toJson: (lista) => lista.toJson(),
    );
  } else {
    return CachedStorageDecorator<ListaCompras>(
      collectionName: 'listas_compras',
      innerStorage: FirebaseRealtimeStorage<ListaCompras>(
        collectionName: 'listas_compras',
        fromJson: (json) => ListaCompras.fromJson(json),
        toJson: (lista) => lista.toJson(),
      ),
    );
  }
});
