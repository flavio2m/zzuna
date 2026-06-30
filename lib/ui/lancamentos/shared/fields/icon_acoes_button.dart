import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class IconAcoesButton extends StatelessWidget {
  final bool conciliado;
  final LancamentoGrupo? grupo;
  final LancamentoTipo? tipo;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onUpdateMetadata;

  const IconAcoesButton({
    super.key,
    required this.conciliado,
    this.grupo,
    this.tipo,
    this.onView,
    this.onEdit,
    this.onUpdateMetadata,
  });

  @override
  Widget build(BuildContext context) {
    final showUpdateMetadata = !conciliado && grupo?.grupoId != null && tipo != LancamentoTipo.transferencia;

    return PopupMenuButton<String>(
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
        if (value == 'visualizar') {
          onView?.call();
        } else if (value == 'editar') {
          onEdit?.call();
        } else if (value == 'alterar_grupo') {
          onUpdateMetadata?.call();
        }
      },
      itemBuilder: (context) => [
        if (conciliado) ...[
          const PopupMenuItem<String>(
            value: 'visualizar',
            height: 36,
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.slate600,
                ),
                SizedBox(width: 8),
                Text(
                  'Visualizar',
                  style: TextStyle(
                    color: AppColors.slate700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          const PopupMenuItem<String>(
            value: 'editar',
            height: 36,
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 16, color: AppColors.slate600),
                SizedBox(width: 8),
                Text(
                  'Editar',
                  style: TextStyle(
                    color: AppColors.slate700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'visualizar',
            height: 36,
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.slate600,
                ),
                SizedBox(width: 8),
                Text(
                  'Visualizar',
                  style: TextStyle(
                    color: AppColors.slate700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (showUpdateMetadata)
            const PopupMenuItem<String>(
              value: 'alterar_grupo',
              height: 36,
              child: Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: AppColors.slate600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Alterar Descrição/Obs',
                    style: TextStyle(
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
    );
  }
}
