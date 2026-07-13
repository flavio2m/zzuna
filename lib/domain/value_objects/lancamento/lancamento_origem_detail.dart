import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

part 'lancamento_origem_detail.freezed.dart';

@freezed
sealed class LancamentoOrigemDetail with _$LancamentoOrigemDetail {
  const LancamentoOrigemDetail._();

  const factory LancamentoOrigemDetail.conta({
    required ContaDetails conta, //
  }) = LancamentoOrigemContaDetail;

  const factory LancamentoOrigemDetail.cartao({
    required CartaoDetails cartao, //
  }) = LancamentoOrigemCartaoDetail;

  LancamentoOrigem get origem => map(
    conta: (c) => LancamentoOrigem.conta(
      contaId: c.conta.id,
    ),
    cartao: (c) => LancamentoOrigem.cartao(
      cartaoId: c.cartao.id,
    ),
  );
}
