import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:result_dart/result_dart.dart';

class FirebaseRealtimeStorage<T extends Object> implements BaseStorage<T> {
  final String collectionName;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T model) toJson;
  final FirebaseDatabase _db;

  FirebaseRealtimeStorage({
    required this.collectionName,
    required this.fromJson,
    required this.toJson,
    FirebaseDatabase? database,
  }) : _db = database ?? FirebaseDatabase.instance;

  DatabaseReference get _ref {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw LocalStorageException('Usuário não autenticado no Firebase.');
    }
    return _db.ref(uid).child(collectionName);
  }

  @override
  AsyncResult<T> create(T model) async {
    try {
      final json = toJson(model);
      final id = json['id'] as String;
      await _ref.child(id).set(json);
      return Success(model);
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao criar no Firebase: $e', s));
    }
  }

  @override
  AsyncResult<Unit> createAll(List<T> models) async {
    try {
      final updates = <String, dynamic>{};
      for (final model in models) {
        final json = toJson(model);
        final id = json['id'] as String;
        updates[id] = json;
      }
      if (updates.isNotEmpty) {
        await _ref.update(updates);
      }
      return const Success(unit);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao criar lista no Firebase: $e', s),
      );
    }
  }

  @override
  AsyncResult<T> getById(String id) async {
    try {
      final snapshot = await _ref.child(id).get();
      if (snapshot.exists && snapshot.value != null) {
        final data = _convertMap(snapshot.value as Map);
        return Success(fromJson(data));
      }
      return Failure(LocalStorageException('Item não encontrado com id: $id'));
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao buscar por id no Firebase: $e', s),
      );
    }
  }

  @override
  AsyncResult<T> update(T model) async {
    try {
      final json = toJson(model);
      final id = json['id'] as String;
      await _ref.child(id).set(json);
      return Success(model);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao atualizar no Firebase: $e', s),
      );
    }
  }

  @override
  AsyncResult<Unit> updateAll(List<T> models) async {
    try {
      final updates = <String, dynamic>{};
      for (final model in models) {
        final json = toJson(model);
        final id = json['id'] as String;
        updates[id] = json;
      }
      if (updates.isNotEmpty) {
        await _ref.update(updates);
      }
      return const Success(unit);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao atualizar lista no Firebase: $e', s),
      );
    }
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    try {
      await _ref.child(id).remove();
      return const Success(unit);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao deletar no Firebase: $e', s),
      );
    }
  }

  @override
  AsyncResult<List<T>> getAll() async {
    try {
      final snapshot = await _ref.get();
      if (snapshot.exists && snapshot.value != null) {
        final map = snapshot.value as Map;
        final list = map.values
            .map((v) => fromJson(_convertMap(v as Map)))
            .toList();
        return Success(list);
      }
      return Success(<T>[]);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao buscar todos no Firebase: $e', s),
      );
    }
  }

  Map<String, dynamic> _convertMap(Map rawMap) {
    final Map<String, dynamic> result = {};
    if (rawMap.isEmpty) {
      return result;
    }
    rawMap.forEach((key, value) {
      if (key == null) return;
      final String stringKey = key.toString();
      if (value == null) {
        result[stringKey] = null;
      } else if (value is Map) {
        result[stringKey] = _convertMap(value);
      } else if (value is List) {
        result[stringKey] = value.map((item) {
          if (item is Map) return _convertMap(item);
          return item;
        }).toList();
      } else {
        result[stringKey] = value;
      }
    });
    return result;
  }

  Map<String, SearchField?> _categorizeSearchFields(List<SearchField> fields) {
    SearchField? dateField;
    SearchField? boolField;
    SearchField? stringField;
    SearchField? intField;

    for (final f in fields) {
      if (f.type == SearchFieldType.date && dateField == null) {
        dateField = f;
      } else if (f.type == SearchFieldType.boolean && boolField == null) {
        boolField = f;
      } else if (f.type == SearchFieldType.string && stringField == null) {
        stringField = f;
      } else if (f.type == SearchFieldType.int && intField == null) {
        intField = f;
      }
    }

    return {
      'date': dateField,
      'boolean': boolField,
      'string': stringField,
      'int': intField,
    };
  }

  Query _buildQuery(Map<String, SearchField?> fields) {
    Query query = _ref;

    if (fields['date'] != null) {
      final field = fields['date']!;
      query = query.orderByChild(field.fieldName);

      if (field.operator == SearchOperator.between || field.value is List) {
        final range = field.value as List;
        final start = range[0] as DateTime?;
        final end = range[1] as DateTime?;

        if (start != null) {
          query = query.startAt(start.toIso8601String());
        }
        if (end != null) {
          query = query.endAt(end.toIso8601String());
        }
      } else {
        if (field.value is DateTime) {
          final dt = (field.value as DateTime).toIso8601String();
          if (field.operator == SearchOperator.equal) {
            query = query.equalTo(dt);
          } else if (field.operator == SearchOperator.greaterThan ||
              field.operator == SearchOperator.greaterThanOrEqual) {
            query = query.startAt(dt);
          } else if (field.operator == SearchOperator.lessThan ||
              field.operator == SearchOperator.lessThanOrEqual) {
            query = query.endAt(dt);
          }
        }
      }
    } else if (fields['boolean'] != null) {
      final field = fields['boolean']!;
      if (field.operator == SearchOperator.equal) {
        query = query.orderByChild(field.fieldName).equalTo(field.value);
      }
    } else if (fields['string'] != null) {
      final field = fields['string']!;
      if (field.operator == SearchOperator.equal) {
        query = query
            .orderByChild(field.fieldName)
            .startAt(field.value.toString())
            .endAt('${field.value.toString()}\uf8ff');
      }
    } else if (fields['int'] != null) {
      final field = fields['int']!;
      if (field.operator == SearchOperator.equal) {
        query = query.orderByChild(field.fieldName).equalTo(field.value);
      } else if (field.operator == SearchOperator.greaterThan ||
          field.operator == SearchOperator.greaterThanOrEqual) {
        query = query.orderByChild(field.fieldName).startAt(field.value);
      } else if (field.operator == SearchOperator.lessThan ||
          field.operator == SearchOperator.lessThanOrEqual) {
        query = query.orderByChild(field.fieldName).endAt(field.value);
      }
    }

    return query;
  }

  @override
  AsyncResult<List<T>> searchByFields(
    List<SearchField> fields, {
    String? orderBy,
    SearchOrder order = SearchOrder.ascending,
    int? limit,
  }) async {
    try {
      Query query = _ref;

      // Firebase permite apenas um orderByChild por Query.
      // Se tiver orderBy explicito, usamos ele. Senão, delegamos para o melhor filtro.
      if (orderBy != null) {
        query = query.orderByChild(orderBy);
      } else if (fields.isNotEmpty) {
        final categorizedFields = _categorizeSearchFields(fields);
        query = _buildQuery(categorizedFields);
      }

      final snapshot = await query.get();
      if (!snapshot.exists || snapshot.value == null) {
        return Success(<T>[]);
      }

      final map = snapshot.value as Map;
      var list = map.values
          .map((v) => fromJson(_convertMap(v as Map)))
          .toList();

      // Aplicar filtros em memória para campos restantes
      list = list.where((item) {
        final itemMap = toJson(item);

        return fields.every((field) {
          final fieldValue = itemMap[field.fieldName];

          switch (field.type) {
            case SearchFieldType.string:
              if (fieldValue == null) return false;
              return fieldValue.toString().toLowerCase().contains(
                field.value.toString().toLowerCase(),
              );

            case SearchFieldType.boolean:
              return fieldValue == field.value;

            case SearchFieldType.date:
              if (fieldValue == null) return false;
              final date = DateTime.tryParse(fieldValue.toString());
              if (date == null) return false;

              if (field.operator == SearchOperator.between ||
                  field.value is List) {
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

              if (field.operator == SearchOperator.between ||
                  field.value is List) {
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
        list.sort((a, b) {
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

          return order == SearchOrder.ascending
              ? compareResult
              : -compareResult;
        });
      }

      if (limit != null && limit > 0 && list.length > limit) {
        list = list.sublist(0, limit);
      }

      return Success(list);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao pesquisar no Firebase: $e', s),
      );
    }
  }
}
