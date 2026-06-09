import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

class ContaListViewModel extends ChangeNotifier {
  final ContaRepository _repository;
  StreamSubscription? _repositorySubscription;

  ContaListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);
  late final filterCommand = Command1(_filter);

  AsyncResult<List<Conta>> _load() async {
    return _repository.getAll();
  }

  AsyncResult<List<Conta>> _filter(String query) async {
    final result = await _repository.getAll();
    return result.map((contas) {
      if (query.isEmpty) return contas;
      return contas.where((c) => c.descricao.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
