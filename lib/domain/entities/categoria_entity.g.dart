// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Categoria _$CategoriaFromJson(Map<String, dynamic> json) => _Categoria(
  id: json['id'] as String,
  descricao: json['descricao'] as String,
  categoriaPaiId: json['categoriaPaiId'] as String?,
  ativo: json['ativo'] as bool,
);

Map<String, dynamic> _$CategoriaToJson(_Categoria instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'categoriaPaiId': instance.categoriaPaiId,
      'ativo': instance.ativo,
    };
