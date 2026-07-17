import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

import 'package:zzuna/ui/lancamentos/list/widgets/lancamentos_visualizar_menu_item.dart';
import 'package:zzuna/ui/lancamentos/update/individual/widgets/lancamentos_editar_menu_item.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_metadata/widgets/lancamentos_update_metadata_menu_item.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_data_grupo/widgets/lancamentos_update_data_grupo_menu_item.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_valor_grupo/widgets/lancamentos_update_valor_grupo_menu_item.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_origem_grupo/widgets/lancamentos_update_origem_grupo_menu_item.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/criar/widgets/lancamentos_criar_recorrencia_menu_item.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/finalizar/widgets/lancamentos_finalizar_recorrencia_menu_item.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/reativar/widgets/lancamentos_reativar_recorrencia_menu_item.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/atualizar_data/widgets/lancamentos_atualizar_data_recorrencia_menu_item.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/atualizar_sequencia/widgets/lancamentos_atualizar_sequencia_recorrencia_menu_item.dart';
import 'package:zzuna/ui/lancamentos/delete/widgets/lancamentos_excluir_menu_item.dart';

enum TipoAcoes {
  visualizar,
  editar,
  alterarMetadata,
  alterarDataGrupo,
  alterarValorGrupo,
  alterarOrigemGrupo,
  criarRecorrencia,
  atualizarDataRecorrencia,
  atualizarSequenciaRecorrencia,
  finalizarRecorrencia,
  reativarRecorrencia,
  excluir;

  String get label => switch (this) {
    TipoAcoes.visualizar => 'Visualizar',
    TipoAcoes.editar => 'Editar',
    TipoAcoes.alterarMetadata => 'Alterar Descrição em Lote',
    TipoAcoes.alterarDataGrupo => 'Alterar Data em Lote',
    TipoAcoes.alterarValorGrupo => 'Alterar Valor em Lote',
    TipoAcoes.alterarOrigemGrupo => 'Alterar Conta/Cartão em Lote',
    TipoAcoes.criarRecorrencia => 'Criar Recorrência',
    TipoAcoes.atualizarDataRecorrencia => 'Atualizar Data da Recorrência',
    TipoAcoes.atualizarSequenciaRecorrencia =>
      'Atualizar Sequência da Recorrência',
    TipoAcoes.finalizarRecorrencia => 'Finalizar Recorrência',
    TipoAcoes.reativarRecorrencia => 'Reativar Recorrência',
    TipoAcoes.excluir => 'Excluir',
  };
}

class IconAcoesButton extends ConsumerWidget {
  final LancamentoDetails lancamento;

  const IconAcoesButton({super.key, required this.lancamento});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conciliado = lancamento.conciliado;
    final grupo = lancamento.grupo;
    final tipo = lancamento.tipo;
    final dataDay = lancamento.data.day;
    final showUpdateMetadata =
        !conciliado &&
        grupo?.grupoId != null &&
        tipo != LancamentoTipo.transferencia;

    // Recorrência: visibilidade das ações
    final isNotTransferencia = tipo != LancamentoTipo.transferencia;
    final recorrenciaGrupo = grupo is LancamentoGrupoRecorrencia ? grupo : null;
    final showCriarRecorrencia =
        !conciliado && isNotTransferencia && recorrenciaGrupo == null;
    final showFinalizarRecorrencia =
        !conciliado && recorrenciaGrupo != null && recorrenciaGrupo.ativo;
    final showReativarRecorrencia =
        !conciliado && recorrenciaGrupo != null && !recorrenciaGrupo.ativo;
    final showAtualizarDataRecorrencia =
        !conciliado &&
        recorrenciaGrupo != null &&
        recorrenciaGrupo.ativo &&
        dataDay != recorrenciaGrupo.diaDoMes;
    final showAtualizarSequenciaRecorrencia =
        !conciliado && recorrenciaGrupo != null && recorrenciaGrupo.ativo;
    final showExcluir = !conciliado;

    return PopupMenuButton<TipoAcoes>(
      tooltip: 'Ações',
      icon: const Icon(
        Icons.more_vert_rounded,
        color: AppColors.slate600,
        size: 20,
      ),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 3,
      onSelected: (_) {}, // The items themselves handle the taps now.
      itemBuilder: (context) => [
        if (conciliado) ...[
          LancamentosVisualizarMenuItem(
            context: context,
            lancamento: lancamento,
          ),
        ] else ...[
          LancamentosEditarMenuItem(context: context, lancamento: lancamento),
          LancamentosVisualizarMenuItem(
            context: context,
            lancamento: lancamento,
          ),
          if (showUpdateMetadata) ...[
            LancamentosUpdateMetadataMenuItem(
              context: context,
              lancamento: lancamento,
            ),
            LancamentosUpdateDataGrupoMenuItem(
              context: context,
              lancamento: lancamento,
            ),
            LancamentosUpdateValorGrupoMenuItem(
              context: context,
              lancamento: lancamento,
            ),
            LancamentosUpdateOrigemGrupoMenuItem(
              context: context,
              lancamento: lancamento,
            ),
          ],
        ],
        if (showCriarRecorrencia)
          LancamentosCriarRecorrenciaMenuItem(
            context: context,
            ref: ref,
            lancamentoId: lancamento.id,
          ),
        if (showAtualizarDataRecorrencia)
          LancamentosAtualizarDataRecorrenciaMenuItem(
            context: context,
            ref: ref,
            lancamentoId: lancamento.id,
            diaDoMesRecorrencia: recorrenciaGrupo.diaDoMes,
            diaDoLancamento: dataDay,
          ),
        if (showAtualizarSequenciaRecorrencia)
          LancamentosAtualizarSequenciaRecorrenciaMenuItem(
            context: context,
            lancamento: lancamento,
          ),
        if (showFinalizarRecorrencia)
          LancamentosFinalizarRecorrenciaMenuItem(
            context: context,
            ref: ref,
            lancamentoId: lancamento.id,
          ),
        if (showReativarRecorrencia)
          LancamentosReativarRecorrenciaMenuItem(
            context: context,
            ref: ref,
            lancamentoId: lancamento.id,
          ),
        if (showExcluir)
          LancamentosExcluirMenuItem(
            context: context,
            ref: ref,
            lancamento: lancamento,
          ),
      ],
    );
  }
}
