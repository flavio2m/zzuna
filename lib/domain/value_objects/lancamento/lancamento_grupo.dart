import 'package:freezed_annotation/freezed_annotation.dart';

part 'lancamento_grupo.freezed.dart';
part 'lancamento_grupo.g.dart';

@freezed
sealed class LancamentoGrupo with _$LancamentoGrupo {
  const factory LancamentoGrupo.parcelamento({
    required String grupoId,
    required int parcela,
    required int totalParcelas,
  }) = LancamentoGrupoParcelamento;

  const factory LancamentoGrupo.transferencia({
    required String grupoId, //
  }) = LancamentoGrupoTransferencia;

  const factory LancamentoGrupo.replicacao({
    required String grupoId, //
  }) = LancamentoGrupoReplicacao;

  factory LancamentoGrupo.fromJson(
    Map<String, dynamic> json, //
  ) => _$LancamentoGrupoFromJson(json);
}
