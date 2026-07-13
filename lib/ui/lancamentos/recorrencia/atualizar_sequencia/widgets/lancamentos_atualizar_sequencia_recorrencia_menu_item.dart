import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/atualizar_sequencia/widgets/lancamentos_atualizar_sequencia_recorrencia_modal.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';

class LancamentosAtualizarSequenciaRecorrenciaMenuItem
    extends PopupMenuItem<TipoAcoes> {
  LancamentosAtualizarSequenciaRecorrenciaMenuItem({
    super.key,
    required BuildContext context,
    required LancamentoDetails lancamento,
  }) : super(
         value: TipoAcoes.atualizarSequenciaRecorrencia,
         onTap: () {
           // We use Future.delayed to ensure the popup menu is closed before
           // showing the modal
           Future.delayed(Duration.zero, () {
             if (context.mounted) {
               final grupo = lancamento.grupo as LancamentoGrupoRecorrencia;
               LancamentosAtualizarSequenciaRecorrenciaModal.show(
                 context: context,
                 lancamentoId: lancamento.id,
                 sequenciaAtual: grupo.sequencia,
               );
             }
           });
         },
         child: Row(
           children: [
             const Icon(Icons.format_list_numbered, size: 20),
             const SizedBox(width: 8),
             Text(
               TipoAcoes.atualizarSequenciaRecorrencia.label,
               style: const TextStyle(fontWeight: FontWeight.w600),
             ),
           ],
         ),
       );
}
