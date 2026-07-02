import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/lancamento_details_modal.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosVisualizarMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosVisualizarMenuItem({
    super.key,
    required BuildContext context,
    required LancamentoDetails lancamento,
  }) : super(
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
         onTap: () {
           Future.delayed(Duration.zero, () {
             AppDialog.show(
               context: context,
               child: LancamentoDetailsModal(lancamento: lancamento),
             );
           });
         },
       );
}
