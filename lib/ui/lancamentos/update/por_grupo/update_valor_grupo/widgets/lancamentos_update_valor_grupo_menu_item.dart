import 'package:flutter/material.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_valor_grupo/widgets/lancamentos_update_valor_grupo_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosUpdateValorGrupoMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosUpdateValorGrupoMenuItem({
    super.key,
    required BuildContext context,
    required LancamentoDetails lancamento,
  }) : super(
         value: TipoAcoes.alterarValorGrupo,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.list_alt_outlined,
               size: 16,
               color: AppColors.slate600,
             ),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.alterarValorGrupo.label,
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
             LancamentosUpdateValorGrupoModal.show(
               context: context,
               lancamentoId: lancamento.id,
               initialItens: LancamentoDto.fromDetails(lancamento).itens,
             );
           });
         },
       );
}
