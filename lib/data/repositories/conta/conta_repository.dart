import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

class ContaRepository implements BaseRepository<Conta> {
  final BaseStorage<Conta> _storage;

  final _streamController = StreamController<RepositoryEvent<Conta>>.broadcast();

  ContaRepository(LocalStorage<Conta> storage) : _storage = storage;

  @override
  AsyncResult<Conta> create(Conta model) async {
    final exists = await findByDescricao(model.descricao).then(
      (result) => result.isSuccess(), //
    );

    if (exists) {
      return Failure(
        LocalStorageException(
          'Já existe uma conta com a descrição: ${model.descricao}', //
        ),
      );
    }

    return _storage.create(model).onSuccess((conta) {
      _streamController.add(RepositoryCreated(conta));
    });
  }

  @override
  AsyncResult<Conta> update(Conta model) async {
    return _storage.update(model).onSuccess((conta) {
      _streamController.add(RepositoryUpdated(conta));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<Conta>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<Conta> getById(String id) async {
    return _storage.getById(id);
  }

  AsyncResult<Conta> findByDescricao(String descricao) async {
    final searchFields = [
      SearchField(
        fieldName: 'descricao',
        value: descricao,
        type: SearchFieldType.string, //
      ),
    ];

    final contasResult = await _storage.searchByFields(searchFields);

    return contasResult.fold(
      (contas) {
        if (contas.isEmpty) {
          return Failure(
            LocalStorageException('Conta não encontrada: $descricao'), //
          );
        }

        return Success(contas.first);
      },
      (error) {
        return Failure(
          LocalStorageException('Erro ao buscar conta: $descricao'), //
        );
      },
    );
  }

  @override
  Stream<RepositoryEvent<Conta>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
