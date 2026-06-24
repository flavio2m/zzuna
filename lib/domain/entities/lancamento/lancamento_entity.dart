import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
export 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';

part 'lancamento_entity.freezed.dart';
part 'lancamento_entity.g.dart';

@freezed
sealed class Lancamento with _$Lancamento {
  const factory Lancamento({
    required String id,
    required LancamentoTipo tipo,
    required DateTime data,
    required String descricao,
    required String extratoFaturaId,
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
    required ExtratoFaturaDetails extratoFatura,
    required LancamentoOrigemDetail origem,
    required List<LancamentoItemDetails> itens,
    required bool conciliado,
    String? observacao,
  }) = _LancamentoDetails;

  double get valor => itens.fold(0, (total, item) => total + item.valor);
}
