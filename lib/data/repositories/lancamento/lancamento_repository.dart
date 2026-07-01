import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

import 'package:zzuna/domain/enums/mes.dart';

class LancamentoRepository
    implements
        BaseRepository<
          Lancamento,
          LancamentoDto,
          LancamentoDto,
          LancamentoFilterDto //
        > {
  final BaseStorage<Lancamento> _storage;

  final _streamController = //
      StreamController<RepositoryEvent<Lancamento>>.broadcast();

  LancamentoRepository(LocalStorage<Lancamento> storage) : _storage = storage;

  @override
  AsyncResult<Lancamento> create(LancamentoDto dto) async {
    final lancamento = Lancamento(
      id: const Uuid().v4(),
      tipo: dto.tipo,
      data: dto.data,
      descricao: dto.descricao,
      extratoFaturaId: dto.extratoFaturaId,
      origem: dto.origem,
      itens: dto.itens,
      conciliado: dto.conciliado,
      grupo: dto.grupo,
      observacao: dto.observacao,
    );

    return _storage.create(lancamento).onSuccess((model) {
      _streamController.add(RepositoryCreated(model));
    });
  }

  @override
  AsyncResult<Unit> createAll(List<LancamentoDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => Lancamento(
            id: dto.id ?? const Uuid().v4(),
            tipo: dto.tipo,
            data: dto.data,
            descricao: dto.descricao,
            extratoFaturaId: dto.extratoFaturaId,
            origem: dto.origem,
            itens: dto.itens,
            conciliado: dto.conciliado,
            grupo: dto.grupo,
            observacao: dto.observacao,
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
  AsyncResult<Lancamento> update(LancamentoDto dto) async {
    final lancamento = Lancamento(
      id: dto.id!,
      tipo: dto.tipo,
      data: dto.data,
      descricao: dto.descricao,
      extratoFaturaId: dto.extratoFaturaId,
      origem: dto.origem,
      itens: dto.itens,
      conciliado: dto.conciliado,
      grupo: dto.grupo,
      observacao: dto.observacao,
    );

    return _storage.update(lancamento).onSuccess((model) {
      _streamController.add(RepositoryUpdated(model));
    });
  }

  @override
  AsyncResult<Unit> updateAll(List<LancamentoDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => Lancamento(
            id: dto.id ?? const Uuid().v4(),
            tipo: dto.tipo,
            data: dto.data,
            descricao: dto.descricao,
            extratoFaturaId: dto.extratoFaturaId,
            origem: dto.origem,
            itens: dto.itens,
            conciliado: dto.conciliado,
            grupo: dto.grupo,
            observacao: dto.observacao,
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

  AsyncResult<List<Lancamento>> getByGrupoId(String grupoId) async {
    final listResult = await _storage.getAll();
    if (listResult.isError()) {
      return Failure(listResult.exceptionOrNull()!);
    }
    final list = listResult.getOrThrow();
    final groupLaunches = list
        .where((l) => l.grupo?.grupoId == grupoId)
        .toList();
    return Success(groupLaunches);
  }

  AsyncResult<List<Lancamento>> searchByPeriodo({
    required int ano,
    required Mes mes, //
  }) async {
    final firstDay = DateTime(ano, mes.numero, 1);
    final lastDay = DateTime(ano, mes.numero + 1, 0, 23, 59, 59, 999);

    final searchFields = [
      SearchField(
        fieldName: 'data',
        value: [firstDay, lastDay],
        type: SearchFieldType.date, //
      ),
    ];

    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar lançamentos por período', //
        ),
      ),
    );
  }

  @override
  AsyncResult<Lancamento> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<Lancamento>> search(LancamentoFilterDto filter) async {
    // Retorna failure se não for passado ano ou mês
    if (filter.ano == null || filter.mes == null) {
      return Failure(
        LocalStorageException(
          'Ano e mês são obrigatórios para busca de lançamentos', //
        ),
      );
    }

    final firstDay = DateTime(filter.ano!, filter.mes!.numero, 1);
    final lastDay = DateTime(
      filter.ano!,
      filter.mes!.numero + 1,
      0,
      23,
      59,
      59,
      999,
    );

    final searchFields = [
      SearchField(
        fieldName: 'data',
        value: [firstDay, lastDay],
        type: SearchFieldType.date, //
      ),
    ];

    if (filter.descricao.isNotEmpty) {
      searchFields.add(
        SearchField(
          fieldName: 'descricao',
          value: filter.descricao,
          type: SearchFieldType.string,
        ),
      );
    }

    if (filter.tipo != null) {
      searchFields.add(
        SearchField(
          fieldName: 'tipo',
          value: filter.tipo!.name,
          type: SearchFieldType.string,
        ),
      );
    }

    if (filter.conciliado != null) {
      searchFields.add(
        SearchField(
          fieldName: 'conciliado',
          value: filter.conciliado,
          type: SearchFieldType.boolean,
        ),
      );
    }

    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar lançamentos por ano/mês', //
        ),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<Lancamento>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
