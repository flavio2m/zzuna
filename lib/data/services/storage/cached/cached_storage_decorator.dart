import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';

class CachedStorageDecorator<T extends Object> implements BaseStorage<T> {
  final BaseStorage<T> innerStorage;
  final Duration ttl;
  final String collectionName;

  // ignore: constant_identifier_names
  static const int TTL_MINUTES = 60;

  List<T>? _cache;
  DateTime? _lastFetch;
  AsyncResult<List<T>>? _pendingFetch;

  CachedStorageDecorator({
    required this.innerStorage,
    this.ttl = const Duration(minutes: TTL_MINUTES),
    required this.collectionName,
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
    // We delegate search to the inner storage as requested for now.
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
