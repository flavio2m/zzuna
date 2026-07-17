// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extrato_fatura_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtratoFatura _$ExtratoFaturaFromJson(Map<String, dynamic> json) =>
    _ExtratoFatura(
      id: json['id'] as String,
      origem: LancamentoOrigem.fromJson(json['origem'] as Map<String, dynamic>),
      ano: (json['ano'] as num).toInt(),
      mes: $enumDecode(_$MesEnumMap, json['mes']),
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: DateTime.parse(json['dataFim'] as String),
      saldoInicial: (json['saldoInicial'] as num).toDouble(),
      saldoFinal: (json['saldoFinal'] as num).toDouble(),
      fechado: json['fechado'] as bool,
      periodo: (json['periodo'] as num).toInt(),
      origemKey: json['origemKey'] as String,
    );

Map<String, dynamic> _$ExtratoFaturaToJson(_ExtratoFatura instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origem': instance.origem.toJson(),
      'ano': instance.ano,
      'mes': _$MesEnumMap[instance.mes]!,
      'dataInicio': instance.dataInicio.toIso8601String(),
      'dataFim': instance.dataFim.toIso8601String(),
      'saldoInicial': instance.saldoInicial,
      'saldoFinal': instance.saldoFinal,
      'fechado': instance.fechado,
      'periodo': instance.periodo,
      'origemKey': instance.origemKey,
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
