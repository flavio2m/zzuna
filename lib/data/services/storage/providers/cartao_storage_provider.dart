import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

final cartaoStorageProvider = Provider<BaseStorage<Cartao>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<Cartao>(
      collectionName: 'cartoes',
      fromJson: (json) => Cartao.fromJson(json),
      toJson: (cartao) => cartao.toJson(),
    );
  } else {
    return FirebaseRealtimeStorage<Cartao>(
      collectionName: 'cartoes',
      fromJson: (json) => Cartao.fromJson(json),
      toJson: (cartao) => cartao.toJson(),
    );
  }
});
