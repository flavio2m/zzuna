import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/conta_filter_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';

class ContaListViewModel extends ChangeNotifier {
  final ContaRepository _repository;
  StreamSubscription? _repositorySubscription;

  // Itens da barra de filtro
  String? descricaoQuery;
  String? bancoSelecionado;
  bool? statusSelecionado;

  List<ContaDetails> contas = [];

  ContaListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<List<ContaDetails>> _load() async {
    // Garante que o banco está populado com dados iniciais (se for a primeira execução)
    await _repository.getAll();

    final filter = ContaFilterDto(
      descricao: descricaoQuery ?? '',
      bancoSigla: bancoSelecionado,
      ativo: statusSelecionado,
    );

    final result = await _repository.search(filter);

    return result.map((list) {
      contas = _toDetailsList(list);
      return contas;
    });
  }

  List<ContaDetails> _toDetailsList(List<Conta> contas) {
    return contas.map(_toDetails).toList();
  }

  ContaDetails _toDetails(Conta conta) {
    final banco = Bancos.bySigla(conta.bancoSigla).getOrThrow();

    return ContaDetails(
      id: conta.id,
      descricao: conta.descricao,
      banco: banco,
      ativo: conta.ativo, //
    );
  }

  void setDescricao(String value) {
    descricaoQuery = value;
    loadCommand.execute();
    notifyListeners();
  }

  void setBanco(String? value) {
    bancoSelecionado = value;
    loadCommand.execute();
    notifyListeners();
  }

  void setStatus(bool? value) {
    statusSelecionado = value;
    loadCommand.execute();
    notifyListeners();
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
