import 'package:freezed_annotation/freezed_annotation.dart';

part 'lancamento_origem.freezed.dart';
part 'lancamento_origem.g.dart';

@freezed
sealed class LancamentoOrigem with _$LancamentoOrigem {
  const factory LancamentoOrigem.conta({
    required String contaId, //
  }) = LancamentoOrigemConta;

  const factory LancamentoOrigem.cartao({
    required String cartaoId, //
  }) = LancamentoOrigemCartao;

  factory LancamentoOrigem.fromJson(
    Map<String, dynamic> json, //
  ) => _$LancamentoOrigemFromJson(json);
}
