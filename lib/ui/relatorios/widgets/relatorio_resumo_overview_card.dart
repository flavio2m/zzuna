import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/models/relatorio/relatorio_mensal_model.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

class RelatorioResumoOverviewCard extends StatelessWidget {
  final RelatorioMensalModel relatorio;
  final String mesAnoTitle;
  final LancamentoTipo selectedTipo;
  final ValueChanged<LancamentoTipo> onSelectTipo;

  const RelatorioResumoOverviewCard({
    super.key,
    required this.relatorio,
    required this.mesAnoTitle,
    required this.selectedTipo,
    required this.onSelectTipo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxVal =
        (relatorio.totalReceitas > relatorio.totalDespesas
                ? relatorio.totalReceitas
                : relatorio.totalDespesas)
            .clamp(1.0, double.infinity);

    final receitaPercent = (relatorio.totalReceitas / maxVal).clamp(0.0, 1.0);
    final despesaPercent = (relatorio.totalDespesas / maxVal).clamp(0.0, 1.0);

    final saldoColor = relatorio.saldo >= 0
        ? AppColors.emerald600
        : AppColors.danger;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                AppText(
                  'Visão Geral - $mesAnoTitle',
                  variant: AppTextVariant.title,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Clique em Receitas ou Despesas para alternar o detalhamento por categoria.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Receitas Row (Clickable)
            _buildBarRow(
              context,
              label: 'Receitas',
              amount: relatorio.totalReceitas,
              percent: receitaPercent,
              barColor: AppColors.emerald600,
              isSelected: selectedTipo == LancamentoTipo.receita,
              onTap: () => onSelectTipo(LancamentoTipo.receita),
            ),
            const SizedBox(height: 12),

            // Despesas Row (Clickable)
            _buildBarRow(
              context,
              label: 'Despesas',
              amount: relatorio.totalDespesas,
              percent: despesaPercent,
              barColor: AppColors.danger,
              isSelected: selectedTipo == LancamentoTipo.despesa,
              onTap: () => onSelectTipo(LancamentoTipo.despesa),
            ),
            const SizedBox(height: 20),

            const Divider(height: 1),
            const SizedBox(height: 16),

            // Saldo Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText('Saldo do Mês', variant: AppTextVariant.title),
                Text(
                  CurrencyFormatter.formatWithSymbol(relatorio.saldo),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: saldoColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarRow(
    BuildContext context, {
    required String label,
    required double amount,
    required double percent,
    required Color barColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? barColor.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? barColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: barColor,
                        size: 16,
                      ),
                    ),
                  Expanded(child: AppText(label, variant: AppTextVariant.body)),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: barColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percent,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              CurrencyFormatter.formatWithSymbol(amount),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
