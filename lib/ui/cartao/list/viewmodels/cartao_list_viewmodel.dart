import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_filter_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';

class CartaoListViewModel extends ChangeNotifier {
  final CartaoRepository _repository;
  StreamSubscription? _repositorySubscription;

  // Itens da barra de filtro
  String? descricaoQuery;
  String? bancoSelecionado;
  bool? statusSelecionado;

  List<CartaoDetails> cartoes = [];

  CartaoListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<List<CartaoDetails>> _load() async {
    // Garante que o banco está populado com dados iniciais
    await _repository.getAll();

    final filter = CartaoFilterDto(
      descricao: descricaoQuery ?? '',
      bancoSigla: bancoSelecionado,
      ativo: statusSelecionado,
    );

    final result = await _repository.search(filter);

    return result.map((list) {
      cartoes = _toDetailsList(list);
      return cartoes;
    });
  }

  List<CartaoDetails> _toDetailsList(List<Cartao> cartoes) {
    return cartoes.map(_toDetails).toList();
  }

  CartaoDetails _toDetails(Cartao cartao) {
    final banco = Bancos.bySigla(cartao.bancoSigla).getOrThrow();

    return CartaoDetails(
      id: cartao.id,
      descricao: cartao.descricao,
      limite: cartao.limite,
      banco: banco,
      ativo: cartao.ativo,
      diaFechamento: cartao.diaFechamento,
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
