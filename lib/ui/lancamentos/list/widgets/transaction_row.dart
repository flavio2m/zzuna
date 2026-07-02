import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';

class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.lancamentoId,
    required this.description,
    required this.category,
    required this.origem,
    required this.value,
    this.tipo = LancamentoTipo.despesa,
    this.costCenter = 'CC: Geral',
    this.badge,
    this.grupo,
    this.conciliado = false,
    this.selected = false,
    required this.reconcileButton,
    required this.lancamento,
    this.onTap,
    this.onSelect,
  });

  final String lancamentoId;
  final String description;
  final String category;
  final LancamentoOrigemDetail origem;
  final String value;
  final LancamentoTipo tipo;
  final String costCenter;
  final String? badge;
  final LancamentoGrupo? grupo;
  final bool conciliado;
  final bool selected;
  final Widget reconcileButton;
  final LancamentoDetails lancamento;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelect;

  @override
  Widget build(BuildContext context) {
    final iconColor = switch (tipo) {
      LancamentoTipo.receita => AppColors.primary,
      LancamentoTipo.transferencia => AppColors.indigo600,
      LancamentoTipo.despesa => AppColors.danger,
    };

    final iconBackground = switch (tipo) {
      LancamentoTipo.receita => AppColors.emerald50,
      LancamentoTipo.transferencia => AppColors.indigo50,
      LancamentoTipo.despesa => AppColors.rose50,
    };

    final icon = switch (tipo) {
      LancamentoTipo.receita => Icons.arrow_upward_rounded,
      LancamentoTipo.transferencia => Icons.layers_outlined,
      LancamentoTipo.despesa => Icons.arrow_downward_rounded,
    };

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: selected
            ? AppColors.emerald50.withValues(alpha: 0.35)
            : AppColors.surface,
        child: Row(
          children: [
            GestureDetector(
              onTap: onSelect != null ? () => onSelect!(!selected) : null,
              child: Container(
                color: Colors.transparent, // Amplia a área de toque
                padding: const EdgeInsets.all(4),
                child: Icon(
                  selected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 17,
                  color: selected ? AppColors.primary : AppColors.slate300,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8), //
              ),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.slate800,
                            fontSize: 12,
                            fontWeight: FontWeight.w800, //
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6), _Badge(label: badge!), //
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 5,
                    children: [
                      _MetaChip(
                        icon: origem.map(
                          conta: (_) => Icons.account_balance_wallet_outlined,
                          cartao: (_) => Icons.credit_card,
                        ),
                        label: origem.map(
                          conta: (c) => c.conta.descricao,
                          cartao: (c) => c.cartao.descricao, //
                        ),
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.slate300,
                          fontSize: 10,
                        ), //
                      ),
                      Text(
                        category,
                        style: const TextStyle(
                          color: AppColors.slate600,
                          fontSize: 10,
                          fontWeight: FontWeight.w700, //
                        ),
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.slate300,
                          fontSize: 10,
                        ), //
                      ),
                      Text(
                        costCenter,
                        style: const TextStyle(
                          color: AppColors.slate500,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (grupo != null) ...[
                        const Text(
                          '•',
                          style: TextStyle(
                            color: AppColors.slate300,
                            fontSize: 10,
                          ),
                        ),
                        Tooltip(
                          message: switch (grupo!) {
                            LancamentoGrupoParcelamento(
                              :final parcela,
                              :final totalParcelas,
                            ) =>
                              'Parcelado ($parcela/$totalParcelas)',
                            LancamentoGrupoReplicacao(
                              :final parcela,
                              :final totalParcelas,
                            ) =>
                              'Replicado ($parcela de $totalParcelas)',
                            LancamentoGrupoTransferencia() => 'Transferência',
                            LancamentoGrupoRecorrencia(:final ativo) =>
                              ativo
                                  ? 'Recorrente (Ativo)'
                                  : 'Recorrência Inativa',
                          },
                          child: Icon(
                            switch (grupo!) {
                              LancamentoGrupoParcelamento() =>
                                Icons.auto_awesome_motion_outlined,
                              LancamentoGrupoReplicacao() =>
                                Icons.repeat_outlined,
                              LancamentoGrupoTransferencia() =>
                                Icons.swap_horiz_outlined,
                              LancamentoGrupoRecorrencia(:final ativo) =>
                                ativo
                                    ? Icons.repeat_rounded
                                    : Icons.repeat_one_outlined,
                            },
                            size: 13,
                            color:
                                grupo is LancamentoGrupoRecorrencia &&
                                    !(grupo as LancamentoGrupoRecorrencia).ativo
                                ? AppColors.slate400
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 104,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: switch (tipo) {
                    LancamentoTipo.receita => AppColors.primary,
                    LancamentoTipo.transferencia => AppColors.slate600,
                    LancamentoTipo.despesa => AppColors.danger,
                  },
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            reconcileButton,
            const SizedBox(width: 8),
            IconAcoesButton(lancamento: lancamento),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.slate500),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.slate600,
                fontSize: 10,
                fontWeight: FontWeight.w800, //
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.indigo50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.indigo100),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.indigo600,
          fontSize: 10,
          fontWeight: FontWeight.w900, //
        ),
      ),
    );
  }
}
