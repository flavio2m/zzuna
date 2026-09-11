import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_filter_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

class ListaComprasListViewModel extends ChangeNotifier {
  final ListaComprasRepository _repository;
  StreamSubscription? _repositorySubscription;

  ListaComprasFilterDto filter = ListaComprasFilterDto(
    ano: DateTime.now().year,
    mes: Mes.fromDate(DateTime.now()),
  );

  ListaCompras? listaAtual;
  List<String> supermercadosDisponiveis = [];

  ListaComprasListViewModel(this._repository) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  void setFilter(ListaComprasFilterDto newFilter) {
    filter = newFilter;
    notifyListeners();
    loadCommand.execute();
  }

  List<ItemCompra> get itensFiltrados {
    if (listaAtual == null) return [];
    var itens = listaAtual!.itensOrdenados;

    if (filter.situacao != null) {
      itens = itens.where((i) => i.situacao == filter.situacao).toList();
    }

    if (filter.supermercado != null && filter.supermercado!.isNotEmpty) {
      itens = itens.where((i) {
        return i.supermercados.any(
          (s) => s.nome.toLowerCase() == filter.supermercado!.toLowerCase(),
        );
      }).toList();
    }

    return itens;
  }

  AsyncResult<ListaCompras> _load() async {
    final result = await _repository.getByPeriodo(filter.ano, filter.mes);
    if (result.isSuccess()) {
      listaAtual = result.getOrThrow();
      _atualizarSupermercadosDisponiveis();
    } else {
      listaAtual = null;
      supermercadosDisponiveis = [];
    }
    notifyListeners();
    if (listaAtual != null) {
      return Success(listaAtual!);
    }
    return Failure(
      LocalStorageException('Nenhuma lista encontrada para o período.'),
    );
  }

  void _atualizarSupermercadosDisponiveis() {
    if (listaAtual == null) {
      supermercadosDisponiveis = [];
      return;
    }
    final setSupers = <String>{};
    for (final item in listaAtual!.itens) {
      for (final s in item.supermercados) {
        if (s.nome.trim().isNotEmpty) {
          setSupers.add(s.nome.trim());
        }
      }
    }
    final listSupers = setSupers.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    supermercadosDisponiveis = listSupers;
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
