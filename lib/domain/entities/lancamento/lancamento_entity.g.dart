// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lancamento _$LancamentoFromJson(Map<String, dynamic> json) => _Lancamento(
  id: json['id'] as String,
  tipo: $enumDecode(_$LancamentoTipoEnumMap, json['tipo']),
  data: DateTime.parse(json['data'] as String),
  descricao: json['descricao'] as String,
  referencia: LancamentoReferencia.fromJson(
    json['referencia'] as Map<String, dynamic>,
  ),
  origem: LancamentoOrigem.fromJson(json['origem'] as Map<String, dynamic>),
  itens: (json['itens'] as List<dynamic>)
      .map((e) => LancamentoItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  conciliado: json['conciliado'] as bool,
  observacao: json['observacao'] as String?,
);

Map<String, dynamic> _$LancamentoToJson(_Lancamento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo': _$LancamentoTipoEnumMap[instance.tipo]!,
      'data': instance.data.toIso8601String(),
      'descricao': instance.descricao,
      'referencia': instance.referencia,
      'origem': instance.origem,
      'itens': instance.itens,
      'conciliado': instance.conciliado,
      'observacao': instance.observacao,
    };

const _$LancamentoTipoEnumMap = {
  LancamentoTipo.receita: 'receita',
  LancamentoTipo.despesa: 'despesa',
  LancamentoTipo.transferencia: 'transferencia',
  LancamentoTipo.investimento: 'investimento',
};
