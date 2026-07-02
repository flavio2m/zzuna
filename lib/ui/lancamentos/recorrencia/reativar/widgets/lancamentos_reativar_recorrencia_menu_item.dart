import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosReativarRecorrenciaMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosReativarRecorrenciaMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required String lancamentoId,
  }) : super(
         value: TipoAcoes.reativarRecorrencia,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.repeat_rounded,
               size: 16,
               color: AppColors.primary,
             ),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.reativarRecorrencia.label,
               style: const TextStyle(
                 color: AppColors.primary,
                 fontSize: 13,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ],
         ),
         onTap: () {
           Future.delayed(Duration.zero, () async {
             final confirm = await AppConfirmationDialog.show(
               context: context,
               title: 'Reativar Recorrência',
               message:
                   'Deseja reativar esta recorrência? \n'
                   'Lançamentos futuros começarão a ser gerados novamente.',
             );
             if (confirm == 'confirm') {
               ref
                   .read(lancamentosReativarRecorrenciaViewModelProvider)
                   .reativarRecorrenciaCommand
                   .execute(lancamentoId);
             }
           });
         },
       );
}
