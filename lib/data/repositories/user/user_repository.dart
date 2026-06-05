import 'dart:async';

import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

class UserRepository implements BaseRepository<LoadedUser> {
  final BaseStorage<LoadedUser> _storage;
  final _streamController = StreamController<RepositoryEvent<LoadedUser>>.broadcast();

  UserRepository(LocalStorage<LoadedUser> storage) : _storage = storage;

  @override
  AsyncResult<LoadedUser> create(LoadedUser model) async {
    final exists = await findUserByEmail(model.email).then(
      (result) => result.isSuccess(), //
    );

    if (exists) {
      return Failure(
        LocalStorageException('Usuário já existe com o e-mail: ${model.email}'), //
      );
    }

    return _storage.create(model).onSuccess((user) {
      _streamController.add(RepositoryCreated(user));
    });
  }

  @override
  AsyncResult<LoadedUser> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<LoadedUser> update(LoadedUser model) async {
    return _storage.update(model).onSuccess((user) {
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
            LocalStorageException('Usuário não encontrado com o e-mail: $email'), //
          );
        }
        return Success(users.first);
      },
      (error) {
        return Failure(
          LocalStorageException('Erro ao buscar usuário por e-mail: $email'), //
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
