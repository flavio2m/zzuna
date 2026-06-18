// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento_referencia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenciaFaturaLancamento _$ReferenciaFaturaLancamentoFromJson(
  Map<String, dynamic> json,
) => ReferenciaFaturaLancamento(
  faturaId: json['faturaId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ReferenciaFaturaLancamentoToJson(
  ReferenciaFaturaLancamento instance,
) => <String, dynamic>{
  'faturaId': instance.faturaId,
  'runtimeType': instance.$type,
};

ReferenciaExtratoLancamento _$ReferenciaExtratoLancamentoFromJson(
  Map<String, dynamic> json,
) => ReferenciaExtratoLancamento(
  extratoId: json['extratoId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ReferenciaExtratoLancamentoToJson(
  ReferenciaExtratoLancamento instance,
) => <String, dynamic>{
  'extratoId': instance.extratoId,
  'runtimeType': instance.$type,
};
