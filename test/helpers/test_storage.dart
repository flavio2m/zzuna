import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';

LocalStorage<LoadedUser> createTestUserStorage({String collectionName = 'users'}) {
  return LocalStorage<LoadedUser>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: LoadedUser.fromJson,
    toJson: (user) => user.toJson(),
  );
}

LoadedUser createTestUser({
  String id = 'user-1',
  String name = 'Test User',
  String email = 'test@example.com', //
}) {
  return LoadedUser(id: id, name: name, email: email);
}

RegisterUserDto createTestUserDto({
  String id = 'user-1',
  String name = 'Test User',
  String email = 'test@example.com',
  String password = 'Aa123456!',
}) {
  return RegisterUserDto(id: id, name: name, email: email, password: password);
}

RegisterUserDto createTestRegisterUserDto(LoadedUser user) {
  return RegisterUserDto(
    id: user.id,
    name: user.name,
    email: user.email,
    password: 'password123', //
  );
}

// Cria LoadedUserDto baseado em um LoadedUser
LoadedUserDto createTestLoadedUserDto(LoadedUser user) {
  return LoadedUserDto(id: user.id, name: user.name, email: user.email);
}
