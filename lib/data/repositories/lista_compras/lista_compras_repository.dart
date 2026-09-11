import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_filter_dto.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

class ListaComprasRepository
    implements
        BaseRepository<
          ListaCompras,
          ListaComprasDto,
          ListaComprasDto,
          ListaComprasFilterDto
        > {
  final BaseStorage<ListaCompras> _storage;

  final _streamController =
      StreamController<RepositoryEvent<ListaCompras>>.broadcast();

  ListaComprasRepository(BaseStorage<ListaCompras> storage)
    : _storage = storage;

  AsyncResult<List<ListaCompras>> getAll() async {
    return _storage.getAll();
  }

  AsyncResult<ListaCompras> getByPeriodo(int ano, Mes mes) async {
    final result = await _storage.getAll();
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }
    final targetPeriodo = ano * 100 + mes.numero;
    final list = result.getOrThrow();
    final match = list.where((e) => e.periodo == targetPeriodo).firstOrNull;
    if (match != null) {
      return Success(match);
    }
    return Failure(
      LocalStorageException('Nenhuma lista encontrada para o período.'),
    );
  }

  @override
  AsyncResult<ListaCompras> create(ListaComprasDto dto) async {
    final existingRes = await getByPeriodo(dto.ano, dto.mes);
    if (existingRes.isSuccess()) {
      return Failure(
        LocalStorageException(
          'Já existe uma lista de compras para ${dto.mes.descricao}/${dto.ano}.',
        ),
      );
    }

    final entity = ListaCompras(
      id: dto.id ?? const Uuid().v4(),
      ano: dto.ano,
      mes: dto.mes,
      periodo: dto.periodo,
      itens: dto.itens,
    );

    return _storage.create(entity).onSuccess((created) {
      _streamController.add(RepositoryCreated(created));
    });
  }

  @override
  AsyncResult<Unit> createAll(List<ListaComprasDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => ListaCompras(
            id: dto.id ?? const Uuid().v4(),
            ano: dto.ano,
            mes: dto.mes,
            periodo: dto.periodo,
            itens: dto.itens,
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
  AsyncResult<ListaCompras> update(ListaComprasDto dto) async {
    if (dto.id == null) {
      return Failure(
        LocalStorageException('ID da lista é obrigatório para atualização.'),
      );
    }

    final entity = ListaCompras(
      id: dto.id!,
      ano: dto.ano,
      mes: dto.mes,
      periodo: dto.periodo,
      itens: dto.itens,
    );

    return _storage.update(entity).onSuccess((updated) {
      _streamController.add(RepositoryUpdated(updated));
    });
  }

  @override
  AsyncResult<Unit> updateAll(List<ListaComprasDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => ListaCompras(
            id: dto.id!,
            ano: dto.ano,
            mes: dto.mes,
            periodo: dto.periodo,
            itens: dto.itens,
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

  @override
  AsyncResult<ListaCompras> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<ListaCompras>> search(ListaComprasFilterDto filter) async {
    final result = await _storage.getAll();
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }
    final targetPeriodo = filter.periodo;
    final list = result
        .getOrThrow()
        .where((e) => e.periodo == targetPeriodo)
        .toList();
    return Success(list);
  }

  @override
  Stream<RepositoryEvent<ListaCompras>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
