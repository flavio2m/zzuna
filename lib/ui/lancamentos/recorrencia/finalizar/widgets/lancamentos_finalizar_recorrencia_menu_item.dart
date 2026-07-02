import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosFinalizarRecorrenciaMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosFinalizarRecorrenciaMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required String lancamentoId,
  }) : super(
         value: TipoAcoes.finalizarRecorrencia,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.repeat_one_outlined,
               size: 16,
               color: AppColors.danger,
             ),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.finalizarRecorrencia.label,
               style: const TextStyle(
                 color: AppColors.danger,
                 fontSize: 13,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ],
         ),
         onTap: () {
           Future.delayed(Duration.zero, () async {
             if (!context.mounted) return;
             final confirm = await AppConfirmationDialog.show(
               context: context,
               title: 'Finalizar Recorrência',
               message:
                   'Tem certeza que deseja finalizar esta recorrência? \n'
                   'Todos os lançamentos futuros vinculados a ela serão '
                   'excluídos e recalculados.',
               actions: const {'confirm': 'Finalizar', 'cancel': 'Cancelar'},
             );
             if (confirm == 'confirm') {
               ref
                   .read(lancamentosFinalizarRecorrenciaViewModelProvider)
                   .finalizarRecorrenciaCommand
                   .execute(lancamentoId);
             }
           });
         },
       );
}
