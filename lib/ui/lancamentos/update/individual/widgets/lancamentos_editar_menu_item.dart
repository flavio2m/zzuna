import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_update_modal.dart';
import 'package:zzuna/ui/lancamentos/update/individual/widgets/lancamento_update_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosEditarMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosEditarMenuItem({
    super.key,
    required BuildContext context,
    required LancamentoDetails lancamento,
  }) : super(
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
         onTap: () {
           Future.delayed(Duration.zero, () {
             if (!context.mounted) return;
             if (lancamento.tipo == LancamentoTipo.transferencia &&
                 lancamento.grupo != null) {
               TransferenciaUpdateModal.show(
                 context,
                 grupoId: lancamento.grupo!.grupoId,
               );
             } else {
               AppDialog.show(
                 context: context,
                 child: LancamentoUpdateModal(lancamento: lancamento),
               );
             }
           });
         },
       );
}
