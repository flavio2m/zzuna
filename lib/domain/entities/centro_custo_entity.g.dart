// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'centro_custo_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CentroCusto _$CentroCustoFromJson(Map<String, dynamic> json) => _CentroCusto(
  id: json['id'] as String,
  descricao: json['descricao'] as String,
  ativo: json['ativo'] as bool,
);

Map<String, dynamic> _$CentroCustoToJson(_CentroCusto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'ativo': instance.ativo,
    };

_CentroCustoDetails _$CentroCustoDetailsFromJson(Map<String, dynamic> json) =>
    _CentroCustoDetails(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
      ativo: json['ativo'] as bool,
    );

Map<String, dynamic> _$CentroCustoDetailsToJson(_CentroCustoDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'ativo': instance.ativo,
    };
