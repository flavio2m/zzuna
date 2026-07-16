import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';

class CachedStorageDecorator<T extends Object> implements BaseStorage<T> {
  final BaseStorage<T> innerStorage;
  final Duration ttl;
  final String collectionName;
  final Map<String, dynamic> Function(T model)? toJson;

  // ignore: constant_identifier_names
  static const int TTL_MINUTES = 60;

  List<T>? _cache;
  DateTime? _lastFetch;
  AsyncResult<List<T>>? _pendingFetch;

  CachedStorageDecorator({
    required this.innerStorage,
    this.ttl = const Duration(minutes: TTL_MINUTES),
    required this.collectionName,
    this.toJson,
  });

  bool get _isCacheValid {
    if (_cache == null || _lastFetch == null) return false;
    final age = DateTime.now().difference(_lastFetch!);
    return age <= ttl;
  }

  void clearCache() {
    _cache = null;
    _lastFetch = null;
    _pendingFetch = null;
    if (kDebugMode) {
      developer.log(
        '[$collectionName] CACHE INVALIDADO',
        name: 'CachedStorage',
      );
    }
  }

  @override
  AsyncResult<T> create(T model) async {
    final result = await innerStorage.create(model);
    if (result.isSuccess()) {
      clearCache();
    }
    return result;
  }

  @override
  AsyncResult<Unit> createAll(List<T> models) async {
    final result = await innerStorage.createAll(models);
    if (result.isSuccess()) {
      clearCache();
    }
    return result;
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    final result = await innerStorage.delete(id);
    if (result.isSuccess()) {
      clearCache();
    }
    return result;
  }

  @override
  AsyncResult<Unit> deleteAll(List<String> ids) async {
    final result = await innerStorage.deleteAll(ids);
    if (result.isSuccess()) {
      clearCache();
    }
    return result;
  }

  @override
  AsyncResult<List<T>> getAll() async {
    // 1. Se o cache existir e for válido, retorna imediatamente sem acessar a rede.
    if (_isCacheValid) {
      if (kDebugMode) {
        developer.log(
          '[$collectionName] RETORNANDO DO CACHE (${_cache!.length} itens)',
          name: 'CachedStorage',
        );
      }
      return Success(_cache!);
    }

    // 2. Proteção contra "Thundering Herd" (múltiplas requisições simultâneas).
    // Se múltiplas views chamarem getAll() no mesmo milissegundo, a primeira cria
    // o _pendingFetch. As seguintes não vão na rede, apenas aguardam a primeira terminar.
    if (_pendingFetch != null) {
      if (kDebugMode) {
        developer.log(
          '[$collectionName] AGUARDANDO FETCH EM ANDAMENTO...',
          name: 'CachedStorage',
        );
      }
      return await _pendingFetch!;
    }

    // 3. Nenhuma busca em andamento. Inicia o tráfego de rede e salva a Future.
    _pendingFetch = innerStorage.getAll();
    final result = await _pendingFetch!;

    // Limpa a trava após a requisição finalizar
    _pendingFetch = null;

    // 4. Salva o resultado no cache local
    return result.onSuccess((list) {
      _cache = list;
      _lastFetch = DateTime.now();
      if (kDebugMode) {
        developer.log(
          '[$collectionName] CACHE ATUALIZADO VIA REDE',
          name: 'CachedStorage',
        );
      }
    });
  }

  @override
  AsyncResult<T> getById(String id) async {
    // If we have a valid cache, we could try to find it locally.
    // However, without knowing how to extract the ID from generic type T,
    // it's safer to just delegate or fetch if not present.
    // Since we don't have an interface for entity ID, we delegate.
    return innerStorage.getById(id);
  }

  @override
  AsyncResult<List<T>> searchByFields(
    List<SearchField> fields, {
    String? orderBy,
    SearchOrder order = SearchOrder.ascending,
    int? limit,
  }) async {
    // Se o cache é válido e temos toJson, resolvemos na memória
    if (_isCacheValid && toJson != null) {
      if (kDebugMode) {
        developer.log(
          '[$collectionName] SEARCH RETORNANDO DO CACHE',
          name: 'CachedStorage',
        );
      }
      try {
        var filtered = _cache!.where((item) {
          final itemMap = toJson!(item);

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
          filtered.sort((a, b) {
            final aMap = toJson!(a);
            final bMap = toJson!(b);
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

        if (limit != null && limit > 0 && filtered.length > limit) {
          filtered = filtered.sublist(0, limit);
        }

        return Success(filtered);
      } catch (e, s) {
        return Failure(
          LocalStorageException('Erro ao pesquisar no cache: $e', s),
        );
      }
    }

    // Se não tem cache ou não tem toJson, delega pro innerStorage
    return innerStorage.searchByFields(
      fields,
      orderBy: orderBy,
      order: order,
      limit: limit,
    );
  }

  @override
  AsyncResult<T> update(T model) async {
    final result = await innerStorage.update(model);
    if (result.isSuccess()) {
      clearCache();
    }
    return result;
  }

  @override
  AsyncResult<Unit> updateAll(List<T> models) async {
    final result = await innerStorage.updateAll(models);
    if (result.isSuccess()) {
      clearCache();
    }
    return result;
  }
}
