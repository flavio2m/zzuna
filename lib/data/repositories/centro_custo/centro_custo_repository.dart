import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_filter_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

class CentroCustoRepository
    implements
        BaseRepository<
          CentroCusto,
          CentroCustoDto,
          CentroCustoDto,
          CentroCustoFilterDto
        > {
  final BaseStorage<CentroCusto> _storage;

  final _streamController =
      StreamController<RepositoryEvent<CentroCusto>>.broadcast();

  CentroCustoRepository(BaseStorage<CentroCusto> storage) : _storage = storage;

  @override
  AsyncResult<CentroCusto> create(CentroCustoDto dto) async {
    final exists = await findByDescricao(dto.descricao).then(
      (result) => result.isSuccess(), //
    );
    if (exists) {
      return Failure(
        LocalStorageException(
          'Já existe um centro de custo com a descrição: ${dto.descricao}', //
        ),
      );
    }
    final centrosResult = await getAll();
    final isEmpty =
        centrosResult.isSuccess() && centrosResult.getOrThrow().isEmpty;
    dto.padrao = isEmpty;

    final centro = CentroCusto(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      ativo: dto.ativo,
      padrao: dto.padrao,
    );
    return _storage.create(centro).onSuccess((c) {
      _streamController.add(RepositoryCreated(c));
    });
  }

  @override
  AsyncResult<Unit> createAll(List<CentroCustoDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => CentroCusto(
            id: dto.id ?? const Uuid().v4(),
            descricao: dto.descricao,
            ativo: dto.ativo,
            padrao: dto.padrao,
          ),
        )
        .toList();

    final result = await _storage.createAll(entities);
    return result.onSuccess((_) {
      for (final e in entities) {
        _streamController.add(RepositoryCreated(e));
      }
    });
  }

  @override
  AsyncResult<CentroCusto> update(CentroCustoDto dto) async {
    final existingResult = await getById(dto.id!);
    if (existingResult.isError()) {
      return Failure(existingResult.exceptionOrNull()!);
    }
    final existing = existingResult.getOrThrow();

    if (dto.padrao) {
      final allResult = await getAll();
      if (allResult.isSuccess()) {
        final currentDefault = allResult
            .getOrThrow()
            .where((c) => c.padrao && c.id != dto.id)
            .firstOrNull;
        if (currentDefault != null) {
          final oldEntity = CentroCusto(
            id: currentDefault.id,
            descricao: currentDefault.descricao,
            ativo: currentDefault.ativo,
            padrao: false,
          );
          await _storage.update(oldEntity);
          _streamController.add(RepositoryUpdated(oldEntity));
        }
      }
    } else {
      if (existing.padrao) {
        dto.padrao = true;
      }
    }

    final centro = CentroCusto(
      id: dto.id!,
      descricao: dto.descricao,
      ativo: dto.ativo,
      padrao: dto.padrao,
    );
    return _storage.update(centro).onSuccess((c) {
      _streamController.add(RepositoryUpdated(c));
    });
  }

  @override
  AsyncResult<Unit> updateAll(List<CentroCustoDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => CentroCusto(
            id: dto.id!,
            descricao: dto.descricao,
            ativo: dto.ativo,
            padrao: dto.padrao,
          ),
        )
        .toList();

    final result = await _storage.updateAll(entities);
    return result.onSuccess((_) {
      for (final e in entities) {
        _streamController.add(RepositoryUpdated(e));
      }
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  AsyncResult<List<CentroCusto>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<CentroCusto> getById(String id) async {
    return _storage.getById(id);
  }

  AsyncResult<CentroCusto> findByDescricao(String descricao) async {
    final searchFields = [
      SearchField(
        fieldName: 'descricao',
        value: descricao,
        type: SearchFieldType.string, //
      ),
    ];
    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      (centros) => centros.isEmpty
          ? Failure(
              LocalStorageException(
                'Centro de custo não encontrado: $descricao', //
              ),
            )
          : Success(centros.first),
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar centro de custo: $descricao', //
        ),
      ),
    );
  }

  @override
  AsyncResult<List<CentroCusto>> search(CentroCustoFilterDto filter) async {
    final searchFields = <SearchField>[];
    if (filter.descricao.isNotEmpty) {
      searchFields.add(
        SearchField(
          fieldName: 'descricao',
          value: filter.descricao,
          type: SearchFieldType.string,
          operator: SearchOperator.contains,
        ),
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
    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar centros de custo', //
        ),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<CentroCusto>> observer() => _streamController.stream;

  @override
  void dispose() => _streamController.close();
}
