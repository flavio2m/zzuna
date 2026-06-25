import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

part 'lancamento_item.freezed.dart';
part 'lancamento_item.g.dart';

@freezed
sealed class LancamentoItem with _$LancamentoItem {
  const factory LancamentoItem({
    required int numero,
    required String centroCustoId,
    required String categoriaId,
    required double valor,
  }) = _LancamentoItem;

  factory LancamentoItem.fromJson(Map<String, dynamic> json) {
    return LancamentoItem(
      numero: json['numero'] as int? ?? 1,
      centroCustoId: json['centroCustoId'] as String? ?? '',
      categoriaId: json['categoriaId'] as String? ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

@freezed
sealed class LancamentoItemDetails with _$LancamentoItemDetails {
  const factory LancamentoItemDetails({
    required int numero,
    required CentroCustoDetails centroCusto,
    required CategoriaDetails categoria,
    required double valor,
  }) = _LancamentoItemDetails;
}
