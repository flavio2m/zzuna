import 'package:result_dart/result_dart.dart';

enum SearchFieldType { string, boolean, date }

class SearchField {
  final String fieldName;
  final dynamic value;
  final SearchFieldType type;

  SearchField({required this.fieldName, required this.value, required this.type});
}

abstract class BaseStorage<T extends Object> {
  AsyncResult<T> create(T model);
  AsyncResult<T> update(T model);
  AsyncResult<Unit> delete(String id);
  AsyncResult<List<T>> getAll();
  AsyncResult<T> getById(String id);
  AsyncResult<List<T>> searchByFields(List<SearchField> fields);
}
