// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_compras_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListaCompras _$ListaComprasFromJson(Map<String, dynamic> json) =>
    _ListaCompras(
      id: json['id'] as String,
      ano: (json['ano'] as num).toInt(),
      mes: $enumDecode(_$MesEnumMap, json['mes']),
      periodo: (json['periodo'] as num).toInt(),
      itens:
          (json['itens'] as List<dynamic>?)
              ?.map((e) => ItemCompra.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ListaComprasToJson(_ListaCompras instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ano': instance.ano,
      'mes': _$MesEnumMap[instance.mes]!,
      'periodo': instance.periodo,
      'itens': instance.itens.map((e) => e.toJson()).toList(),
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
