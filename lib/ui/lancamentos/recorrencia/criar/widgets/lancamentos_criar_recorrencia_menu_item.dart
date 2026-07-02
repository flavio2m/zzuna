import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosCriarRecorrenciaMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosCriarRecorrenciaMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required String lancamentoId,
  }) : super(
         value: TipoAcoes.criarRecorrencia,
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
               TipoAcoes.criarRecorrencia.label,
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
               title: 'Criar Recorrência',
               message:
                   'Deseja criar uma recorrência para este lançamento? \n'
                   'Lançamentos futuros serão gerados automaticamente '
                   'baseados na data de vencimento dos seus cartões/contas e '
                   'para as faturas já existentes.',
             );
             if (confirm == 'confirm') {
               ref
                   .read(lancamentosCriarRecorrenciaViewModelProvider)
                   .criarRecorrenciaCommand
                   .execute(lancamentoId);
             }
           });
         },
       );
}
