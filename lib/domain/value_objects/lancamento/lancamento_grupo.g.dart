// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento_grupo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LancamentoGrupoParcelamento _$LancamentoGrupoParcelamentoFromJson(
  Map<String, dynamic> json,
) => LancamentoGrupoParcelamento(
  grupoId: json['grupoId'] as String,
  parcela: (json['parcela'] as num).toInt(),
  totalParcelas: (json['totalParcelas'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$LancamentoGrupoParcelamentoToJson(
  LancamentoGrupoParcelamento instance,
) => <String, dynamic>{
  'grupoId': instance.grupoId,
  'parcela': instance.parcela,
  'totalParcelas': instance.totalParcelas,
  'runtimeType': instance.$type,
};

LancamentoGrupoTransferencia _$LancamentoGrupoTransferenciaFromJson(
  Map<String, dynamic> json,
) => LancamentoGrupoTransferencia(
  grupoId: json['grupoId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$LancamentoGrupoTransferenciaToJson(
  LancamentoGrupoTransferencia instance,
) => <String, dynamic>{
  'grupoId': instance.grupoId,
  'runtimeType': instance.$type,
};

LancamentoGrupoReplicacao _$LancamentoGrupoReplicacaoFromJson(
  Map<String, dynamic> json,
) => LancamentoGrupoReplicacao(
  grupoId: json['grupoId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$LancamentoGrupoReplicacaoToJson(
  LancamentoGrupoReplicacao instance,
) => <String, dynamic>{
  'grupoId': instance.grupoId,
  'runtimeType': instance.$type,
};
