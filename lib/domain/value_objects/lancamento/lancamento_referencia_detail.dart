import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_entity.dart';
import 'package:zzuna/domain/entities/lancamento/fatura_entity.dart';

part 'lancamento_referencia_detail.freezed.dart';

@freezed
sealed class LancamentoReferenciaDetail with _$LancamentoReferenciaDetail {
  const factory LancamentoReferenciaDetail.fatura({
    required FaturaDetails fatura, //
  }) = ReferenciaFaturaLancamentoDetail;

  const factory LancamentoReferenciaDetail.extrato({
    required ExtratoDetails extrato, //
  }) = ReferenciaExtratoLancamentoDetail;
}
