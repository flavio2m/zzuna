import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';

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
  const factory ItemCompra({
    required String id,
    required String produto,
    @Default(1.0) double quantidadePlanejada,
    @Default(0.0) double quantidadeComprada,
    @Default(0.0) double precoEstimado,
    @Default([]) List<SupermercadoItem> supermercados,
    @Default(ItemCompraSituacao.pendente) ItemCompraSituacao situacao,
  }) = _ItemCompra;

  factory ItemCompra.fromJson(Map<String, dynamic> json) =>
      _$ItemCompraFromJson(json);
}
