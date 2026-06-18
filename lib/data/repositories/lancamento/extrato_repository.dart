import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_entity.dart';

class ExtratoRepository
    implements BaseRepository<Extrato, ExtratoDto, ExtratoDto, ExtratoFilterDto> {
  final BaseStorage<Extrato> _storage;

  final _streamController =
      StreamController<RepositoryEvent<Extrato>>.broadcast();

  ExtratoRepository(LocalStorage<Extrato> storage) : _storage = storage;

  @override
  AsyncResult<Extrato> create(ExtratoDto dto) async {
    final extrato = Extrato(
      id: const Uuid().v4(),
      contaId: dto.contaId,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      fechado: dto.fechado,
    );

    return _storage.create(extrato).onSuccess((model) {
      _streamController.add(RepositoryCreated(model));
    });
  }

  @override
  AsyncResult<Extrato> update(ExtratoDto dto) async {
    final extrato = Extrato(
      id: dto.id!,
      contaId: dto.contaId,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      fechado: dto.fechado,
    );

    return _storage.update(extrato).onSuccess((model) {
      _streamController.add(RepositoryUpdated(model));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<Extrato>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<Extrato> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<Extrato>> search(ExtratoFilterDto filter) async {
    final searchFields = <SearchField>[];

    if (filter.mes != null) {
      searchFields.add(
        SearchField(
          fieldName: 'mes',
          value: filter.mes!.name,
          type: SearchFieldType.string, //
        ),
      );
    }

    if (filter.fechado != null) {
      searchFields.add(
        SearchField(
          fieldName: 'fechado',
          value: filter.fechado,
          type: SearchFieldType.boolean, //
        ),
      );
    }

    final result = await _storage.searchByFields(searchFields);

    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar extratos', //
        ),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<Extrato>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
