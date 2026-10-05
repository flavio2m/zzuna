import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';

part 'item_compra_entity.freezed.dart';
part 'item_compra_entity.g.dart';

@freezed
sealed class SupermercadoItem with _$SupermercadoItem {
  const factory SupermercadoItem({
    required String nome,
    @Default(false) bool ultimoUtilizado,
  }) = _SupermercadoItem;

  factory SupermercadoItem.fromJson(Map<String, dynamic> json) =>
      _$SupermercadoItemFromJson(json);
}

@freezed
sealed class ItemCompra with _$ItemCompra {
  const ItemCompra._();

  const factory ItemCompra({
    required String id,
    required String produto,
    @Default(1.0) double quantidadePlanejada,
    @Default([]) List<RegistroCompra> historicoCompras,
    @Default(0.0) double precoEstimado,
    @Default([]) List<SupermercadoItem> supermercados,
    @Default(ItemCompraSituacao.pendente) ItemCompraSituacao situacao,
    @Default('') String observacao,
    @JsonKey(name: 'quantidadeComprada')
    @Default(0.0)
    double quantidadeCompradaLegada,
  }) = _ItemCompra;

  double get quantidadeComprada {
    if (historicoCompras.isEmpty) return quantidadeCompradaLegada;
    return historicoCompras.fold(
      0.0,
      (soma, registro) => soma + registro.quantidade,
    );
  }

  ItemCompra migrarLegado([int? ano, Mes? mes]) {
    if (historicoCompras.isEmpty && quantidadeCompradaLegada > 0) {
      final now = DateTime.now();
      final anoRef = ano ?? now.year;
      final mesRef = mes?.numero ?? now.month;
      final bool isCurrentMonth = (anoRef == now.year && mesRef == now.month);
      final DateTime dataReferencia = isCurrentMonth
          ? RegistroCompra.truncateDate(now)
          : DateTime(anoRef, mesRef + 1, 0);

      final ultimoMercado =
          supermercados.where((s) => s.ultimoUtilizado).firstOrNull?.nome ??
          (supermercados.isNotEmpty ? supermercados.first.nome : null);

      return copyWith(
        historicoCompras: [
          RegistroCompra(
            data: RegistroCompra.truncateDate(dataReferencia),
            quantidade: quantidadeCompradaLegada,
            precoReal: precoEstimado,
            supermercadoId: ultimoMercado,
          ),
        ],
      );
    }
    return this;
  }

  factory ItemCompra.fromJson(Map<String, dynamic> json) =>
      _$ItemCompraFromJson(json);
}
