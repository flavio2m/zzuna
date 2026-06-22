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
  AsyncResult<List<T>> searchByFields(List<SearchField> fields) async {
    try {
      final listResult = await _getList();

      if (listResult.isError()) {
        return listResult.exceptionOrNull()!.toFailure();
      }

      final list = listResult.getOrThrow();

      final filtered = list.where((item) {
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
              if (field.value is List<DateTime?>) {
                final range = field.value as List<DateTime?>;
                if (fieldValue == null) return false;

                final date = DateTime.tryParse(fieldValue.toString());
                if (date == null) return false;

                if (range[0] != null && date.isBefore(range[0]!)) return false;
                if (range[1] != null && date.isAfter(range[1]!)) return false;

                return true;
              }
              return fieldValue == field.value;

            case SearchFieldType.int:
              if (field.value is List<int?>) {
                final range = field.value as List<int?>;
                if (fieldValue == null) return false;

                final val = num.tryParse(fieldValue.toString())?.toInt();
                if (val == null) return false;

                if (range[0] != null && val < range[0]!) return false;
                if (range[1] != null && val > range[1]!) return false;

                return true;
              }
              final val = num.tryParse(fieldValue.toString())?.toInt();
              return val == field.value;
          }
        });
      }).toList();

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
