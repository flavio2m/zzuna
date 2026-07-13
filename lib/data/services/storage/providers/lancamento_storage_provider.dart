import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

final lancamentoStorageProvider = Provider<BaseStorage<Lancamento>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<Lancamento>(
      collectionName: 'lancamentos',
      fromJson: (json) => Lancamento.fromJson(json),
      toJson: (lancamento) => lancamento.toJson(),
    );
  } else {
    return FirebaseRealtimeStorage<Lancamento>(
      collectionName: 'lancamentos',
      fromJson: (json) => Lancamento.fromJson(json),
      toJson: (lancamento) => lancamento.toJson(),
    );
  }
});
