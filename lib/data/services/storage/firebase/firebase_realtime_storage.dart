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

  DatabaseReference get _ref => _db.ref(collectionName);

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
        final data = Map<String, dynamic>.from(snapshot.value as Map);
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
      // using update instead of set to avoid overwriting unrelated nested fields,
      // but since we save entire objects, set is also fine. We use set.
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
            .map((v) => fromJson(Map<String, dynamic>.from(v as Map)))
            .toList();
        return Success(list);
      }
      return const Success([]);
    } catch (e, s) {
      return Failure(
        LocalStorageException('Erro ao buscar todos no Firebase: $e', s),
      );
    }
  }

  @override
  AsyncResult<List<T>> searchByFields(
    List<SearchField> fields, {
    String? orderBy,
    SearchOrder order = SearchOrder.ascending,
    int? limit,
  }) async {
    try {
      // Firebase Realtime DB limits querying to ONE field via orderByChild.
      // So if orderBy is provided, we use it for the query.
      // If no orderBy is provided but there is an equality filter, we can optimize by that field.
      // However, since we support multiple fields and operators (between, etc),
      // the safest generic approach is to fetch all OR fetch sorted by orderBy
      // and then apply the rest of the filters in memory (which matches LocalStorage logic).
      // For large datasets, proper composite keys (like periodo for extratoFatura) are the best.

      Query query = _ref;
      if (orderBy != null) {
        query = query.orderByChild(orderBy);
        // We cannot use startAt/endAt easily generically without knowing the types deeply,
        // and limitToFirst depends on whether we also do in-memory filtering.
        // If we filter in-memory, we can't limit at DB level securely unless it's just sorting.
      } else if (fields.isNotEmpty) {
        // Try to optimize at least the first equality field
        final eqField = fields
            .where((f) => f.operator == SearchOperator.equal)
            .firstOrNull;
        if (eqField != null) {
          query = query.orderByChild(eqField.fieldName).equalTo(eqField.value);
        }
      }

      final snapshot = await query.get();
      if (!snapshot.exists || snapshot.value == null) {
        return const Success([]);
      }

      final map = snapshot.value as Map;
      var list = map.values
          .map((v) => fromJson(Map<String, dynamic>.from(v as Map)))
          .toList();

      // Apply in-memory filtering for the rest of the fields exactly like LocalStorage
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

      // If we used a custom DB sort but there were other filters, we might need to re-sort
      // or if order was descending, DB orderByChild only does ascending.
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
