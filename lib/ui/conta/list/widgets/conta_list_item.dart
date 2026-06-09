import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/ui/conta/delete/widgets/conta_delete_button.dart';
import 'package:zzuna/ui/conta/update/widgets/conta_update_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_editar_button.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class ContaListItem extends ConsumerWidget {
  final ContaDetails contaDetails;

  const ContaListItem({super.key, required this.contaDetails});

  Widget get _bancoWidget {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.slate100,
          borderRadius: BorderRadius.circular(6), //
        ),
        child: AppText(contaDetails.banco.descricao),
      ),
    );
  }

  void _editarConta(BuildContext context) {
    final dto = LoadedContaDto(
      id: contaDetails.id,
      descricao: contaDetails.descricao,
      bancoSigla: contaDetails.banco.sigla,
      ativo: contaDetails.ativo,
    );

    ContaUpdateModal.show(context, dto);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          const SizedBox(width: 16),

          Icon(
            contaDetails.ativo ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: contaDetails.ativo ? AppColors.primary : AppColors.slate400,
          ),

          const SizedBox(width: 4),

          Expanded(
            flex: 4,
            child: Row(
              children: [
                AppText(
                  contaDetails.descricao,
                  overflow: TextOverflow.ellipsis, //
                ),
                AppText(' - '),
                _bancoWidget,
              ],
            ),
          ),

          IconEditarButton(onPressed: () => _editarConta(context)),

          ContaDeleteButton(
            contaId: contaDetails.id,
            descricao: contaDetails.descricao, //
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
