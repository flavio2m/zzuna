import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_auth_exception.dart';
import 'package:zzuna/data/services/auth/auth_client_base.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

class AuthLocalClient implements AuthClientBase {
  final LocalStorage<LoadedUser> _userStorage;

  AuthLocalClient(this._userStorage);

  @override
  AsyncResult<LoggedUser> login(Credentials credentials) async {
    final usersResult = await _userStorage.getAll();

    // aguarda 5 segundos para simular processo lento
    // await Future.delayed(const Duration(seconds: 5));

    return usersResult.fold((users) {
      if (users.isEmpty) {
        // Se não tem usuários cadastrados, gera um usuário temporário para teste
        return _createTestUser();
      }

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
    // await Future.delayed(const Duration(seconds: 5));
    final id = dto.id ?? Uuid().v4();

    return Success(_createLoggedUser(id: id, name: dto.name, email: dto.email));
  }

  @override
  AsyncResult<LoggedUser> updateUser(LoadedUserDto dto) async {
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

  // Função que cria um usuário temporário para teste
  AsyncResult<LoggedUser> _createTestUser() async {
    // Se não tem usuários cadastrados, gera um usuário com e-mail flavio2m@gmail.com
    final registerUserDto = RegisterUserDto(
      name: 'Flávio',
      email: 'flavio2m@gmail.com',
      password: 'senha123', //
    );
    final resultUser = _createLoggedUser(
      id: Uuid().v4(),
      name: registerUserDto.name,
      email: registerUserDto.email, //
    );

    return Success(resultUser);
  }
}
