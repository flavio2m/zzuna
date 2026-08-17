import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/models/relatorio/relatorio_mensal_model.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

class RelatorioCategoriaListCard extends StatelessWidget {
  final List<RelatorioCategoriaPaiGroup> categoriasPai;
  final String? selectedCategoriaPaiId;
  final LancamentoTipo selectedTipo;
  final ValueChanged<String> onSelectCategoriaPai;

  const RelatorioCategoriaListCard({
    super.key,
    required this.categoriasPai,
    required this.selectedCategoriaPaiId,
    required this.selectedTipo,
    required this.onSelectCategoriaPai,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReceita = selectedTipo == LancamentoTipo.receita;

    final title = isReceita
        ? 'Receitas por Categoria (Pai)'
        : 'Despesas por Categoria (Pai)';

    final totalCategorias = categoriasPai.fold<double>(
      0.0,
      (sum, item) => sum + item.valorTotal,
    );

    final maxVal =
        (categoriasPai.isNotEmpty ? categoriasPai.first.valorTotal : 1.0).clamp(
          1.0,
          double.infinity,
        );

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
                  Icons.category_outlined,
                  color: isReceita
                      ? AppColors.emerald600
                      : theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                AppText(title, variant: AppTextVariant.title),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Clique em uma categoria pai para filtrar o gráfico de subcategorias ao lado.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            if (categoriasPai.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: AppText(
                    isReceita
                        ? 'Nenhuma receita registrada neste mês.'
                        : 'Nenhuma despesa registrada neste mês.',
                    variant: AppTextVariant.body,
                  ),
                ),
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoriasPai.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final group = categoriasPai[index];
                  final isSelected =
                      group.categoriaPai.id == selectedCategoriaPaiId;
                  final percent = (group.valorTotal / maxVal).clamp(0.0, 1.0);

                  final activeColor = isReceita
                      ? AppColors.emerald600
                      : theme.colorScheme.primary;

                  return InkWell(
                    onTap: () => onSelectCategoriaPai(group.categoriaPai.id),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? activeColor.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? activeColor : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  group.categoriaPai.descricao,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? activeColor
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Text(
                                CurrencyFormatter.formatWithSymbol(
                                  group.valorTotal,
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: percent,
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? activeColor
                                        : AppColors.slate600,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText('Total', variant: AppTextVariant.title),
                  Text(
                    CurrencyFormatter.formatWithSymbol(totalCategorias),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isReceita
                          ? AppColors.emerald600
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
