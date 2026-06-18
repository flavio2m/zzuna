import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

part 'lancamento_item_entity.freezed.dart';
part 'lancamento_item_entity.g.dart';

@freezed
sealed class LancamentoItem with _$LancamentoItem {
  const factory LancamentoItem({
    required String id,
    required String centroCustoId,
    required String categoriaId,
    required double valor,
  }) = _LancamentoItem;

  factory LancamentoItem.fromJson(
    Map<String, dynamic> json, //
  ) => _$LancamentoItemFromJson(json);
}

@freezed
sealed class LancamentoItemDetails with _$LancamentoItemDetails {
  const factory LancamentoItemDetails({
    required String id,
    required CentroCustoDetails centroCusto,
    required CategoriaDetails categoria,
    required double valor,
  }) = _LancamentoItemDetails;
}
