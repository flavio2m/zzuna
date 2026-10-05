import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';

class ListaComprasDeleteListaViewModel {
  final ListaComprasRepository _repository;

  ListaComprasDeleteListaViewModel(this._repository);

  late final excluirListaCommand = Command1(_excluirLista);

  AsyncResult<Unit> _excluirLista(ListaCompras lista) async {
    final temItemComprado = lista.itens.any(
      (item) => item.situacao == ItemCompraSituacao.comprado,
    );
    if (temItemComprado) {
      return Failure(
        LocalStorageException(
          'Não é possível excluir uma lista que possui itens comprados.',
        ),
      );
    }

    return _repository.delete(lista.id);
  }
}
