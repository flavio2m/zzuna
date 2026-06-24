// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LancamentoItem _$LancamentoItemFromJson(Map<String, dynamic> json) =>
    _LancamentoItem(
      numero: (json['numero'] as num).toInt(),
      centroCustoId: json['centroCustoId'] as String,
      categoriaId: json['categoriaId'] as String,
      valor: (json['valor'] as num).toDouble(),
    );

Map<String, dynamic> _$LancamentoItemToJson(_LancamentoItem instance) =>
    <String, dynamic>{
      'numero': instance.numero,
      'centroCustoId': instance.centroCustoId,
      'categoriaId': instance.categoriaId,
      'valor': instance.valor,
    };
