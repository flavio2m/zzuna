import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';

final extratoFaturaStorageProvider = Provider<BaseStorage<ExtratoFatura>>((
  ref,
) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<ExtratoFatura>(
      collectionName: 'extrato_faturas',
      fromJson: (json) => ExtratoFatura.fromJson(json),
      toJson: (extratoFatura) => extratoFatura.toJson(),
    );
  } else {
    return FirebaseRealtimeStorage<ExtratoFatura>(
      collectionName: 'extrato_faturas',
      fromJson: (json) => ExtratoFatura.fromJson(json),
      toJson: (extratoFatura) => extratoFatura.toJson(),
    );
  }
});
