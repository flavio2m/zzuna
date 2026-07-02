import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_data_grupo/widgets/lancamentos_update_data_grupo_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosUpdateDataGrupoMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosUpdateDataGrupoMenuItem({
    super.key,
    required BuildContext context,
    required LancamentoDetails lancamento,
  }) : super(
         value: TipoAcoes.alterarDataGrupo,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.date_range_outlined,
               size: 16,
               color: AppColors.slate600,
             ),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.alterarDataGrupo.label,
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
             LancamentosUpdateDataGrupoModal.show(
               context: context,
               lancamentoId: lancamento.id,
             );
           });
         },
       );
}
