import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';

class ListaComprasDuplicarViewModel {
  final ListaComprasRepository _repository;

  ListaComprasDuplicarViewModel(this._repository);

  late final duplicarListaCommand = Command1(_duplicarLista);

  AsyncResult<ListaCompras> _duplicarLista(
    ({ListaCompras listaOrigem, int anoDestino, Mes mesDestino}) params,
  ) async {
    final listaOrigem = params.listaOrigem;
    final anoDestino = params.anoDestino;
    final mesDestino = params.mesDestino;

    final existingRes = await _repository.getByPeriodo(anoDestino, mesDestino);
    if (existingRes.isSuccess()) {
      return Failure(
        LocalStorageException(
          'Já existe uma lista de compras para ${mesDestino.descricao}/$anoDestino.',
        ),
      );
    }

    final novosItens = listaOrigem.itens.map((item) {
      if (item.situacao == ItemCompraSituacao.comprado) {
        return item.copyWith(
          id: const Uuid().v4(),
          situacao: ItemCompraSituacao.pendente,
          quantidadeComprada: 0.0,
        );
      } else if (item.situacao == ItemCompraSituacao.pendente) {
        return item.copyWith(id: const Uuid().v4(), quantidadeComprada: 0.0);
      } else {
        // Cancelado permanece cancelado
        return item.copyWith(id: const Uuid().v4());
      }
    }).toList();

    novosItens.sort(
      (a, b) => a.produto.toLowerCase().compareTo(b.produto.toLowerCase()),
    );

    final novaListaDto = ListaComprasDto(
      ano: anoDestino,
      mes: mesDestino,
      itens: novosItens,
    );

    return _repository.create(novaListaDto);
  }
}
