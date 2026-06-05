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

abstract class BaseRepository<T extends Object> {
  AsyncResult<T> create(T model);
  AsyncResult<T> update(T model);
  AsyncResult<Unit> delete(String id);
  AsyncResult<List<T>> getAll();
  AsyncResult<T> getById(String id);
  Stream<RepositoryEvent<T>> observer();
  void dispose();
}
