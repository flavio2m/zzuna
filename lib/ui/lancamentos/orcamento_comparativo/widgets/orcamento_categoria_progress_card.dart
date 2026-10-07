import 'package:flutter/material.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

class OrcamentoCategoriaProgressCard extends StatelessWidget {
  final OrcamentoCategoriaComparativoModel item;

  const OrcamentoCategoriaProgressCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = item.percentualUtilizado;
    final isEstourado = item.estourou;
    final isAtencao = !isEstourado && pct >= 80.0;

    final Color statusColor = isEstourado
        ? AppColors.danger
        : (isAtencao ? AppColors.amber700 : AppColors.emerald600);

    final Color statusBg = isEstourado
        ? AppColors.rose50
        : (isAtencao ? AppColors.amber50 : AppColors.emerald50);

    final String statusLabel = isEstourado
        ? 'Estourou +${CurrencyFormatter.formatWithSymbol(item.valorExcedente)}'
        : '${pct.toPercentFormatted()} utilizado';

    final double progressValue = item.valorPrevisto > 0
        ? (item.valorReal / item.valorPrevisto).clamp(0.0, 1.0)
        : (item.valorReal > 0 ? 1.0 : 0.0);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isEstourado
              ? AppColors.danger.withValues(alpha: 0.4)
              : AppColors.slate200,
        ),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        item.categoria.descricao,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.slate800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.indigo50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (item.categoria.percentualOrcamento ?? 0.0)
                              .toPercentFormatted(),
                          style: const TextStyle(
                            color: AppColors.indigo600,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountItem(
                  'Previsto',
                  CurrencyFormatter.formatWithSymbol(item.valorPrevisto),
                  AppColors.slate600,
                ),
                _buildAmountItem(
                  'Real Gasto',
                  CurrencyFormatter.formatWithSymbol(item.valorReal),
                  statusColor,
                  isBold: true,
                ),
                _buildAmountItem(
                  isEstourado ? 'Excedente' : 'Saldo Restante',
                  CurrencyFormatter.formatWithSymbol(
                    isEstourado ? item.valorExcedente : item.saldoRestante,
                  ),
                  isEstourado ? AppColors.danger : AppColors.emerald800,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 6,
                backgroundColor: AppColors.slate100,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            if (item.subcategorias.isNotEmpty) ...[
              const SizedBox(height: 6),
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(top: 4, bottom: 2),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    'Ver ${item.subcategorias.length} subcategoria(s) com gastos',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: item.subcategorias.map((sub) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.subdirectory_arrow_right_rounded,
                                size: 14,
                                color: AppColors.slate400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sub.categoria.descricao,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.slate700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${CurrencyFormatter.formatWithSymbol(sub.valor)} (${sub.percentualDaCategoria.toPercentFormatted()})',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountItem(
    String label,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.slate500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
