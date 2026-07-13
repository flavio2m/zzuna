import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

final contaStorageProvider = Provider<BaseStorage<Conta>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<Conta>(
      collectionName: 'contas',
      fromJson: (json) => Conta.fromJson(json),
      toJson: (conta) => conta.toJson(),
    );
  } else {
    return FirebaseRealtimeStorage<Conta>(
      collectionName: 'contas',
      fromJson: (json) => Conta.fromJson(json),
      toJson: (conta) => conta.toJson(),
    );
  }
});
