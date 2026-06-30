import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

part 'lancamento_item.freezed.dart';

@freezed
sealed class LancamentoItem with _$LancamentoItem {
  const LancamentoItem._();

  const factory LancamentoItem({
    required int numero,
    required String centroCustoId,
    required String categoriaId,
    required double valor,
  }) = LancamentoItemStandard;

  const factory LancamentoItem.transferencia({
    required int numero,
    required LancamentoOrigem origemEntrada,
    required LancamentoOrigem origemSaida,
    required double valor,
  }) = LancamentoItemTransferencia;

  factory LancamentoItem.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('origemEntrada') ||
        json.containsKey('origemSaida') ||
        json['runtimeType'] == 'transferencia') {
      return LancamentoItem.transferencia(
        numero: json['numero'] as int? ?? 1,
        origemEntrada: LancamentoOrigem.fromJson(
          Map<String, dynamic>.from(json['origemEntrada']),
        ),
        origemSaida: LancamentoOrigem.fromJson(
          Map<String, dynamic>.from(json['origemSaida']),
        ),
        valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      );
    }
    return LancamentoItem(
      numero: json['numero'] as int? ?? 1,
      centroCustoId: json['centroCustoId'] as String? ?? '',
      categoriaId: json['categoriaId'] as String? ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return map(
      (standard) => {
        'runtimeType': 'default',
        'numero': standard.numero,
        'centroCustoId': standard.centroCustoId,
        'categoriaId': standard.categoriaId,
        'valor': standard.valor,
      },
      transferencia: (transf) => {
        'runtimeType': 'transferencia',
        'numero': transf.numero,
        'origemEntrada': transf.origemEntrada.toJson(),
        'origemSaida': transf.origemSaida.toJson(),
        'valor': transf.valor,
      },
    );
  }

  String get centroCustoId =>
      map((standard) => standard.centroCustoId, transferencia: (_) => '');

  String get categoriaId =>
      map((standard) => standard.categoriaId, transferencia: (_) => '');
}

@freezed
sealed class LancamentoItemDetails with _$LancamentoItemDetails {
  const LancamentoItemDetails._();

  const factory LancamentoItemDetails({
    required int numero,
    required CentroCustoDetails centroCusto,
    required CategoriaDetails categoria,
    required double valor,
  }) = LancamentoItemDetailsStandard;

  const factory LancamentoItemDetails.transferencia({
    required int numero,
    required LancamentoOrigemDetail origemEntrada,
    required LancamentoOrigemDetail origemSaida,
    required double valor,
  }) = LancamentoItemDetailsTransferencia;

  CentroCustoDetails? get centroCusto =>
      map((standard) => standard.centroCusto, transferencia: (_) => null);

  CategoriaDetails? get categoria =>
      map((standard) => standard.categoria, transferencia: (_) => null);
}
