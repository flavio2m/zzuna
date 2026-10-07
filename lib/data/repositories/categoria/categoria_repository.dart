import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/repository_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_filter_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaRepository
    implements
        BaseRepository<
          Categoria,
          CategoriaDto,
          CategoriaDto,
          CategoriaFilterDto
        > {
  final BaseStorage<Categoria> _storage;

  final _streamController =
      StreamController<RepositoryEvent<Categoria>>.broadcast();

  CategoriaRepository(BaseStorage<Categoria> storage) : _storage = storage;

  @override
  AsyncResult<Categoria> create(CategoriaDto dto) async {
    final categoria = Categoria(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      categoriaPaiId: dto.categoriaPaiId,
      ativo: dto.ativo,
      percentualOrcamento: dto.percentualOrcamento,
      natureza: dto.natureza,
      cor: dto.cor,
    );
    return _storage.create(categoria).onSuccess((_) {
      _streamController.add(RepositoryCreated(categoria));
    });
  }

  @override
  AsyncResult<Unit> createAll(List<CategoriaDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => Categoria(
            id: dto.id ?? const Uuid().v4(),
            descricao: dto.descricao,
            categoriaPaiId: dto.categoriaPaiId,
            ativo: dto.ativo,
            percentualOrcamento: dto.percentualOrcamento,
            natureza: dto.natureza,
            cor: dto.cor,
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
  AsyncResult<Categoria> update(CategoriaDto dto) async {
    // Busca a categoria existente
    final existingResult = await _storage.getById(dto.id!);
    if (existingResult.isError()) {
      return Failure(
        existingResult.exceptionOrNull()!, //
      );
    }
    final categoria = Categoria(
      id: dto.id!,
      descricao: dto.descricao,
      categoriaPaiId: dto.categoriaPaiId,
      ativo: dto.ativo,
      percentualOrcamento: dto.percentualOrcamento,
      natureza: dto.natureza,
      cor: dto.cor,
    );
    return _storage.update(categoria).onSuccess((_) {
      _streamController.add(RepositoryUpdated(categoria));
    });
  }

  @override
  AsyncResult<Unit> updateAll(List<CategoriaDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => Categoria(
            id: dto.id!,
            descricao: dto.descricao,
            categoriaPaiId: dto.categoriaPaiId,
            ativo: dto.ativo,
            percentualOrcamento: dto.percentualOrcamento,
            natureza: dto.natureza,
            cor: dto.cor,
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

  AsyncResult<List<Categoria>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<Categoria> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<Categoria>> search(CategoriaFilterDto filter) async {
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
        RepositoryException('Erro ao buscar categorias: ${error.toString()}'),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<Categoria>> observer() => _streamController.stream;

  @override
  void dispose() {
    _streamController.close();
  }
}
