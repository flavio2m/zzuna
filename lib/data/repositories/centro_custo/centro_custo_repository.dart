import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_filter_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

class CentroCustoRepository
    implements BaseRepository<CentroCusto, CentroCustoDto, CentroCustoDto, CentroCustoFilterDto> {
  final LocalStorage<CentroCusto> _storage;

  final _streamController = StreamController<RepositoryEvent<CentroCusto>>.broadcast();

  CentroCustoRepository(LocalStorage<CentroCusto> storage) : _storage = storage;

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
    final centro = CentroCusto(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      ativo: dto.ativo, //
    );
    return _storage.create(centro).onSuccess((c) {
      _streamController.add(RepositoryCreated(c));
    });
  }

  @override
  AsyncResult<CentroCusto> update(CentroCustoDto dto) async {
    final centro = CentroCusto(
      id: dto.id!,
      descricao: dto.descricao,
      ativo: dto.ativo, //
    );
    return _storage.update(centro).onSuccess((c) {
      _streamController.add(RepositoryUpdated(c));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<CentroCusto>> getAll() async {
    final result = await _storage.getAll();
    if (result.isError()) return Failure(result.exceptionOrNull()!);
    final list = result.getOrThrow();
    if (list.isEmpty) {
      await _seedCentroCustos();
      return _storage.getAll();
    }
    return Success(list);
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
          type: SearchFieldType.string, //
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

  // Para testes – gera 10 centros de custo
  Future<void> _seedCentroCustos() async {
    const descricoes = [
      'Moradia',
      'Viagens',
      'Lazer',
      'Educação',
      'Saúde',
      'Pessoa A',
      'Pessoa B',
      'Pessoa C',
      'Jurídico',
      'Terceiros',
    ];
    for (var i = 0; i < descricoes.length; i++) {
      await _storage.create(
        CentroCusto(
          id: const Uuid().v4(),
          descricao: descricoes[i],
          ativo: i != 9, //
        ),
      );
    }
    // REFATORAR: Somente para testes
  }
}
