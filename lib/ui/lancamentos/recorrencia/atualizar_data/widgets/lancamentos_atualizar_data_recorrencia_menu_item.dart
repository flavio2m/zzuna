import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosAtualizarDataRecorrenciaMenuItem
    extends PopupMenuItem<TipoAcoes> {
  LancamentosAtualizarDataRecorrenciaMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required String lancamentoId,
    required int diaDoMesRecorrencia,
    required int diaDoLancamento,
  }) : super(
         value: TipoAcoes.atualizarDataRecorrencia,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.event_repeat_outlined,
               size: 16,
               color: AppColors.primary,
             ),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.atualizarDataRecorrencia.label,
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
               title: 'Atualizar Recorrência',
               message:
                   'Deseja atualizar a data da recorrência do dia '
                   '$diaDoMesRecorrencia para o dia $diaDoLancamento? \n'
                   'Os próximos lançamentos futuros serão gerados com essa '
                   'nova data.',
             );
             if (confirm == 'confirm') {
               ref
                   .read(lancamentosAtualizarDataRecorrenciaViewModelProvider)
                   .atualizarDataRecorrenciaCommand
                   .execute(lancamentoId);
             }
           });
         },
       );
}
