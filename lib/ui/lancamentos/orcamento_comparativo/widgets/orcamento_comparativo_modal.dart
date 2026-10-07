import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/widgets/orcamento_categoria_progress_card.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/widgets/orcamento_comparativo_bar_chart.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

class OrcamentoComparativoModal extends ConsumerWidget {
  const OrcamentoComparativoModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(
      context: context,
      maxWidth: 900,
      maxHeightFactor: 0.9,
      child: const OrcamentoComparativoModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparativo = ref.watch(orcamentoComparativoModelProvider);
    final filterState = ref.watch(lancamentoFilterProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context, filterState.mes.descricao, filterState.ano),
        const SizedBox(height: 16),
        if (comparativo.rendaReferencia <= 0) ...[
          _buildNoIncomeWarning(context),
          const SizedBox(height: 16),
        ],
        _buildSummaryKpis(comparativo, isDesktop),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.slate200),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.bar_chart_rounded,
                      color: AppColors.indigo600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Comparativo Gráfico por Categoria',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OrcamentoComparativoBarChart(comparativo: comparativo),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(
              Icons.list_alt_rounded,
              color: AppColors.emerald600,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Detalhamento das Categorias Orçadas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.slate800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (comparativo.categorias.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Nenhuma categoria pai ativa com percentual de orçamento configurado.',
                style: TextStyle(color: AppColors.slate500, fontSize: 13),
              ),
            ),
          )
        else
          ...comparativo.categorias.map(
            (cat) => OrcamentoCategoriaProgressCard(item: cat),
          ),
        if (comparativo.totalDespesasForaOrcamento > 0) ...[
          const SizedBox(height: 8),
          _buildForaOrcamentoAlert(comparativo),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String mes, int ano) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.emerald50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: AppColors.emerald600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Orçamento: Previsto vs Real',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                Text(
                  'Mês: $mes / $ano',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          color: AppColors.slate400,
          splashRadius: 20,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildNoIncomeWarning(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.amber50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.amber700.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.amber700, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Você ainda não definiu um valor de renda/orçamento de referência. '
              'Defina o orçamento no menu de Categorias para calcular os valores previstos.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.amber700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryKpis(
    OrcamentoMensalComparativoModel comparativo,
    bool isDesktop,
  ) {
    final saldoColor = comparativo.estourouGeral
        ? AppColors.danger
        : AppColors.emerald800;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _KpiCard(
          title: 'Total Previsto',
          value: CurrencyFormatter.formatWithSymbol(comparativo.totalPrevisto),
          subtitle:
              'Renda ref: ${CurrencyFormatter.formatWithSymbol(comparativo.rendaReferencia)}',
          icon: Icons.flag_outlined,
          color: AppColors.indigo600,
          bgColor: AppColors.indigo50,
          isDesktop: isDesktop,
        ),
        _KpiCard(
          title: 'Total Real Gasto',
          value: CurrencyFormatter.formatWithSymbol(comparativo.totalReal),
          subtitle:
              '${comparativo.percentualGeralUtilizado.toPercentFormatted()} do previsto',
          icon: Icons.payments_outlined,
          color: comparativo.estourouGeral
              ? AppColors.danger
              : AppColors.slate700,
          bgColor: comparativo.estourouGeral
              ? AppColors.rose50
              : AppColors.slate100,
          isDesktop: isDesktop,
        ),
        _KpiCard(
          title: comparativo.estourouGeral ? 'Excedente Geral' : 'Saldo Total',
          value: CurrencyFormatter.formatWithSymbol(
            comparativo.estourouGeral
                ? (comparativo.totalReal - comparativo.totalPrevisto)
                : comparativo.saldoTotal,
          ),
          subtitle: comparativo.estourouGeral
              ? 'Orçamento estourado'
              : 'Disponível no orçamento',
          icon: comparativo.estourouGeral
              ? Icons.warning_amber_rounded
              : Icons.account_balance_wallet_outlined,
          color: saldoColor,
          bgColor: comparativo.estourouGeral
              ? AppColors.rose50
              : AppColors.emerald50,
          isDesktop: isDesktop,
        ),
      ],
    );
  }

  Widget _buildForaOrcamentoAlert(OrcamentoMensalComparativoModel comparativo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.slate600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Despesas em categorias sem percentual de orçamento configurado: '
              '${CurrencyFormatter.formatWithSymbol(comparativo.totalDespesasForaOrcamento)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.slate700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool isDesktop;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = isDesktop ? 270.0 : double.infinity;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.slate600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
