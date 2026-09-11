import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';

class ListaComprasDeleteListaViewModel {
  final ListaComprasRepository _repository;

  ListaComprasDeleteListaViewModel(this._repository);

  late final excluirListaCommand = Command1(_excluirLista);

  AsyncResult<Unit> _excluirLista(ListaCompras lista) async {
    return _repository.delete(lista.id);
  }
}
