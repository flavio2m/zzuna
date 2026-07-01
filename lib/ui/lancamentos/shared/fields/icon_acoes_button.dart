import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

enum TipoAcoes {
  visualizar,
  editar,
  alterarMetadata,
  alterarDataGrupo,
  alterarValorGrupo;

  String get label => switch (this) {
    TipoAcoes.visualizar => 'Visualizar',
    TipoAcoes.editar => 'Editar',
    TipoAcoes.alterarMetadata => 'Alterar Descrição em Lote',
    TipoAcoes.alterarDataGrupo => 'Alterar Data em Lote',
    TipoAcoes.alterarValorGrupo => 'Alterar Valor em Lote',
  };
}

class IconAcoesButton extends StatelessWidget {
  final bool conciliado;
  final LancamentoGrupo? grupo;
  final LancamentoTipo? tipo;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onUpdateMetadata;
  final VoidCallback? onUpdateDataGrupo;
  final VoidCallback? onUpdateValorGrupo;

  const IconAcoesButton({
    super.key,
    required this.conciliado,
    this.grupo,
    this.tipo,
    this.onView,
    this.onEdit,
    this.onUpdateMetadata,
    this.onUpdateDataGrupo,
    this.onUpdateValorGrupo,
  });

  @override
  Widget build(BuildContext context) {
    final showUpdateMetadata =
        !conciliado &&
        grupo?.grupoId != null &&
        tipo != LancamentoTipo.transferencia;

    return PopupMenuButton<TipoAcoes>(
      tooltip: 'Ações',
      icon: const Icon(
        Icons.more_vert_rounded,
        color: AppColors.slate600,
        size: 20,
      ),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 3,
      onSelected: (value) {
        switch (value) {
          case TipoAcoes.visualizar:
            onView?.call();
          case TipoAcoes.editar:
            onEdit?.call();
          case TipoAcoes.alterarMetadata:
            onUpdateMetadata?.call();
          case TipoAcoes.alterarDataGrupo:
            onUpdateDataGrupo?.call();
          case TipoAcoes.alterarValorGrupo:
            onUpdateValorGrupo?.call();
        }
      },
      itemBuilder: (context) => [
        if (conciliado) ...[
          PopupMenuItem<TipoAcoes>(
            value: TipoAcoes.visualizar,
            height: 36,
            child: Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.slate600,
                ),
                const SizedBox(width: 8),
                Text(
                  TipoAcoes.visualizar.label,
                  style: const TextStyle(
                    color: AppColors.slate700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          PopupMenuItem<TipoAcoes>(
            value: TipoAcoes.editar,
            height: 36,
            child: Row(
              children: [
                const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.slate600,
                ),
                const SizedBox(width: 8),
                Text(
                  TipoAcoes.editar.label,
                  style: const TextStyle(
                    color: AppColors.slate700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<TipoAcoes>(
            value: TipoAcoes.visualizar,
            height: 36,
            child: Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.slate600,
                ),
                const SizedBox(width: 8),
                Text(
                  TipoAcoes.visualizar.label,
                  style: const TextStyle(
                    color: AppColors.slate700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (showUpdateMetadata) ...[
            PopupMenuItem<TipoAcoes>(
              value: TipoAcoes.alterarMetadata,
              height: 36,
              child: Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: AppColors.slate600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    TipoAcoes.alterarMetadata.label,
                    style: const TextStyle(
                      color: AppColors.slate700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<TipoAcoes>(
              value: TipoAcoes.alterarDataGrupo,
              height: 36,
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range_outlined,
                    size: 16,
                    color: AppColors.slate600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    TipoAcoes.alterarDataGrupo.label,
                    style: const TextStyle(
                      color: AppColors.slate700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<TipoAcoes>(
              value: TipoAcoes.alterarValorGrupo,
              height: 36,
              child: Row(
                children: [
                  const Icon(
                    Icons.list_alt_outlined,
                    size: 16,
                    color: AppColors.slate600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    TipoAcoes.alterarValorGrupo.label,
                    style: const TextStyle(
                      color: AppColors.slate700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}
