// import 'package:zzuna/data/services/shared_preferences_service.dart';
// import 'package:zzuna/data/services/storage/local/local_storage.dart';
// import 'package:zzuna/domain/entities/user_entity.dart';

// LocalStorage<LoadedUser> createUserStorage() {
//   return LocalStorage<LoadedUser>(
//     collectionName: 'users',
//     fromJson: (json) => LoadedUser.fromJson(json),
//     toJson: (user) => user.toJson(),
//     prefsService: SharedPreferencesService(),
//   );
// }

/// Exemplo para LoggedUser (usuários logados)
// LocalStorage<LoggedUser> createLoggedUserStorage() {
//   return LocalStorage<LoggedUser>(
//     collectionName: '_loggedUsersListKey',
//     fromJson: (json) => LoggedUser.fromJson(json),
//     toJson: (user) => user.toJson(),
//   );
// }
