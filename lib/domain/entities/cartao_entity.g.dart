// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartao_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cartao _$CartaoFromJson(Map<String, dynamic> json) => _Cartao(
  id: json['id'] as String,
  descricao: json['descricao'] as String,
  limite: (json['limite'] as num).toDouble(),
  bancoSigla: json['bancoSigla'] as String,
  ativo: json['ativo'] as bool,
  diaFechamento: (json['diaFechamento'] as num).toInt(),
  dataInicial: DateTime.parse(json['dataInicial'] as String),
);

Map<String, dynamic> _$CartaoToJson(_Cartao instance) => <String, dynamic>{
  'id': instance.id,
  'descricao': instance.descricao,
  'limite': instance.limite,
  'bancoSigla': instance.bancoSigla,
  'ativo': instance.ativo,
  'diaFechamento': instance.diaFechamento,
  'dataInicial': instance.dataInicial.toIso8601String(),
};
