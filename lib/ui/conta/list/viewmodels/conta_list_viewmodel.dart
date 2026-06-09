import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

class ContaListViewModel extends ChangeNotifier {
  final ContaRepository _repository;
  StreamSubscription? _repositorySubscription;

  ContaListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  // --- Commands ---

  late final loadCommand = Command0(_load);
  late final filterCommand = Command1(_filter);
  late final createCommand = Command1(_create);
  late final updateCommand = Command1(_update);
  late final deleteCommand = Command1(_delete);

  // --- Methods ---

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

  AsyncResult<Conta> _create(CreateContaDto dto) async {
    return _repository.create(dto);
  }

  AsyncResult<Conta> _update(LoadedContaDto dto) async {
    return _repository.update(dto);
  }

  AsyncResult<Unit> _delete(String id) async {
    return _repository.delete(id);
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
