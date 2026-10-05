// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_compra_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupermercadoItem _$SupermercadoItemFromJson(Map<String, dynamic> json) =>
    _SupermercadoItem(
      nome: json['nome'] as String,
      ultimoUtilizado: json['ultimoUtilizado'] as bool? ?? false,
    );

Map<String, dynamic> _$SupermercadoItemToJson(_SupermercadoItem instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'ultimoUtilizado': instance.ultimoUtilizado,
    };

_ItemCompra _$ItemCompraFromJson(Map<String, dynamic> json) => _ItemCompra(
  id: json['id'] as String,
  produto: json['produto'] as String,
  quantidadePlanejada: (json['quantidadePlanejada'] as num?)?.toDouble() ?? 1.0,
  historicoCompras:
      (json['historicoCompras'] as List<dynamic>?)
          ?.map((e) => RegistroCompra.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  precoEstimado: (json['precoEstimado'] as num?)?.toDouble() ?? 0.0,
  supermercados:
      (json['supermercados'] as List<dynamic>?)
          ?.map((e) => SupermercadoItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  situacao:
      $enumDecodeNullable(_$ItemCompraSituacaoEnumMap, json['situacao']) ??
      ItemCompraSituacao.pendente,
  observacao: json['observacao'] as String? ?? '',
  quantidadeCompradaLegada:
      (json['quantidadeComprada'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ItemCompraToJson(
  _ItemCompra instance,
) => <String, dynamic>{
  'id': instance.id,
  'produto': instance.produto,
  'quantidadePlanejada': instance.quantidadePlanejada,
  'historicoCompras': instance.historicoCompras.map((e) => e.toJson()).toList(),
  'precoEstimado': instance.precoEstimado,
  'supermercados': instance.supermercados.map((e) => e.toJson()).toList(),
  'situacao': _$ItemCompraSituacaoEnumMap[instance.situacao]!,
  'observacao': instance.observacao,
  'quantidadeComprada': instance.quantidadeCompradaLegada,
};

const _$ItemCompraSituacaoEnumMap = {
  ItemCompraSituacao.pendente: 'pendente',
  ItemCompraSituacao.comprado: 'comprado',
  ItemCompraSituacao.cancelado: 'cancelado',
};
