import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

part 'extrato_entity.freezed.dart';
part 'extrato_entity.g.dart';

@freezed
sealed class Extrato with _$Extrato {
  const factory Extrato({
    required String id,
    required String contaId,
    required int ano,
    required Mes mes,
    required DateTime dataInicio,
    required DateTime dataFim,
    required bool fechado,
  }) = _Extrato;

  factory Extrato.fromJson(Map<String, dynamic> json) => _$ExtratoFromJson(json);
}

@freezed
sealed class ExtratoDetails with _$ExtratoDetails {
  const factory ExtratoDetails({
    required String id,
    required ContaDetails conta,
    required int ano,
    required Mes mes,
    required DateTime dataInicio,
    required DateTime dataFim,
    required bool fechado,
  }) = _ExtratoDetails;
}
