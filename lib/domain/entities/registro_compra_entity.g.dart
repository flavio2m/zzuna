// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_compra_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegistroCompra _$RegistroCompraFromJson(Map<String, dynamic> json) =>
    _RegistroCompra(
      data: DateTime.parse(json['data'] as String),
      quantidade: (json['quantidade'] as num).toDouble(),
      precoReal: (json['precoReal'] as num?)?.toDouble() ?? 0.0,
      supermercadoId: json['supermercadoId'] as String?,
    );

Map<String, dynamic> _$RegistroCompraToJson(_RegistroCompra instance) =>
    <String, dynamic>{
      'data': instance.data.toIso8601String(),
      'quantidade': instance.quantidade,
      'precoReal': instance.precoReal,
      'supermercadoId': instance.supermercadoId,
    };
