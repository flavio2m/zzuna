import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';

part 'lista_compras_entity.freezed.dart';
part 'lista_compras_entity.g.dart';

@freezed
sealed class ListaCompras with _$ListaCompras {
  const ListaCompras._();

  const factory ListaCompras({
    required String id,
    required int ano,
    required Mes mes,
    required int periodo,
    @Default([]) List<ItemCompra> itens,
  }) = _ListaCompras;

  factory ListaCompras.fromJson(Map<String, dynamic> json) =>
      _$ListaComprasFromJson(json);

  int get totalItens => itens.length;

  List<ItemCompra> get itensOrdenados {
    final list = List<ItemCompra>.from(itens);
    list.sort(
      (a, b) => a.produto.toLowerCase().compareTo(b.produto.toLowerCase()),
    );
    return list;
  }

  int get totalComprados => itens
      .where(
        (item) =>
            item.situacao == ItemCompraSituacao.comprado ||
            (item.situacao != ItemCompraSituacao.cancelado &&
                item.quantidadeComprada >= item.quantidadePlanejada &&
                item.quantidadePlanejada > 0),
      )
      .length;

  int get totalParcialmenteComprados => itens
      .where(
        (item) =>
            item.situacao != ItemCompraSituacao.cancelado &&
            item.quantidadeComprada > 0 &&
            item.quantidadeComprada < item.quantidadePlanejada,
      )
      .length;

  int get totalPendentes => itens
      .where(
        (item) =>
            item.situacao == ItemCompraSituacao.pendente &&
            item.quantidadeComprada == 0,
      )
      .length;

  int get totalCancelados => itens
      .where((item) => item.situacao == ItemCompraSituacao.cancelado)
      .length;

  double get valorEstimadoTotal => itens
      .where((item) => item.situacao != ItemCompraSituacao.cancelado)
      .fold(
        0.0,
        (sum, item) => sum + (item.quantidadePlanejada * item.precoEstimado),
      );

  double get valorEstimadoComprado => itens
      .where((item) => item.situacao != ItemCompraSituacao.cancelado)
      .fold(
        0.0,
        (sum, item) => sum + (item.quantidadeComprada * item.precoEstimado),
      );

  double get valorEstimadoPendente {
    final diff = valorEstimadoTotal - valorEstimadoComprado;
    return diff > 0 ? diff : 0.0;
  }
}
