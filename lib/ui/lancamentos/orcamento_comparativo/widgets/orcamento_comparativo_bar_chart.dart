import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

class OrcamentoComparativoBarChart extends StatelessWidget {
  final OrcamentoMensalComparativoModel comparativo;

  const OrcamentoComparativoBarChart({super.key, required this.comparativo});

  @override
  Widget build(BuildContext context) {
    final categorias = comparativo.categorias;

    if (categorias.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'Nenhuma categoria com orçamento configurado.',
            style: TextStyle(color: AppColors.slate500, fontSize: 13),
          ),
        ),
      );
    }

    double maxVal = 0.0;
    for (final cat in categorias) {
      if (cat.valorPrevisto > maxVal) maxVal = cat.valorPrevisto;
      if (cat.valorReal > maxVal) maxVal = cat.valorReal;
    }
    if (maxVal == 0) maxVal = 100;
    final maxY = maxVal * 1.2;

    final isDesktop = MediaQuery.of(context).size.width >= 800;
    final rodWidth = isDesktop ? 14.0 : 9.0;
    final spaceBetweenRods = isDesktop ? 4.0 : 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLegend(context),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 0 ? (maxY / 4) : 25,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: AppColors.slate200,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          _formatCompactCurrency(value),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.slate500,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= categorias.length) {
                        return const SizedBox.shrink();
                      }
                      final cat = categorias[index];
                      final name = cat.categoria.descricao;
                      final truncated = name.length > 8
                          ? '${name.substring(0, 7)}…'
                          : name;

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Tooltip(
                          message: name,
                          child: Text(
                            truncated,
                            style: TextStyle(
                              fontSize: isDesktop ? 11 : 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate700,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.slate800,
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final cat = categorias[group.x.toInt()];
                    final isPrevisto = rodIndex == 0;
                    final label = isPrevisto ? 'Previsto' : 'Real';
                    final valor = isPrevisto
                        ? cat.valorPrevisto
                        : cat.valorReal;
                    final pct = cat.percentualUtilizado.toPercentFormatted();

                    return BarTooltipItem(
                      '${cat.categoria.descricao}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '$label: ${CurrencyFormatter.formatWithSymbol(valor)}\n',
                          style: TextStyle(
                            color: isPrevisto
                                ? AppColors.indigo100
                                : (cat.estourou
                                      ? AppColors.rose50
                                      : AppColors.emerald200),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (!isPrevisto)
                          TextSpan(
                            text: 'Utilizado: $pct do previsto',
                            style: TextStyle(
                              color: cat.estourou
                                  ? AppColors.rose50
                                  : AppColors.emerald200,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              barGroups: List.generate(categorias.length, (index) {
                final cat = categorias[index];
                return BarChartGroupData(
                  x: index,
                  barsSpace: spaceBetweenRods,
                  barRods: [
                    BarChartRodData(
                      toY: cat.valorPrevisto,
                      color: AppColors.indigo600,
                      width: rodWidth,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    BarChartRodData(
                      toY: cat.valorReal,
                      color: cat.estourou
                          ? AppColors.danger
                          : AppColors.emerald600,
                      width: rodWidth,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppColors.indigo600, label: 'Previsto'),
        SizedBox(width: 16),
        _LegendItem(color: AppColors.emerald600, label: 'Real (No Limite)'),
        SizedBox(width: 16),
        _LegendItem(color: AppColors.danger, label: 'Real (Estourado)'),
      ],
    );
  }

  String _formatCompactCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.slate600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
