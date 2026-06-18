// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fatura_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Fatura _$FaturaFromJson(Map<String, dynamic> json) => _Fatura(
  id: json['id'] as String,
  cartaoId: json['cartaoId'] as String,
  ano: (json['ano'] as num).toInt(),
  mes: $enumDecode(_$MesEnumMap, json['mes']),
  dataInicio: DateTime.parse(json['dataInicio'] as String),
  dataFim: DateTime.parse(json['dataFim'] as String),
  fechada: json['fechada'] as bool,
);

Map<String, dynamic> _$FaturaToJson(_Fatura instance) => <String, dynamic>{
  'id': instance.id,
  'cartaoId': instance.cartaoId,
  'ano': instance.ano,
  'mes': _$MesEnumMap[instance.mes]!,
  'dataInicio': instance.dataInicio.toIso8601String(),
  'dataFim': instance.dataFim.toIso8601String(),
  'fechada': instance.fechada,
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
