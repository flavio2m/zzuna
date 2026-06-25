// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conta_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conta _$ContaFromJson(Map<String, dynamic> json) => _Conta(
  id: json['id'] as String,
  descricao: json['descricao'] as String,
  bancoSigla: json['bancoSigla'] as String,
  ativo: json['ativo'] as bool,
  dataInicial: DateTime.parse(json['dataInicial'] as String),
);

Map<String, dynamic> _$ContaToJson(_Conta instance) => <String, dynamic>{
  'id': instance.id,
  'descricao': instance.descricao,
  'bancoSigla': instance.bancoSigla,
  'ativo': instance.ativo,
  'dataInicial': instance.dataInicial.toIso8601String(),
};
