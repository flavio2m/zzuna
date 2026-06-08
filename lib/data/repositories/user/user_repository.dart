import 'dart:async';

import 'package:zzuna/data/exception/repository_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

class UserRepository implements BaseRepository<LoadedUser, RegisterUserDto, LoadedUserDto> {
  final BaseStorage<LoadedUser> _storage;
  final _streamController = StreamController<RepositoryEvent<LoadedUser>>.broadcast();

  UserRepository(LocalStorage<LoadedUser> storage) : _storage = storage;

  @override
  AsyncResult<LoadedUser> create(RegisterUserDto dto) async {
    final exists = await findUserByEmail(dto.email).then(
      (result) => result.isSuccess(), //
    );

    if (exists) {
      return Failure(
        RepositoryException('Usuário já existe com o e-mail: ${dto.email}'), //
      );
    }

    // É necessário vim com o ID gerado pela authRepository
    if (dto.id == null) {
      return Failure(RepositoryException('ID do usuário não informado.'));
    }

    final user = LoadedUser(
      id: dto.id!,
      email: dto.email,
      name: dto.name, //
    );
    return _storage.create(user).onSuccess((user) {
      _streamController.add(RepositoryCreated(user));
    });
  }

  @override
  AsyncResult<LoadedUser> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<LoadedUser> update(LoadedUserDto dto) async {
    final loadedUser = LoadedUser(id: dto.id, email: dto.email, name: dto.name);
    return _storage.update(loadedUser).onSuccess((user) {
      _streamController.add(RepositoryUpdated(user));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<LoadedUser>> getAll() async {
    return _storage.getAll();
  }

  AsyncResult<LoadedUser> findUserByEmail(String email) async {
    final searchFields = [
      SearchField(
        fieldName: 'email',
        value: email,
        type: SearchFieldType.string, //
      ), //
    ];

    final usersResult = await _storage.searchByFields(searchFields);

    return usersResult.fold(
      (users) {
        if (users.isEmpty) {
          return Failure(
            RepositoryException('Usuário não encontrado com o e-mail: $email'), //
          );
        }
        return Success(users.first);
      },
      (error) {
        return Failure(
          RepositoryException('Erro ao buscar usuário por e-mail: $email'), //
        );
      },
    );
  }

  @override
  Stream<RepositoryEvent<LoadedUser>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
