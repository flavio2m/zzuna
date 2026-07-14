import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/ui/conta/delete/widgets/conta_delete_button.dart';
import 'package:zzuna/ui/conta/update/widgets/conta_update_modal.dart';
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_editar_button.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class ContaListItem extends ConsumerWidget {
  final ContaDetails contaDetails;

  const ContaListItem({super.key, required this.contaDetails});

  void _editarConta(BuildContext context) {
    final dto = LoadedContaDto(
      id: contaDetails.id,
      descricao: contaDetails.descricao,
      bancoSigla: contaDetails.banco.sigla,
      ativo: contaDetails.ativo,
      dataInicial: contaDetails.dataInicial,
    );

    ContaUpdateModal.show(context, dto);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),

          Icon(
            contaDetails.ativo ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: contaDetails.ativo ? AppColors.primary : AppColors.slate400,
          ),

          const AppSpacing(size: AppSpacingSize.xs, axis: Axis.horizontal),

          Expanded(
            flex: 4,
            child: Row(
              children: [
                AppText(
                  contaDetails.descricao,
                  overflow: TextOverflow.ellipsis, //
                ),
                AppText(' - '),
                AppTag(contaDetails.banco.descricao),
              ],
            ),
          ),

          IconEditarButton(onPressed: () => _editarConta(context)),

          ContaDeleteButton(
            contaId: contaDetails.id,
            descricao: contaDetails.descricao, //
          ),

          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
        ],
      ),
    );
  }
}
