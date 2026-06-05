import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/data/services/auth/local/auth_local_client.dart';
import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/ui/auth/login/viewmodels/login_viewmodel.dart';
import 'package:zzuna/ui/auth/logout/viewmodels/logout_viewmodel.dart';
import 'package:zzuna/ui/auth/register/viewmodels/register_viewmodel.dart';
// import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================================
// SERVICES - Camada de Infraestrutura
// ============================================================================

/// Provider para instância do Dio (HTTP Client)
// final dioProvider = Provider<Dio>((ref) => Dio());

/// Provider para LocalStorage de usuários
final userStorageProvider = Provider<LocalStorage<LoadedUser>>(
  (ref) => LocalStorage<LoadedUser>(
    collectionName: 'users',
    fromJson: (json) => LoadedUser.fromJson(json),
    toJson: (user) => user.toJson(),
    prefsService: SharedPreferencesService(),
  ),
);

/// Provider para cliente de autenticação local
final authLocalClientProvider = Provider<AuthLocalClient>(
  (ref) => AuthLocalClient(ref.watch(userStorageProvider)), //
);

// ============================================================================
// REPOSITORIES - Camada de Dados
// ============================================================================

/// Provider para UserRepository com lifecycle gerenciado
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final repository = UserRepository(ref.watch(userStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

/// Provider para AuthRepository com lifecycle gerenciado
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = AuthRepository(
    ref.watch(authLocalClientProvider),
    ref.watch(userRepositoryProvider), //
  );
  ref.onDispose(repository.dispose);
  return repository;
});

// ============================================================================
// VIEWMODELS - Camada de Apresentação
// ============================================================================

/// Provider para LoginViewModel
final loginViewModelProvider = Provider<LoginViewModel>((ref) => LoginViewModel(ref.watch(authRepositoryProvider)));

/// Provider para LogoutViewModel
final logoutViewModelProvider = Provider<LogoutViewModel>((ref) => LogoutViewModel(ref.watch(authRepositoryProvider)));

/// Provider para RegisterViewModel
final registerViewModelProvider = Provider<RegisterViewModel>(
  (ref) => RegisterViewModel(ref.watch(authRepositoryProvider)),
);

// ============================================================================
// STATE PROVIDERS - Estado Global da Aplicação
// ============================================================================

/// Provider que emite o estado do usuário logado
/// - Inicia com User.notLogged()
/// - Escuta mudanças do AuthRepository
final userProvider = StreamProvider<User>((ref) async* {
  yield const User.notLogged();
  yield* ref.watch(authRepositoryProvider).userObserver();
});
