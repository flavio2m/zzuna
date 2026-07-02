import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_metadata/widgets/lancamentos_update_metadata_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosUpdateMetadataMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosUpdateMetadataMenuItem({
    super.key,
    required BuildContext context,
    required LancamentoDetails lancamento,
  }) : super(
         value: TipoAcoes.alterarMetadata,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.description_outlined,
               size: 16,
               color: AppColors.slate600,
             ),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.alterarMetadata.label,
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
             LancamentosUpdateMetadataModal.show(
               context: context,
               lancamentoId: lancamento.id,
               currentDescricao: lancamento.descricao,
               currentObservacao: lancamento.observacao,
             );
           });
         },
       );
}
