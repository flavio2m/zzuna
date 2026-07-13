import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/enums/tipo_recorrencia.dart';
export 'package:zzuna/domain/enums/tipo_recorrencia.dart';

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
    required String grupoId,
    required int parcela,
    required int totalParcelas,
  }) = LancamentoGrupoReplicacao;

  const factory LancamentoGrupo.recorrencia({
    required String grupoId,
    required bool ativo,
    required int diaDoMes,
    required TipoRecorrencia tipo,
    required int sequencia,
  }) = LancamentoGrupoRecorrencia;

  factory LancamentoGrupo.fromJson(
    Map<String, dynamic> json, //
  ) => _$LancamentoGrupoFromJson(json);
}
