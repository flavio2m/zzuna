// lib/ui/centro_custo/list/widgets/centro_custo_list_item.dart
import 'package:flutter/material.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/ui/centro_custo/delete/widgets/centro_custo_delete_button.dart';
import 'package:zzuna/ui/centro_custo/update/widgets/centro_custo_update_modal.dart';
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_editar_button.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

/// Item da lista de Centros de Custo.
///
/// Estrutura idêntica ao `CartaoListItem`, usando DTO, validator e
/// botões específicos de Centro de Custo.
class CentroCustoListItem extends StatelessWidget {
  final CentroCustoDetails centroCusto;

  const CentroCustoListItem({super.key, required this.centroCusto});

  void _editarCentroCusto(BuildContext context) {
    final dto = CentroCustoDto(
      id: centroCusto.id,
      descricao: centroCusto.descricao,
      ativo: centroCusto.ativo,
      padrao: centroCusto.padrao,
    );
    CentroCustoUpdateModal.show(context, dto);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
          Icon(
            centroCusto.ativo
                ? Icons.account_balance
                : Icons.account_balance_outlined,
            size: 18,
            color: centroCusto.ativo ? AppColors.primary : AppColors.slate400,
          ),
          const AppSpacing(size: AppSpacingSize.xs, axis: Axis.horizontal),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: AppText(
                    centroCusto.descricao,
                    overflow: TextOverflow.ellipsis, //
                  ),
                ),
                const AppSpacing(
                  size: AppSpacingSize.xs,
                  axis: Axis.horizontal,
                ),
                AppTag('Ativo: ${centroCusto.ativo ? "Sim" : "Não"}'),
                if (centroCusto.padrao) ...[
                  const AppSpacing(
                    size: AppSpacingSize.xs,
                    axis: Axis.horizontal,
                  ),
                  const AppTag('Padrão'),
                ],
              ],
            ),
          ),
          IconEditarButton(onPressed: () => _editarCentroCusto(context)),
          CentroCustoDeleteButton(
            centroCustoId: centroCusto.id,
            centroCustoDescricao: centroCusto.descricao, //
          ),
          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
        ],
      ),
    );
  }
}
