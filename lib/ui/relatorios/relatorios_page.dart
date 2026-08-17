import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/relatorios/widgets/relatorio_categoria_list_card.dart';
import 'package:zzuna/ui/relatorios/widgets/relatorio_centro_custo_card.dart';
import 'package:zzuna/ui/relatorios/widgets/relatorio_filter_bar.dart';
import 'package:zzuna/ui/relatorios/widgets/relatorio_resumo_overview_card.dart';
import 'package:zzuna/ui/relatorios/widgets/relatorio_subcategoria_pie_chart.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class RelatoriosPage extends ConsumerStatefulWidget {
  const RelatoriosPage({super.key});

  @override
  ConsumerState<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends ConsumerState<RelatoriosPage> {
  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(relatorioFilterProvider);
    final viewModel = ref.watch(relatoriosViewModelProvider);

    // Sync filter changes with viewModel
    ref.listen(relatorioFilterProvider, (previous, next) {
      ref.read(relatoriosViewModelProvider).updateFilter(next.mes, next.ano);
    });

    final relatorio = viewModel.relatorio;
    final isRunning = viewModel.loadCommand.value.isRunning;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const AppCard(
            variant: AppCardVariant.filter,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: RelatorioFilterBar(),
          ),
          const AppDivider(),
          Expanded(
            child: AppCard(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRunning && relatorio == null)
                      const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (relatorio == null)
                      const SizedBox(
                        height: 300,
                        child: Center(
                          child: AppText(
                            'Erro ao carregar os relatórios do mês.',
                            variant: AppTextVariant.body,
                          ),
                        ),
                      )
                    else ...[
                      // Section 1: Overview (Clickable Receitas / Despesas)
                      RelatorioResumoOverviewCard(
                        relatorio: relatorio,
                        mesAnoTitle:
                            '${filterState.mes.descricao} / ${filterState.ano}',
                        selectedTipo: viewModel.selectedTipo,
                        onSelectTipo: (tipo) => viewModel.selectTipo(tipo),
                      ),
                      const SizedBox(height: 16),

                      // Section 2: Global Categories List + Pie Chart
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 900;
                          final currentCategories =
                              viewModel.currentCategoriasPai;

                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: RelatorioCategoriaListCard(
                                    categoriasPai: currentCategories,
                                    selectedCategoriaPaiId:
                                        viewModel.selectedCategoriaPaiId,
                                    selectedTipo: viewModel.selectedTipo,
                                    onSelectCategoriaPai: (id) =>
                                        viewModel.selectCategoriaPai(id),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 5,
                                  child: RelatorioSubcategoriaPieChart(
                                    selectedGroup:
                                        viewModel.selectedCategoriaPaiGroup,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              RelatorioCategoriaListCard(
                                categoriasPai: currentCategories,
                                selectedCategoriaPaiId:
                                    viewModel.selectedCategoriaPaiId,
                                selectedTipo: viewModel.selectedTipo,
                                onSelectCategoriaPai: (id) =>
                                    viewModel.selectCategoriaPai(id),
                              ),
                              const SizedBox(height: 16),
                              RelatorioSubcategoriaPieChart(
                                selectedGroup:
                                    viewModel.selectedCategoriaPaiGroup,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Section 3: Cost Centers Overview Card
                      RelatorioCentroCustoCard(
                        centrosDeCusto: viewModel.currentCentrosDeCusto,
                        selectedCentroCustoId: viewModel.selectedCentroCustoId,
                        selectedTipo: viewModel.selectedTipo,
                        onSelectCentroCusto: (id) =>
                            viewModel.selectCentroCusto(id),
                      ),
                      const SizedBox(height: 16),

                      // Section 4: Cost Center Nested Categories + Pie Chart
                      if (viewModel.selectedCentroCustoGroup != null)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 900;
                            final ccGroup = viewModel.selectedCentroCustoGroup!;
                            final ccCategories = ccGroup.categoriasPai;

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: RelatorioCategoriaListCard(
                                      categoriasPai: ccCategories,
                                      selectedCategoriaPaiId:
                                          viewModel.selectedCCCategoriaPaiId,
                                      selectedTipo: viewModel.selectedTipo,
                                      onSelectCategoriaPai: (id) =>
                                          viewModel.selectCCCategoriaPai(id),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 5,
                                    child: RelatorioSubcategoriaPieChart(
                                      selectedGroup:
                                          viewModel.selectedCCCategoriaPaiGroup,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                RelatorioCategoriaListCard(
                                  categoriasPai: ccCategories,
                                  selectedCategoriaPaiId:
                                      viewModel.selectedCCCategoriaPaiId,
                                  selectedTipo: viewModel.selectedTipo,
                                  onSelectCategoriaPai: (id) =>
                                      viewModel.selectCCCategoriaPai(id),
                                ),
                                const SizedBox(height: 16),
                                RelatorioSubcategoriaPieChart(
                                  selectedGroup:
                                      viewModel.selectedCCCategoriaPaiGroup,
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
