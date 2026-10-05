import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';

class ListaComprasStatusViewModel {
  final ListaComprasRepository _repository;

  ListaComprasStatusViewModel(this._repository);

  late final alternarStatusItemCommand = Command1(_alternarStatusItem);

  AsyncResult<ListaCompras> _alternarStatusItem(
    ({ListaCompras lista, String itemId, ItemCompraSituacao situacao}) params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;
    final situacao = params.situacao;

    final updatedItens = List<ItemCompra>.from(lista.itens);
    final index = updatedItens.indexWhere((i) => i.id == itemId);
    if (index == -1) {
      return Failure(LocalStorageException('Item não encontrado.'));
    }

    final item = updatedItens[index].migrarLegado(lista.ano, lista.mes);

    // Não é permitido cancelar item já comprado
    if (situacao == ItemCompraSituacao.cancelado &&
        item.situacao == ItemCompraSituacao.comprado) {
      return Failure(
        LocalStorageException('Não é permitido cancelar um item já comprado.'),
      );
    }

    // Não é permitido marcar como comprado item cancelado
    if (situacao == ItemCompraSituacao.comprado &&
        item.situacao == ItemCompraSituacao.cancelado) {
      return Failure(
        LocalStorageException('Não é permitido comprar um item cancelado.'),
      );
    }

    List<RegistroCompra> novosRegistros = item.historicoCompras;
    double novaQtdComprada = item.quantidadeComprada;

    if (situacao == ItemCompraSituacao.comprado) {
      final restante = item.quantidadePlanejada - item.quantidadeComprada;
      final qtdAdicionar = restante > 0
          ? restante
          : (item.quantidadePlanejada > 0 ? item.quantidadePlanejada : 1.0);

      final ultimoMercado =
          item.supermercados
              .where((s) => s.ultimoUtilizado)
              .firstOrNull
              ?.nome ??
          (item.supermercados.isNotEmpty
              ? item.supermercados.first.nome
              : null);

      final novoRegistro = RegistroCompra(
        data: RegistroCompra.truncateDate(DateTime.now()),
        quantidade: qtdAdicionar,
        precoReal: item.precoEstimado,
        supermercadoId: ultimoMercado,
      );

      novosRegistros = [...item.historicoCompras, novoRegistro];
      novaQtdComprada = novosRegistros.fold(
        0.0,
        (soma, r) => soma + r.quantidade,
      );
    } else if (situacao == ItemCompraSituacao.pendente &&
        item.situacao == ItemCompraSituacao.comprado) {
      novosRegistros = const [];
      novaQtdComprada = 0.0;
    }

    updatedItens[index] = item.copyWith(
      situacao: situacao,
      historicoCompras: novosRegistros,
      quantidadeCompradaLegada: novaQtdComprada,
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
