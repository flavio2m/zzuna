import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_filter_dto.dart';
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

  AsyncResult<ListaCompras> _load() async {
    final result = await _repository.getByPeriodo(filter.ano, filter.mes);
    if (result.isSuccess()) {
      listaAtual = result.getOrThrow();
    } else {
      listaAtual = null;
    }
    notifyListeners();
    if (listaAtual != null) {
      return Success(listaAtual!);
    }
    return Failure(
      LocalStorageException('Nenhuma lista encontrada para o período.'),
    );
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
