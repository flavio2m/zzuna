import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';

class ListaComprasComprarViewModel {
  final ListaComprasRepository _repository;

  ListaComprasComprarViewModel(this._repository);

  late final comprarItemCommand = Command1(_comprarItem);

  AsyncResult<ListaCompras> _comprarItem(
    ({
      ListaCompras lista,
      String itemId,
      double quantidadeComprada,
      String? supermercadoNome,
      String? observacao,
      double? precoEstimado,
    })
    params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;
    final quantidadeComprada = params.quantidadeComprada;
    final supermercadoNome = params.supermercadoNome;
    final observacao = params.observacao;
    final precoEstimado = params.precoEstimado;

    if (quantidadeComprada < 0) {
      return Failure(
        LocalStorageException('A quantidade comprada não pode ser negativa.'),
      );
    }

    final updatedItens = List<ItemCompra>.from(lista.itens);
    final index = updatedItens.indexWhere((i) => i.id == itemId);
    if (index == -1) {
      return Failure(LocalStorageException('Item não encontrado.'));
    }

    final item = updatedItens[index];

    List<SupermercadoItem> updatedSupermercados = List.from(item.supermercados);

    if (supermercadoNome != null && supermercadoNome.trim().isNotEmpty) {
      final nomeTrimmed = supermercadoNome.trim();
      bool found = false;
      updatedSupermercados = updatedSupermercados.map((s) {
        if (s.nome.toLowerCase() == nomeTrimmed.toLowerCase()) {
          found = true;
          return s.copyWith(ultimoUtilizado: true);
        }
        return s.copyWith(ultimoUtilizado: false);
      }).toList();

      if (!found) {
        updatedSupermercados.add(
          SupermercadoItem(nome: nomeTrimmed, ultimoUtilizado: true),
        );
      }
    }

    final novaSituacao =
        (quantidadeComprada >= item.quantidadePlanejada &&
            item.quantidadePlanejada > 0)
        ? ItemCompraSituacao.comprado
        : item.situacao;

    updatedItens[index] = item.copyWith(
      quantidadeComprada: quantidadeComprada,
      supermercados: updatedSupermercados,
      situacao: novaSituacao,
      observacao: observacao != null ? observacao.trim() : item.observacao,
      precoEstimado: precoEstimado ?? item.precoEstimado,
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
