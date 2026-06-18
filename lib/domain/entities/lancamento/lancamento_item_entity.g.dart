// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LancamentoItem _$LancamentoItemFromJson(Map<String, dynamic> json) =>
    _LancamentoItem(
      id: json['id'] as String,
      centroCustoId: json['centroCustoId'] as String,
      categoriaId: json['categoriaId'] as String,
      valor: (json['valor'] as num).toDouble(),
    );

Map<String, dynamic> _$LancamentoItemToJson(_LancamentoItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'centroCustoId': instance.centroCustoId,
      'categoriaId': instance.categoriaId,
      'valor': instance.valor,
    };
