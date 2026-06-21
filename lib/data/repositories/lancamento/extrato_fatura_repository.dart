import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class ExtratoFaturaRepository
    implements BaseRepository<ExtratoFatura, ExtratoFaturaDto, ExtratoFaturaDto, ExtratoFaturaFilterDto> {
  final BaseStorage<ExtratoFatura> _storage;

  final _streamController = StreamController<RepositoryEvent<ExtratoFatura>>.broadcast();

  ExtratoFaturaRepository(LocalStorage<ExtratoFatura> storage) : _storage = storage;

  @override
  AsyncResult<ExtratoFatura> create(ExtratoFaturaDto dto) async {
    final extratoFatura = ExtratoFatura(
      id: const Uuid().v4(),
      origem: dto.origem,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      saldoInicial: dto.saldoInicial,
      saldoFinal: dto.saldoFinal,
      fechado: dto.fechado,
    );

    return _storage.create(extratoFatura).onSuccess((model) {
      _streamController.add(RepositoryCreated(model));
    });
  }

  @override
  AsyncResult<ExtratoFatura> update(ExtratoFaturaDto dto) async {
    final extratoFatura = ExtratoFatura(
      id: dto.id!,
      origem: dto.origem,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      saldoInicial: dto.saldoInicial,
      saldoFinal: dto.saldoFinal,
      fechado: dto.fechado,
    );

    return _storage.update(extratoFatura).onSuccess((model) {
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
  AsyncResult<List<ExtratoFatura>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<ExtratoFatura> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<ExtratoFatura>> search(ExtratoFaturaFilterDto filter) async {
    final searchFields = <SearchField>[];

    searchFields.add(
      SearchField(
        fieldName: 'ano',
        value: filter.ano.toString(),
        type: SearchFieldType.string, //
      ),
    );

    searchFields.add(
      SearchField(
        fieldName: 'mes',
        value: filter.mes.name,
        type: SearchFieldType.string, //
      ),
    );

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
          'Erro ao buscar extrato/faturas', //
        ),
      ),
    );
  }

  AsyncResult<List<ExtratoFatura>> searchByAno(int ano) async {
    final searchFields = [
      SearchField(
        fieldName: 'ano',
        value: ano.toString(),
        type: SearchFieldType.string,
      ),
    ];
    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar extratos por ano',
        ),
      ),
    );
  }

  AsyncResult<List<ExtratoFatura>> searchByOrigemAndAno(
    LancamentoOrigem origem,
    int ano, [
    int? mes,
  ]) async {
    final searchFields = [
      SearchField(
        fieldName: 'ano',
        value: [ano, null],
        type: SearchFieldType.int,
      ),
    ];
    final result = await _storage.searchByFields(searchFields);
    return result.map((list) {
      var filtered = list.where((e) => e.origem == origem).toList();
      if (mes != null) {
        filtered = filtered.where((e) {
          return e.ano > ano || (e.ano == ano && e.mes.numero >= mes);
        }).toList();
      }
      return filtered;
    });
  }

  @override
  Stream<RepositoryEvent<ExtratoFatura>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
