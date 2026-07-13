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
import 'package:zzuna/domain/enums/mes.dart';

class ExtratoFaturaRepository
    implements
        BaseRepository<
          ExtratoFatura,
          ExtratoFaturaDto,
          ExtratoFaturaDto,
          ExtratoFaturaFilterDto
        > {
  final BaseStorage<ExtratoFatura> _storage;

  final _streamController =
      StreamController<RepositoryEvent<ExtratoFatura>>.broadcast();

  ExtratoFaturaRepository(LocalStorage<ExtratoFatura> storage)
    : _storage = storage;

  @override
  AsyncResult<ExtratoFatura> create(ExtratoFaturaDto dto) async {
    final extratoFatura = _toEntity(dto);

    return _storage.create(extratoFatura).onSuccess((model) {
      _streamController.add(RepositoryCreated(model));
    });
  }

  @override
  AsyncResult<Unit> createAll(List<ExtratoFaturaDto> dtos) async {
    final entities = dtos.map(_toEntity).toList();
    final result = await _storage.createAll(entities);
    return result.onSuccess((_) {
      for (final entity in entities) {
        _streamController.add(RepositoryCreated(entity));
      }
    });
  }

  @override
  AsyncResult<ExtratoFatura> update(ExtratoFaturaDto dto) async {
    final extratoFatura = _toEntity(dto);

    return _storage.update(extratoFatura).onSuccess((model) {
      _streamController.add(RepositoryUpdated(model));
    });
  }

  @override
  AsyncResult<Unit> updateAll(List<ExtratoFaturaDto> dtos) async {
    final entities = dtos.map(_toEntity).toList();

    final result = await _storage.updateAll(entities);
    return result.onSuccess((_) {
      for (final entity in entities) {
        _streamController.add(RepositoryUpdated(entity));
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

  String _getOrigemKey(LancamentoOrigem origem) {
    return origem.map(
      conta: (c) => 'conta_${c.contaId}',
      cartao: (c) => 'cartao_${c.cartaoId}', //
    );
  }

  AsyncResult<List<ExtratoFatura>> searchByPeriodo(
    LancamentoOrigem origem,
    int ano,
    Mes mes, //
  ) async {
    final fields = [
      SearchField(
        fieldName: 'origemKey',
        value: _getOrigemKey(origem),
        type: SearchFieldType.string,
        operator: SearchOperator.equal,
      ),
      SearchField(
        fieldName: 'periodo',
        value: ano * 100 + mes.numero,
        type: SearchFieldType.int,
        operator: SearchOperator.equal,
      ),
    ];
    return _storage.searchByFields(fields);
  }

  AsyncResult<List<ExtratoFatura>> searchPrevious(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int limit = 1, //
  }) async {
    final fields = [
      SearchField(
        fieldName: 'origemKey',
        value: _getOrigemKey(origem),
        type: SearchFieldType.string,
        operator: SearchOperator.equal,
      ),
      SearchField(
        fieldName: 'periodo',
        value: ano * 100 + mes.numero,
        type: SearchFieldType.int,
        operator: SearchOperator.lessThan,
      ),
    ];
    return _storage.searchByFields(
      fields,
      orderBy: 'periodo',
      order: SearchOrder.descending,
      limit: limit, //
    );
  }

  AsyncResult<List<ExtratoFatura>> searchNext(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int limit = 1, //
  }) async {
    final fields = [
      SearchField(
        fieldName: 'origemKey',
        value: _getOrigemKey(origem),
        type: SearchFieldType.string,
        operator: SearchOperator.equal,
      ),
      SearchField(
        fieldName: 'periodo',
        value: ano * 100 + mes.numero,
        type: SearchFieldType.int,
        operator: SearchOperator.greaterThan,
      ),
    ];
    return _storage.searchByFields(
      fields,
      orderBy: 'periodo',
      order: SearchOrder.ascending,
      limit: limit, //
    );
  }

  AsyncResult<List<ExtratoFatura>> searchAfter(
    LancamentoOrigem origem,
    int ano,
    Mes mes, {
    int? limit, //
  }) async {
    final fields = [
      SearchField(
        fieldName: 'origemKey',
        value: _getOrigemKey(origem),
        type: SearchFieldType.string,
        operator: SearchOperator.equal,
      ),
      SearchField(
        fieldName: 'periodo',
        value: ano * 100 + mes.numero,
        type: SearchFieldType.int,
        operator: SearchOperator.greaterThan,
      ),
    ];
    return _storage.searchByFields(
      fields,
      orderBy: 'periodo',
      order: SearchOrder.ascending,
      limit: limit, //
    );
  }

  AsyncResult<List<ExtratoFatura>> searchLatestBeforeOrAt(
    LancamentoOrigem origem,
    int ano,
    Mes mes, //
  ) async {
    final fields = [
      SearchField(
        fieldName: 'origemKey',
        value: _getOrigemKey(origem),
        type: SearchFieldType.string,
        operator: SearchOperator.equal,
      ),
      SearchField(
        fieldName: 'periodo',
        value: ano * 100 + mes.numero,
        type: SearchFieldType.int,
        operator: SearchOperator.lessThanOrEqual,
      ),
    ];

    return _storage.searchByFields(
      fields,
      orderBy: 'periodo',
      order: SearchOrder.descending,
      limit: 1,
    );
  }

  ExtratoFatura _toEntity(ExtratoFaturaDto dto) {
    final periodo = dto.ano * 100 + dto.mes.numero;
    final origemKey = _getOrigemKey(dto.origem);

    return ExtratoFatura(
      id: dto.id ?? const Uuid().v4(),
      origem: dto.origem,
      ano: dto.ano,
      mes: dto.mes,
      dataInicio: dto.dataInicio,
      dataFim: dto.dataFim,
      saldoInicial: dto.saldoInicial,
      saldoFinal: dto.saldoFinal,
      fechado: dto.fechado,
      periodo: periodo,
      origemKey: origemKey,
    );
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
