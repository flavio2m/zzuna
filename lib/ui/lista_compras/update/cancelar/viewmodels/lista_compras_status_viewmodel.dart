import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';

class ListaComprasStatusViewModel {
  final ListaComprasRepository _repository;

  ListaComprasStatusViewModel(this._repository);

  late final alternarStatusItemCommand = Command1(_alternarStatusItem);

  AsyncResult<ListaCompras> _alternarStatusItem(
    ({
      ListaCompras lista,
      String itemId,
      ItemCompraSituacao situacao,
    }) params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;
    final situacao = params.situacao;

    final updatedItens = List<ItemCompra>.from(lista.itens);
    final index = updatedItens.indexWhere((i) => i.id == itemId);
    if (index == -1) {
      return Failure(LocalStorageException('Item não encontrado.'));
    }

    final item = updatedItens[index];
    double novaQtdComprada = item.quantidadeComprada;
    if (situacao == ItemCompraSituacao.comprado && novaQtdComprada == 0) {
      novaQtdComprada = item.quantidadePlanejada;
    } else if (situacao == ItemCompraSituacao.pendente) {
      novaQtdComprada = 0.0;
    }

    updatedItens[index] = item.copyWith(
      situacao: situacao,
      quantidadeComprada: novaQtdComprada,
    );

    final listaDto = ListaComprasDto(
      id: lista.id,
      ano: lista.ano,
      mes: lista.mes,
      itens: updatedItens,
    );

    return _repository.update(listaDto);
  }
}
