import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/data/services/storage/cached/cached_storage_decorator.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

final centroCustoStorageProvider = Provider<BaseStorage<CentroCusto>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<CentroCusto>(
      collectionName: 'centro_custos',
      fromJson: (json) => CentroCusto.fromJson(json),
      toJson: (centro) => centro.toJson(),
    );
  } else {
    return CachedStorageDecorator<CentroCusto>(
      collectionName: 'centro_custos',
      // ttl: const Duration(minutes: 60),
      innerStorage: FirebaseRealtimeStorage<CentroCusto>(
        collectionName: 'centro_custos',
        fromJson: (json) => CentroCusto.fromJson(json),
        toJson: (centro) => centro.toJson(),
      ),
    );
  }
});
