import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/fatura_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/fatura_entity.dart';

class FaturaRepository
    implements BaseRepository<Fatura, FaturaDto, FaturaDto, FaturaFilterDto> {
  final BaseStorage<Fatura> _storage;

  final _streamController =
      StreamController<RepositoryEvent<Fatura>>.broadcast();

  FaturaRepository(LocalStorage<Fatura> storage) : _storage = storage;

  @override
  AsyncResult<Fatura> create(FaturaDto dto) async {
    final fatura = Fatura(
      id: const Uuid().v4(),
      cartaoId: dto.cartaoId,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      fechada: dto.fechada,
    );

    return _storage.create(fatura).onSuccess((model) {
      _streamController.add(RepositoryCreated(model));
    });
  }

  @override
  AsyncResult<Fatura> update(FaturaDto dto) async {
    final fatura = Fatura(
      id: dto.id!,
      cartaoId: dto.cartaoId,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      fechada: dto.fechada,
    );

    return _storage.update(fatura).onSuccess((model) {
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
  AsyncResult<List<Fatura>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<Fatura> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<Fatura>> search(FaturaFilterDto filter) async {
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

    if (filter.fechada != null) {
      searchFields.add(
        SearchField(
          fieldName: 'fechada',
          value: filter.fechada,
          type: SearchFieldType.boolean, //
        ),
      );
    }

    final result = await _storage.searchByFields(searchFields);

    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar faturas', //
        ),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<Fatura>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
