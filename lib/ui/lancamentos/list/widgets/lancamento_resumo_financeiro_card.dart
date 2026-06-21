import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/models/lancamento_resumo_mensal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentoResumoFinanceiroCard extends StatefulWidget {
  final LancamentoResumoMensal resumo;

  const LancamentoResumoFinanceiroCard({
    super.key,
    required this.resumo,
  });

  @override
  State<LancamentoResumoFinanceiroCard> createState() => _LancamentoResumoFinanceiroCardState();
}

class _LancamentoResumoFinanceiroCardState extends State<LancamentoResumoFinanceiroCard> {
  bool _expanded = false;

  String _formatCurrency(double val) {
    final prefix = val >= 0 ? '' : '- ';
    return UtilBrasilFields.obterReal(val.abs(), moeda: true).replaceFirst(r'R$', '$prefix R\$');
  }

  @override
  Widget build(BuildContext context) {
    final isNegativeFinal = widget.resumo.saldoFinal < 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saldo Inicial',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.slate500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(widget.resumo.saldoInicial),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.slate800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saldo Final',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.slate500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(widget.resumo.saldoFinal),
                            style: TextStyle(
                              fontSize: 16,
                              color: isNegativeFinal ? AppColors.danger : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.slate500,
                  ),
                  tooltip: _expanded ? 'Recolher detalhes' : 'Expandir detalhes',
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    const Divider(color: AppColors.slate100),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBreakdownItem(
                          'Receitas',
                          widget.resumo.receitas,
                          AppColors.emerald600,
                          const Icon(Icons.arrow_upward, size: 16, color: AppColors.emerald600),
                          AppColors.emerald50,
                        ),
                        _buildBreakdownItem(
                          'Despesas',
                          widget.resumo.despesas,
                          AppColors.danger,
                          const Icon(Icons.arrow_downward, size: 16, color: AppColors.danger),
                          AppColors.rose50,
                        ),
                        _buildBreakdownItem(
                          'Transferências',
                          widget.resumo.transferencias,
                          AppColors.indigo600,
                          const Icon(Icons.swap_horiz, size: 16, color: AppColors.indigo600),
                          AppColors.indigo50,
                        ),
                        _buildBreakdownItem(
                          'Investimentos',
                          widget.resumo.investimentos,
                          AppColors.orange800,
                          const Icon(Icons.trending_up, size: 16, color: AppColors.orange800),
                          AppColors.orange100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(
    String label,
    double value,
    Color color,
    Widget icon,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: icon,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatCurrency(value),
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
