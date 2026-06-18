import 'package:freezed_annotation/freezed_annotation.dart';

part 'lancamento_referencia.freezed.dart';
part 'lancamento_referencia.g.dart';

@freezed
sealed class LancamentoReferencia with _$LancamentoReferencia {
  const factory LancamentoReferencia.fatura({
    required String faturaId, //
  }) = ReferenciaFaturaLancamento;

  const factory LancamentoReferencia.extrato({
    required String extratoId, //
  }) = ReferenciaExtratoLancamento;

  factory LancamentoReferencia.fromJson(
    Map<String, dynamic> json, //
  ) => _$LancamentoReferenciaFromJson(json);
}
