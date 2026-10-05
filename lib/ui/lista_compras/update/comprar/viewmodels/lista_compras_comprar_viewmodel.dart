import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';

class ListaComprasComprarViewModel {
  final ListaComprasRepository _repository;

  ListaComprasComprarViewModel(this._repository);

  late final comprarItemCommand = Command1(_comprarItem);
  late final removerRegistroCompraCommand = Command1(_removerRegistroCompra);

  AsyncResult<ListaCompras> _comprarItem(
    ({
      ListaCompras lista,
      String itemId,
      double quantidadeComprada,
      DateTime? data,
      double? precoReal,
      String? supermercadoNome,
      String? observacao,
      double? precoEstimado,
    })
    params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;
    final quantidadeComprada = params.quantidadeComprada;
    final data = params.data ?? DateTime.now();
    final precoReal = params.precoReal;
    final supermercadoNome = params.supermercadoNome;
    final observacao = params.observacao;
    final precoEstimado = params.precoEstimado;

    if (quantidadeComprada <= 0) {
      return Failure(
        LocalStorageException('A quantidade comprada deve ser maior que zero.'),
      );
    }

    final updatedItens = List<ItemCompra>.from(lista.itens);
    final index = updatedItens.indexWhere((i) => i.id == itemId);
    if (index == -1) {
      return Failure(LocalStorageException('Item não encontrado.'));
    }

    final item = updatedItens[index].migrarLegado(lista.ano, lista.mes);

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

    final novoRegistro = RegistroCompra(
      data: RegistroCompra.truncateDate(data),
      quantidade: quantidadeComprada,
      precoReal: precoReal ?? precoEstimado ?? item.precoEstimado,
      supermercadoId:
          (supermercadoNome != null && supermercadoNome.trim().isNotEmpty)
          ? supermercadoNome.trim()
          : null,
    );

    final novosRegistros = [...item.historicoCompras, novoRegistro];
    final totalComprado = novosRegistros.fold(
      0.0,
      (soma, r) => soma + r.quantidade,
    );

    final novaSituacao =
        (totalComprado >= item.quantidadePlanejada &&
            item.quantidadePlanejada > 0)
        ? ItemCompraSituacao.comprado
        : ItemCompraSituacao.pendente;

    updatedItens[index] = item.copyWith(
      historicoCompras: novosRegistros,
      quantidadeCompradaLegada: totalComprado,
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

  AsyncResult<ListaCompras> _removerRegistroCompra(
    ({ListaCompras lista, String itemId, int registroIndex}) params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;
    final registroIndex = params.registroIndex;

    final updatedItens = List<ItemCompra>.from(lista.itens);
    final index = updatedItens.indexWhere((i) => i.id == itemId);
    if (index == -1) {
      return Failure(LocalStorageException('Item não encontrado.'));
    }

    final item = updatedItens[index];
    if (registroIndex < 0 || registroIndex >= item.historicoCompras.length) {
      return Failure(
        LocalStorageException('Registro de compra não encontrado.'),
      );
    }

    final novosRegistros = List<RegistroCompra>.from(item.historicoCompras);
    novosRegistros.removeAt(registroIndex);

    final totalComprado = novosRegistros.fold(
      0.0,
      (soma, r) => soma + r.quantidade,
    );

    final novaSituacao =
        (totalComprado >= item.quantidadePlanejada &&
            item.quantidadePlanejada > 0)
        ? ItemCompraSituacao.comprado
        : ItemCompraSituacao.pendente;

    updatedItens[index] = item.copyWith(
      historicoCompras: novosRegistros,
      quantidadeCompradaLegada: totalComprado,
      situacao: novaSituacao,
    );

    final listaDto = ListaComprasDto(
      id: lista.id,
      ano: lista.ano,
      mes: lista.mes,
      itens: updatedItens,
    );

    return _repository.update(listaDto);
  }

  late final editarRegistroCompraCommand = Command1(_editarRegistroCompra);

  AsyncResult<ListaCompras> _editarRegistroCompra(
    ({
      ListaCompras lista,
      String itemId,
      int registroIndex,
      DateTime data,
      double quantidade,
      double precoReal,
      String? supermercadoNome,
    })
    params,
  ) async {
    final lista = params.lista;
    final itemId = params.itemId;
    final registroIndex = params.registroIndex;
    final data = params.data;
    final quantidade = params.quantidade;
    final precoReal = params.precoReal;
    final supermercadoNome = params.supermercadoNome;

    if (quantidade <= 0) {
      return Failure(
        LocalStorageException('A quantidade comprada deve ser maior que zero.'),
      );
    }

    final updatedItens = List<ItemCompra>.from(lista.itens);
    final index = updatedItens.indexWhere((i) => i.id == itemId);
    if (index == -1) {
      return Failure(LocalStorageException('Item não encontrado.'));
    }

    final item = updatedItens[index].migrarLegado(lista.ano, lista.mes);
    if (registroIndex < 0 || registroIndex >= item.historicoCompras.length) {
      return Failure(
        LocalStorageException('Registro de compra não encontrado.'),
      );
    }

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

    final novoRegistro = RegistroCompra(
      data: RegistroCompra.truncateDate(data),
      quantidade: quantidade,
      precoReal: precoReal,
      supermercadoId:
          (supermercadoNome != null && supermercadoNome.trim().isNotEmpty)
          ? supermercadoNome.trim()
          : null,
    );

    final novosRegistros = List<RegistroCompra>.from(item.historicoCompras);
    novosRegistros[registroIndex] = novoRegistro;

    final totalComprado = novosRegistros.fold(
      0.0,
      (soma, r) => soma + r.quantidade,
    );

    final novaSituacao =
        (totalComprado >= item.quantidadePlanejada &&
            item.quantidadePlanejada > 0)
        ? ItemCompraSituacao.comprado
        : ItemCompraSituacao.pendente;

    updatedItens[index] = item.copyWith(
      historicoCompras: novosRegistros,
      quantidadeCompradaLegada: totalComprado,
      supermercados: updatedSupermercados,
      situacao: (item.situacao == ItemCompraSituacao.cancelado)
          ? ItemCompraSituacao.cancelado
          : novaSituacao,
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
