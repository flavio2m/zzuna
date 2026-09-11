import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';

class ItemComprasDeleteViewModel {
  final ListaComprasRepository _repository;

  ItemComprasDeleteViewModel(this._repository);

  late final removerItemCommand = Command1(_removerItem);

  AsyncResult<ListaCompras> _removerItem(
    ({ListaCompras lista, String itemId}) params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;

    final updatedItens = lista.itens.where((i) => i.id != itemId).toList();

    final listaDto = ListaComprasDto(
      id: lista.id,
      ano: lista.ano,
      mes: lista.mes,
      itens: updatedItens,
    );

    return _repository.update(listaDto);
  }
}
