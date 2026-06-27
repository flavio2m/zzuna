import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/models/lancamento_resumo_mensal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class LancamentoResumoFinanceiroCard extends StatelessWidget {
  final LancamentoResumoMensal resumo;

  const LancamentoResumoFinanceiroCard({super.key, required this.resumo});

  String _formatCurrency(double value) {
    final prefix = value < 0 ? '- ' : '';
    return UtilBrasilFields //
        .obterReal(value.abs(), moeda: true)
        .replaceFirst(r'R$', '$prefix R\$');
  }

  Color _valueColor(double value) {
    if (value > 0) return AppColors.emerald800;
    if (value < 0) return AppColors.danger;
    return AppColors.slate500;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 3), //
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _InfoItem(
              width: 120,
              title: 'Saldo Inicial: ',
              value: _formatCurrency(resumo.saldoInicial),
              color: _valueColor(resumo.saldoInicial),
            ),
          ),
          Expanded(
            child: _InfoItem(
              width: 110,
              title: 'Entradas: ',
              value: _formatCurrency(resumo.receitas),
              color: AppColors.emerald800,
            ),
          ),
          Expanded(
            child: _InfoItem(
              width: 110,
              title: 'Saídas: ',
              value: _formatCurrency(resumo.despesas),
              color: AppColors.danger, //
            ),
          ),
          Expanded(
            child: _InfoItem(
              width: 120,
              title: 'Transferências: ',
              value: _formatCurrency(resumo.transferencias),
              color: AppColors.indigo600,
            ),
          ),
          Expanded(
            child: _InfoItem(
              width: 120,
              title: 'Saldo Final: ',
              value: _formatCurrency(resumo.saldoFinal),
              color: _valueColor(resumo.saldoFinal),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double width;

  const _InfoItem({
    required this.title,
    required this.value,
    required this.color,
    required this.width, //
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppText(
            title,
            variant: AppTextVariant.body,
            color: AppColors.slate500, //
          ),
          // const SizedBox(height: 2),
          AppText(value, variant: AppTextVariant.subtitle, color: color),
        ],
      ),
    );
  }
}
