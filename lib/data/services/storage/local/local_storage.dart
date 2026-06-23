import 'dart:convert';

import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:result_dart/result_dart.dart';

class LocalStorage<T extends Object> implements BaseStorage<T> {
  final SharedPreferencesService _prefsService;
  final String collectionName;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T model) toJson;

  // _prefsService será opicional
  LocalStorage({
    required this.collectionName,
    required this.fromJson,
    required this.toJson,
    SharedPreferencesService? prefsService,
  }) : _prefsService = prefsService ?? SharedPreferencesService();

  @override
  AsyncResult<T> create(T model) async {
    try {
      final listResult = await _getList();

      if (listResult.isError()) {
        return listResult.exceptionOrNull()!.toFailure();
      }

      final list = listResult.getOrThrow();
      list.add(model);

      final saveResult = await _saveList(list);

      return saveResult.fold((_) => Success(model), (error) => Failure(error));
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao criar: $e', s));
    }
  }

  @override
  AsyncResult<T> getById(String id) async {
    try {
      final listResult = await _getList();

      return listResult.fold((list) {
        final item = list.firstWhere(
          (item) => toJson(item)['id'] == id,
          orElse: () => throw LocalStorageException('Item não encontrado com id: $id'),
        );
        return Success(item);
      }, (error) => Failure(error));
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao buscar por id: $e', s));
    }
  }

  @override
  AsyncResult<T> update(T model) async {
    try {
      final listResult = await _getList();

      if (listResult.isError()) {
        return listResult.exceptionOrNull()!.toFailure();
      }

      final list = listResult.getOrThrow();
      final modelMap = toJson(model);
      final id = modelMap['id'];

      final index = list.indexWhere((item) => toJson(item)['id'] == id);

      if (index == -1) {
        return Failure(LocalStorageException('Item não encontrado com id: $id'));
      }

      list[index] = model;

      final saveResult = await _saveList(list);

      return saveResult.fold((_) => Success(model), (error) => Failure(error));
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao atualizar: $e', s));
    }
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    try {
      final listResult = await _getList();

      if (listResult.isError()) {
        return listResult.exceptionOrNull()!.toFailure();
      }

      final list = listResult.getOrThrow();
      final initialLength = list.length;

      list.removeWhere((item) => toJson(item)['id'] == id);

      if (list.length == initialLength) {
        return Failure(LocalStorageException('Item não encontrado com id: $id'));
      }

      return _saveList(list);
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao deletar: $e', s));
    }
  }

  @override
  AsyncResult<List<T>> getAll() async {
    return _getList();
  }

  @override
  AsyncResult<List<T>> searchByFields(
    List<SearchField> fields, {
    String? orderBy,
    SearchOrder order = SearchOrder.ascending,
    int? limit,
  }) async {
    try {
      final listResult = await _getList();

      if (listResult.isError()) {
        return listResult.exceptionOrNull()!.toFailure();
      }

      final list = listResult.getOrThrow();

      var filtered = list.where((item) {
        final itemMap = toJson(item);

        return fields.every((field) {
          final fieldValue = itemMap[field.fieldName];

          switch (field.type) {
            case SearchFieldType.string:
              if (fieldValue == null) return false;
              return fieldValue.toString().toLowerCase().contains(field.value.toString().toLowerCase());

            case SearchFieldType.boolean:
              return fieldValue == field.value;

            case SearchFieldType.date:
              if (fieldValue == null) return false;
              final date = DateTime.tryParse(fieldValue.toString());
              if (date == null) return false;

              if (field.operator == SearchOperator.between || field.value is List) {
                final range = field.value as List;
                final start = range[0] as DateTime?;
                final end = range[1] as DateTime?;
                if (start != null && date.isBefore(start)) return false;
                if (end != null && date.isAfter(end)) return false;
                return true;
              }

              final searchDate = field.value as DateTime;
              switch (field.operator) {
                case SearchOperator.equal:
                  return date.isAtSameMomentAs(searchDate);
                case SearchOperator.lessThan:
                  return date.isBefore(searchDate);
                case SearchOperator.lessThanOrEqual:
                  return !date.isAfter(searchDate);
                case SearchOperator.greaterThan:
                  return date.isAfter(searchDate);
                case SearchOperator.greaterThanOrEqual:
                  return !date.isBefore(searchDate);
                default:
                  return false;
              }

            case SearchFieldType.int:
              if (fieldValue == null) return false;
              final val = num.tryParse(fieldValue.toString())?.toInt();
              if (val == null) return false;

              if (field.operator == SearchOperator.between || field.value is List) {
                final range = field.value as List;
                final start = range[0] as int?;
                final end = range[1] as int?;
                if (start != null && val < start) return false;
                if (end != null && val > end) return false;
                return true;
              }

              final searchVal = num.tryParse(field.value.toString())?.toInt();
              if (searchVal == null) return false;
              switch (field.operator) {
                case SearchOperator.equal:
                  return val == searchVal;
                case SearchOperator.lessThan:
                  return val < searchVal;
                case SearchOperator.lessThanOrEqual:
                  return val <= searchVal;
                case SearchOperator.greaterThan:
                  return val > searchVal;
                case SearchOperator.greaterThanOrEqual:
                  return val >= searchVal;
                default:
                  return false;
              }
          }
        });
      }).toList();

      if (orderBy != null) {
        filtered.sort((a, b) {
          final aMap = toJson(a);
          final bMap = toJson(b);
          final aVal = aMap[orderBy];
          final bVal = bMap[orderBy];

          if (aVal == null && bVal == null) return 0;
          if (aVal == null) return 1;
          if (bVal == null) return -1;

          int compareResult;
          if (aVal is Comparable && bVal is Comparable) {
            compareResult = aVal.compareTo(bVal);
          } else {
            compareResult = aVal.toString().compareTo(bVal.toString());
          }

          return order == SearchOrder.ascending ? compareResult : -compareResult;
        });
      }

      if (limit != null && limit > 0 && filtered.length > limit) {
        filtered = filtered.sublist(0, limit);
      }

      return Success(filtered);
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao pesquisar: $e', s));
    }
  }

  @override
  AsyncResult<Unit> updateAll(List<T> models) async {
    try {
      for (final model in models) {
        final result = await update(model);
        if (result.isError()) {
          return Failure(result.exceptionOrNull()!);
        }
      }
      return const Success(unit);
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao atualizar lista: $e', s));
    }
  }

  AsyncResult<List<T>> _getList() async {
    final result = await _prefsService.getData(collectionName);

    return result.fold((jsonString) {
      try {
        if (jsonString.isEmpty) {
          return Success(<T>[]);
        }

        final List<dynamic> jsonList = jsonDecode(jsonString);
        final list = jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();

        return Success(list);
      } catch (e, s) {
        return Failure(LocalStorageException('Erro ao decodificar lista: $e', s));
      }
    }, (error) => Success(<T>[]));
  }

  AsyncResult<Unit> _saveList(List<T> list) async {
    try {
      final jsonList = list.map((item) => toJson(item)).toList();
      final jsonString = jsonEncode(jsonList);

      final result = await _prefsService.saveData(collectionName, jsonString);

      return result.fold((_) => const Success(unit), (error) => Failure(error));
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao salvar lista: $e', s));
    }
  }
}
