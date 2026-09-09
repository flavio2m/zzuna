import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/item_compra_dto.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_filter_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';

class ListaComprasCreateViewModel {
  final ListaComprasRepository _repository;

  ListaComprasCreateViewModel(this._repository);

  late final criarListaVaziaCommand = Command1(_criarListaVazia);
  late final salvarItemCommand = Command1(_salvarItem);

  AsyncResult<ListaCompras> _criarListaVazia(
    ListaComprasFilterDto filter,
  ) async {
    final dto = ListaComprasDto(ano: filter.ano, mes: filter.mes, itens: []);
    return _repository.create(dto);
  }

  AsyncResult<ListaCompras> _salvarItem(
    ({
      ItemCompraDto dto,
      ListaComprasFilterDto filter,
      ListaCompras? listaAtual,
    })
    params,
  ) async {
    final dto = params.dto;
    final filter = params.filter;
    ListaCompras? lista = params.listaAtual;

    if (dto.produto.trim().isEmpty) {
      return Failure(LocalStorageException('O nome do produto é obrigatório.'));
    }
    if (dto.precoEstimado < 0) {
      return Failure(
        LocalStorageException('O preço estimado não pode ser negativo.'),
      );
    }
    if (dto.quantidadePlanejada <= 0) {
      return Failure(
        LocalStorageException(
          'A quantidade planejada deve ser maior que zero.',
        ),
      );
    }

    if (lista == null) {
      final createListRes = await _repository.create(
        ListaComprasDto(ano: filter.ano, mes: filter.mes),
      );
      if (createListRes.isError()) return createListRes;
      lista = createListRes.getOrThrow();
    }

    final updatedItens = List<ItemCompra>.from(lista.itens);

    if (dto.id != null) {
      final index = updatedItens.indexWhere((i) => i.id == dto.id);
      if (index != -1) {
        updatedItens[index] = ItemCompra(
          id: dto.id!,
          produto: dto.produto.trim(),
          quantidadePlanejada: dto.quantidadePlanejada,
          quantidadeComprada: dto.quantidadeComprada,
          precoEstimado: dto.precoEstimado,
          supermercados: dto.supermercados,
          situacao: dto.situacao,
        );
      } else {
        updatedItens.add(
          ItemCompra(
            id: dto.id!,
            produto: dto.produto.trim(),
            quantidadePlanejada: dto.quantidadePlanejada,
            quantidadeComprada: dto.quantidadeComprada,
            precoEstimado: dto.precoEstimado,
            supermercados: dto.supermercados,
            situacao: dto.situacao,
          ),
        );
      }
    } else {
      updatedItens.add(
        ItemCompra(
          id: const Uuid().v4(),
          produto: dto.produto.trim(),
          quantidadePlanejada: dto.quantidadePlanejada,
          quantidadeComprada: dto.quantidadeComprada,
          precoEstimado: dto.precoEstimado,
          supermercados: dto.supermercados,
          situacao: dto.situacao,
        ),
      );
    }

    final listaDto = ListaComprasDto(
      id: lista.id,
      ano: lista.ano,
      mes: lista.mes,
      itens: updatedItens,
    );

    return _repository.update(listaDto);
  }
}
