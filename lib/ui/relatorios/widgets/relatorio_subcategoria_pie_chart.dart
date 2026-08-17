import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/models/relatorio/relatorio_mensal_model.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

class RelatorioSubcategoriaPieChart extends StatefulWidget {
  final RelatorioCategoriaPaiGroup? selectedGroup;

  const RelatorioSubcategoriaPieChart({super.key, required this.selectedGroup});

  @override
  State<RelatorioSubcategoriaPieChart> createState() =>
      _RelatorioSubcategoriaPieChartState();
}

class _RelatorioSubcategoriaPieChartState
    extends State<RelatorioSubcategoriaPieChart> {
  int touchedIndex = -1;

  final List<Color> sliceColors = [
    AppColors.emerald600,
    AppColors.indigo600,
    AppColors.orange800,
    AppColors.danger,
    AppColors.slate600,
    AppColors.amber700,
    AppColors.slate800,
    AppColors.emerald800,
    AppColors.rose600,
    AppColors.indigo100,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final group = widget.selectedGroup;

    if (group == null || group.subcategorias.isEmpty) {
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
                    Icons.pie_chart_outline,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  const AppText('Subcategorias', variant: AppTextVariant.title),
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: AppText(
                  'Nenhuma subcategoria registrada para esta categoria.',
                  variant: AppTextVariant.body,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    }

    final parentName = group.categoriaPai.descricao;

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
                  Icons.pie_chart_outline,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    'Subcategorias: $parentName',
                    variant: AppTextVariant.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Distribuição proporcional das subcategorias de "$parentName".',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: _generateSections(group.subcategorias),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Legend
            const Divider(height: 1),
            const SizedBox(height: 12),
            Column(
              children: List.generate(group.subcategorias.length, (index) {
                final sub = group.subcategorias[index];
                final color = sliceColors[index % sliceColors.length];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sub.categoria.descricao,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${sub.percentual.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        CurrencyFormatter.formatWithSymbol(sub.valor),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(
    List<RelatorioSubcategoriaItem> subcategorias,
  ) {
    return List.generate(subcategorias.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 65.0 : 55.0;
      final sub = subcategorias[i];
      final color = sliceColors[i % sliceColors.length];

      return PieChartSectionData(
        color: color,
        value: sub.valor,
        title: '${sub.percentual.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
        ),
      );
    });
  }
}
