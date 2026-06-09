import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

class CartaoListViewModel extends ChangeNotifier {
  final CartaoRepository _repository;
  StreamSubscription? _repositorySubscription;

  CartaoListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  // --- Commands ---

  late final loadCommand = Command0(_load);
  late final filterCommand = Command1(_filter);

  // --- Methods ---

  AsyncResult<List<Cartao>> _load() async {
    return _repository.getAll();
  }

  AsyncResult<List<Cartao>> _filter(String query) async {
    final result = await _repository.getAll();
    return result.map((cartoes) {
      if (query.isEmpty) return cartoes;
      return cartoes.where((c) => c.descricao.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
