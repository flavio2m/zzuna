import 'dart:async';

import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_filter_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

import 'package:zzuna/utils/comparers/string_comparer.dart';

class CentroCustoListViewModel {
  final CentroCustoRepository _repository;
  StreamSubscription? _repositorySubscription;

  // Filter fields
  String? descricaoQuery;
  bool? ativoSelecionado;

  List<CentroCustoDetails> centros = [];

  CentroCustoListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<List<CentroCustoDetails>> _load() async {
    // Ensure seed data exists
    await _repository.getAll();

    final filter = CentroCustoFilterDto(
      descricao: descricaoQuery ?? '',
      ativo: ativoSelecionado,
    );
    final result = await _repository.search(filter);
    return result.map((list) {
      centros = _toDetailsList(list);
      return centros;
    });
  }

  List<CentroCustoDetails> _toDetailsList(List<CentroCusto> list) {
    return list.map(_toDetails).toList()..sort(
      (a, b) => StringComparer.compareIgnoreAccents(a.descricao, b.descricao),
    );
  }

  CentroCustoDetails _toDetails(CentroCusto centro) {
    return CentroCustoDetails(
      id: centro.id,
      descricao: centro.descricao,
      ativo: centro.ativo,
      padrao: centro.padrao,
    );
  }

  void setDescricao(String value) {
    descricaoQuery = value;
  }

  void setAtivo(bool? value) {
    ativoSelecionado = value;
    loadCommand.execute();
  }

  void pesquisar() {
    loadCommand.execute();
  }

  void dispose() {
    _repositorySubscription?.cancel();
  }
}
