import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
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
    // Verifica se já existe categoria com a mesma descrição no mesmo nível
    final exists = await _existsDuplicate(dto.descricao, dto.categoriaPaiId);
    if (exists) {
      return Failure(
        RepositoryException(
          'Já existe uma categoria com a descrição "${dto.descricao}" '
          'neste nível.',
        ),
      );
    }
    // Verifica regra de hierarquia ao criar
    if (dto.categoriaPaiId != null) {
      final parentResult = await _storage.getById(dto.categoriaPaiId!);
      if (parentResult.isSuccess()) {
        final parent = parentResult.getOrThrow();
        if (parent.categoriaPaiId != null) {
          return Failure(
            RepositoryException(
              'Somente dois níveis são permitidos.', //
            ),
          );
        }
      }
    }
    final categoria = Categoria(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      categoriaPaiId: dto.categoriaPaiId,
      ativo: dto.ativo,
    );
    return _storage.create(categoria).onSuccess((cat) {
      _streamController.add(RepositoryCreated(cat));
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
    // Verifica se já existe categoria com a mesma descrição no mesmo nível
    final exists = await _existsDuplicate(
      dto.descricao,
      dto.categoriaPaiId,
      excludeId: dto.id,
    );
    if (exists) {
      return Failure(
        RepositoryException(
          'Já existe uma categoria com a descrição "${dto.descricao}" neste nível.', //
        ),
      );
    }
    // Se estiver alterando para subcategoria, validar nível
    if (dto.categoriaPaiId != null) {
      final parentResult = await _storage.getById(dto.categoriaPaiId!);
      if (parentResult.isSuccess()) {
        final parent = parentResult.getOrThrow();
        if (parent.categoriaPaiId != null) {
          return Failure(
            RepositoryException(
              'Somente dois níveis são permitidos.', //
            ),
          );
        }
      }
    }
    final categoria = Categoria(
      id: dto.id!,
      descricao: dto.descricao,
      categoriaPaiId: dto.categoriaPaiId,
      ativo: dto.ativo,
    );
    return _storage.update(categoria).onSuccess((cat) {
      _streamController.add(RepositoryUpdated(cat));
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

  Future<bool> _existsDuplicate(
    String descricao,
    String? categoriaPaiId, {
    String? excludeId,
  }) async {
    final result = await getAll();
    return result.fold((list) {
      final filtered = list.where((c) {
        if (c.categoriaPaiId != categoriaPaiId) return false;
        if (excludeId != null && c.id == excludeId) return false;
        return c.descricao.trim().toLowerCase() ==
            descricao.trim().toLowerCase();
      });
      return filtered.isNotEmpty;
    }, (error) => false);
  }

  @override
  AsyncResult<List<Categoria>> search(CategoriaFilterDto filter) async {
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
        RepositoryException(
          'Erro ao buscar categorias', //
        ),
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
