import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

part 'extrato_fatura_entity.freezed.dart';
part 'extrato_fatura_entity.g.dart';

@freezed
sealed class ExtratoFatura with _$ExtratoFatura {
  const factory ExtratoFatura({
    required String id,
    required LancamentoOrigem origem,
    required int ano,
    required Mes mes,
    required DateTime dataInicio,
    required DateTime dataFim,
    required double saldoInicial,
    required double saldoFinal,
    required bool fechado,
    required int periodo,
    required String origemKey,
  }) = _ExtratoFatura;

  factory ExtratoFatura.fromJson(Map<String, dynamic> json) => _$ExtratoFaturaFromJson(json);
}

@freezed
sealed class ExtratoFaturaDetails with _$ExtratoFaturaDetails {
  const factory ExtratoFaturaDetails({
    required String id,
    required LancamentoOrigemDetail origem,
    required int ano,
    required Mes mes,
    required DateTime dataInicio,
    required DateTime dataFim,
    required double saldoInicial,
    required double saldoFinal,
    required bool fechado,
  }) = _ExtratoFaturaDetails;
}
