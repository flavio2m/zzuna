import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/user_entity.dart';

LocalStorage<LoadedUser> createTestUserStorage({String collectionName = 'users'}) {
  return LocalStorage<LoadedUser>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: LoadedUser.fromJson,
    toJson: (user) => user.toJson(),
  );
}

LoadedUser createTestUser({String id = 'user-1', String name = 'Test User', String email = 'test@example.com'}) {
  return LoadedUser(id: id, name: name, email: email);
}
