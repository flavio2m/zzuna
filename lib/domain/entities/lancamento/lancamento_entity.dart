import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_referencia.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_referencia_detail.dart';

part 'lancamento_entity.freezed.dart';
part 'lancamento_entity.g.dart';

enum LancamentoTipo { receita, despesa, transferencia, investimento }

@freezed
sealed class Lancamento with _$Lancamento {
  const factory Lancamento({
    required String id,
    required LancamentoTipo tipo,
    required DateTime data,
    required String descricao,
    required LancamentoReferencia referencia,
    required LancamentoOrigem origem,
    required List<LancamentoItem> itens,
    required bool conciliado,
    String? observacao,
  }) = _Lancamento;

  factory Lancamento.fromJson(
    Map<String, dynamic> json, //
  ) => _$LancamentoFromJson(json);
}

@freezed
sealed class LancamentoDetails with _$LancamentoDetails {
  const LancamentoDetails._();

  const factory LancamentoDetails({
    required String id,
    required LancamentoTipo tipo,
    required DateTime data,
    required String descricao,
    required LancamentoReferenciaDetail referencia,
    required LancamentoOrigem origem,
    required List<LancamentoItemDetails> itens,
    required bool conciliado,
    String? observacao,
  }) = _LancamentoDetails;

  double get valor => itens.fold(0, (total, item) => total + item.valor);
}
