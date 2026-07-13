import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/data/services/storage/firebase/firebase_realtime_storage.dart';
import 'package:zzuna/domain/entities/user_entity.dart';

final userLocalStorageProvider = Provider<BaseStorage<LoadedUser>>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return LocalStorage<LoadedUser>(
      collectionName: 'users',
      fromJson: LoadedUser.fromJson,
      toJson: (user) => user.toJson(),
    );
  } else {
    return FirebaseRealtimeStorage<LoadedUser>(
      collectionName: 'users',
      fromJson: LoadedUser.fromJson,
      toJson: (user) => user.toJson(),
    );
  }
});
