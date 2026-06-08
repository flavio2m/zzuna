import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/user_entity.dart';

final userLocalStorageProvider = Provider<LocalStorage<LoadedUser>>(
  (ref) => LocalStorage<LoadedUser>(
    collectionName: 'users',
    fromJson: LoadedUser.fromJson,
    toJson: (user) => user.toJson(), //
  ),
);
