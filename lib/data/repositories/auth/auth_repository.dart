import 'dart:async';

import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/data/services/auth/auth_client_base.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/domain/validators/credentials_validator.dart';
import 'package:zzuna/utils/extensions/lucid_validator_extencion.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepository {
  final AuthClientBase _authClient;
  final UserRepository _userRepository;
  final _streamController = StreamController<User>.broadcast();

  AuthRepository(this._authClient, this._userRepository);

  AsyncResult<LoggedUser> login(Credentials credentials) async {
    final validator = CredentialsValidator();

    return validator //
        .validateResult(credentials)
        .flatMap(_authClient.login)
        .onSuccess(_streamController.add);
  }

  AsyncResult<LoggedUser> registerUser(RegisterUserDto dto) async {
    final validator = CredentialsValidator();
    final credentials = Credentials(email: dto.email, password: dto.password);

    final authResult =
        await validator //
            .validateResult(credentials)
            .flatMap((_) => _authClient.registerUser(dto));

    if (authResult.isError()) {
      return Failure(authResult.exceptionOrNull()!);
    }

    final loggedUser = authResult.getOrThrow();

    // Retorna o ID gerado pela authRepository
    dto.id = loggedUser.id;

    final createResult = await _userRepository.create(dto);

    return createResult.fold((_) {
      _streamController.add(loggedUser);
      return Success(loggedUser);
    }, Failure.new);
  }

  AsyncResult<LoggedUser> updateUser(LoadedUserDto dto) async {
    final authResult = await _authClient.updateUser(dto);

    if (authResult.isError()) {
      return Failure(authResult.exceptionOrNull()!);
    }

    final loggedUser = authResult.getOrThrow();
    final userResult = await _userRepository.getById(dto.id);

    if (userResult.isError()) {
      return Failure(userResult.exceptionOrNull()!);
    }

    final updateResult = await _userRepository.update(dto);

    return updateResult.fold((savedUser) {
      final updatedLoggedUser = LoggedUser(
        id: savedUser.id,
        name: savedUser.name,
        email: savedUser.email,
        token: loggedUser.token,
        refreshToken: loggedUser.refreshToken,
      );

      _streamController.add(updatedLoggedUser);
      return Success(updatedLoggedUser);
    }, Failure.new);
  }

  AsyncResult<Unit> logout() {
    return _authClient //
        .logout()
        .onSuccess((_) => _streamController.add(const User.notLogged()));
  }

  Stream<User> userObserver() {
    return _streamController.stream;
  }

  void dispose() {
    _streamController.close();
  }
}
