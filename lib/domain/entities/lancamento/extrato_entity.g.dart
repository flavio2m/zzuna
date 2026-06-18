// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extrato_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Extrato _$ExtratoFromJson(Map<String, dynamic> json) => _Extrato(
  id: json['id'] as String,
  contaId: json['contaId'] as String,
  ano: (json['ano'] as num).toInt(),
  mes: $enumDecode(_$MesEnumMap, json['mes']),
  dataInicio: DateTime.parse(json['dataInicio'] as String),
  dataFim: DateTime.parse(json['dataFim'] as String),
  fechado: json['fechado'] as bool,
);

Map<String, dynamic> _$ExtratoToJson(_Extrato instance) => <String, dynamic>{
  'id': instance.id,
  'contaId': instance.contaId,
  'ano': instance.ano,
  'mes': _$MesEnumMap[instance.mes]!,
  'dataInicio': instance.dataInicio.toIso8601String(),
  'dataFim': instance.dataFim.toIso8601String(),
  'fechado': instance.fechado,
};

const _$MesEnumMap = {
  Mes.janeiro: 'janeiro',
  Mes.fevereiro: 'fevereiro',
  Mes.marco: 'marco',
  Mes.abril: 'abril',
  Mes.maio: 'maio',
  Mes.junho: 'junho',
  Mes.julho: 'julho',
  Mes.agosto: 'agosto',
  Mes.setembro: 'setembro',
  Mes.outubro: 'outubro',
  Mes.novembro: 'novembro',
  Mes.dezembro: 'dezembro',
};
