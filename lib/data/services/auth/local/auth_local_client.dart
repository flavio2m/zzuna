import 'package:zzuna/data/exception/local_auth_exception.dart';
import 'package:zzuna/data/services/auth/auth_client_base.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/credentials.dart';
import 'package:zzuna/domain/dtos/register_user_dto.dart';
import 'package:zzuna/domain/dtos/update_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

class AuthLocalClient implements AuthClientBase {
  final LocalStorage<LoadedUser> _userStorage;

  AuthLocalClient(this._userStorage);

  @override
  AsyncResult<LoggedUser> login(Credentials credentials) async {
    final usersResult = await _userStorage.getAll();

    // aguarda 5 segundos para simular processo lento
    await Future.delayed(const Duration(seconds: 5));

    return usersResult.fold((users) {
      final matches = users.where((user) => user.email == credentials.email);

      if (matches.isEmpty) {
        return Failure(
          LocalAuthException(
            'Usuário não encontrado com o e-mail ${credentials.email}.', //
          ),
        );
      }

      return Success(_toLoggedUser(matches.first));
    }, (error) => Failure(error));
  }

  @override
  AsyncResult<Unit> logout() async {
    return const Success(unit);
  }

  @override
  AsyncResult<LoggedUser> registerUser(RegisterUserDto dto) async {
    // aguarda 5 segundos para simular processo lento
    await Future.delayed(const Duration(seconds: 5));
    return Success(_createLoggedUser(id: _createFakeId(), name: dto.name, email: dto.email));
  }

  @override
  AsyncResult<LoggedUser> updateUser(UpdateUserDto dto) async {
    return Success(
      _createLoggedUser(id: dto.id, name: dto.name, email: dto.email), //
    );
  }

  LoggedUser _toLoggedUser(LoadedUser user) {
    return _createLoggedUser(id: user.id, name: user.name, email: user.email);
  }

  LoggedUser _createLoggedUser({
    required String id,
    required String name,
    required String email, //
  }) {
    return LoggedUser(
      id: id,
      name: name,
      email: email,
      token: 'local_token_$id',
      refreshToken: 'local_refresh_token_$id',
    );
  }

  String _createFakeId() {
    return 'local_${DateTime.now().microsecondsSinceEpoch}';
  }
}
