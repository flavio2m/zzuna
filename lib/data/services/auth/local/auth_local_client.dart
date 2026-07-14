import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_auth_exception.dart';
import 'package:zzuna/data/services/auth/auth_client_base.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

class AuthLocalClient implements AuthClientBase {
  final BaseStorage<LoadedUser> _userStorage;

  AuthLocalClient(this._userStorage);

  @override
  AsyncResult<LoggedUser> login(Credentials credentials) async {
    var usersResult = await _userStorage.getAll();

    if (usersResult.isError()) {
      return Failure(usersResult.exceptionOrNull()!);
    }

    var users = usersResult.getOrThrow();

    // Se não houver usuários, cria o usuário de teste
    if (users.isEmpty) {
      final createResult = await _createTestUser();

      if (createResult.isError()) {
        return Failure(createResult.exceptionOrNull()!);
      }

      usersResult = await _userStorage.getAll();

      if (usersResult.isError()) {
        return Failure(usersResult.exceptionOrNull()!);
      }

      users = usersResult.getOrThrow();
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
  }

  @override
  AsyncResult<Unit> logout() async {
    return const Success(unit);
  }

  @override
  AsyncResult<LoggedUser> registerUser(RegisterUserDto dto) async {
    final id = dto.id ?? Uuid().v4();

    // Precisamos de fato salvar o usuário no Storage (Local ou Firebase)
    final newUser = LoadedUser(id: id, name: dto.name, email: dto.email);

    final saveResult = await _userStorage.create(newUser);

    if (saveResult.isError()) {
      return Failure(saveResult.exceptionOrNull()!);
    }

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
  Future<Result<LoadedUser>> _createTestUser() {
    return _userStorage.create(
      LoadedUser(
        id: const Uuid().v4(),
        name: 'Flávio',
        email: 'flavio2m@gmail.com', //
      ),
    );
  }
}
