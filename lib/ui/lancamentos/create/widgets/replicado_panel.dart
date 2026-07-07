import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';

class ReplicadoPanel extends StatelessWidget {
  final int parcelaInicial;
  final int parcelaFinal;
  final ValueChanged<int> onParcelaInicialChanged;
  final ValueChanged<int> onParcelaFinalChanged;
  final double valorUnitario;
  final FocusNode? focusInicial;
  final FocusNode? focusFinal;
  final ValueChanged<String>? onInicialSubmitted;
  final ValueChanged<String>? onFinalSubmitted;

  const ReplicadoPanel({
    super.key,
    required this.parcelaInicial,
    required this.parcelaFinal,
    required this.onParcelaInicialChanged,
    required this.onParcelaFinalChanged,
    required this.valorUnitario,
    this.focusInicial,
    this.focusFinal,
    this.onInicialSubmitted,
    this.onFinalSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = parcelaFinal - parcelaInicial + 1;
    final totalCompromisso = valorUnitario * (count > 0 ? count : 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppIntegerFormField(
                  label: 'Parcela Inicial',
                  focusNode: focusInicial,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: onInicialSubmitted,
                  min: 1,
                  max: 24,
                  initialValue: parcelaInicial.toString(),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= 2) {
                      onParcelaInicialChanged(parsed);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppIntegerFormField(
                  label: 'Parcela Final',
                  focusNode: focusFinal,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: onFinalSubmitted,
                  min: 2,
                  max: 24,
                  initialValue: parcelaFinal.toString(),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= parcelaInicial) {
                      onParcelaFinalChanged(parsed);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                'Lançamentos a gerar:',
                variant: AppTextVariant.body,
                fontWeight: FontWeight.normal,
              ),
              AppText('$count lançamentos', variant: AppTextVariant.body),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                'Compromisso total:',
                variant: AppTextVariant.body,
                fontWeight: FontWeight.normal,
              ),
              AppText(
                'R\$ ${totalCompromisso.toStringAsFixed(2)}',
                variant: AppTextVariant.body,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
