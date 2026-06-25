import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/conta/conta_filter_dto.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

class ContaRepository implements BaseRepository<Conta, CreateContaDto, LoadedContaDto, ContaFilterDto> {
  final BaseStorage<Conta> _storage;

  final _streamController = StreamController<RepositoryEvent<Conta>>.broadcast();

  ContaRepository(LocalStorage<Conta> storage) : _storage = storage;

  @override
  AsyncResult<Conta> create(CreateContaDto dto) async {
    final exists = await findByDescricao(dto.descricao).then(
      (result) => result.isSuccess(), //
    );

    if (exists) {
      return Failure(
        LocalStorageException(
          'Já existe uma conta com a descrição: ${dto.descricao}', //
        ),
      );
    }

    final conta = Conta(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      ativo: dto.ativo,
      bancoSigla: dto.bancoSigla,
      dataInicial:
          dto.dataInicial ??
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1, //
          ),
    );

    return _storage.create(conta).onSuccess((conta) {
      _streamController.add(RepositoryCreated(conta));
    });
  }

  @override
  AsyncResult<Conta> update(LoadedContaDto dto) async {
    final conta = Conta(
      id: dto.id,
      descricao: dto.descricao,
      ativo: dto.ativo,
      bancoSigla: dto.bancoSigla,
      dataInicial: dto.dataInicial,
    );
    return _storage.update(conta).onSuccess((conta) {
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
  AsyncResult<List<Conta>> search(ContaFilterDto filter) async {
    final searchFields = <SearchField>[];

    if (filter.descricao.isNotEmpty) {
      searchFields.add(
        SearchField(
          fieldName: 'descricao',
          value: filter.descricao,
          type: SearchFieldType.string, //
        ),
      );
    }

    if (filter.bancoSigla != null && filter.bancoSigla!.isNotEmpty) {
      searchFields.add(
        SearchField(
          fieldName: 'bancoSigla',
          value: filter.bancoSigla,
          type: SearchFieldType.string, //
        ), //
      );
    }

    if (filter.ativo != null) {
      searchFields.add(
        SearchField(
          fieldName: 'ativo',
          value: filter.ativo,
          type: SearchFieldType.boolean, //
        ),
      );
    }

    final contasResult = await _storage.searchByFields(searchFields);

    return contasResult.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar contas', //
        ),
      ),
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
