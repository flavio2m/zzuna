import 'package:result_dart/result_dart.dart';

sealed class RepositoryEvent<T extends Object> {}

class RepositoryCreated<T extends Object> extends RepositoryEvent<T> {
  final T model;

  RepositoryCreated(this.model);
}

class RepositoryUpdated<T extends Object> extends RepositoryEvent<T> {
  final T model;

  RepositoryUpdated(this.model);
}

class RepositoryDeleted<T extends Object> extends RepositoryEvent<T> {
  final String id;

  RepositoryDeleted(this.id);
}

abstract class BaseRepository<TEntity extends Object, TCreateDto, TUpdateDto, TFilterDto> {
  AsyncResult<TEntity> create(TCreateDto dto);
  AsyncResult<Unit> createAll(List<TCreateDto> dtos);
  AsyncResult<TEntity> update(TUpdateDto dto);
  AsyncResult<Unit> updateAll(List<TUpdateDto> dtos);
  AsyncResult<Unit> delete(String id);
  AsyncResult<TEntity> getById(String id);
  AsyncResult<List<TEntity>> search(TFilterDto filter);
  Stream<RepositoryEvent<TEntity>> observer();
  void dispose();
}
