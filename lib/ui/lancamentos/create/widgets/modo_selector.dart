import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

enum ModoLancamento { simples, parcelado, replicado }

class ModoSelector extends StatelessWidget {
  final ModoLancamento selected;
  final ValueChanged<ModoLancamento> onChanged;

  const ModoSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const AppText(
          'Modo de Lançamento:',
          variant: AppTextVariant.body,
        ),
        const SizedBox(width: 12),
        ...ModoLancamento.values.map((modo) {
          final isSelected = selected == modo;
          final label = switch (modo) {
            ModoLancamento.simples => 'Simples',
            ModoLancamento.parcelado => 'Parcelado',
            ModoLancamento.replicado => 'Replicado',
          };
          final icon = switch (modo) {
            ModoLancamento.simples => Icons.payment_outlined,
            ModoLancamento.parcelado => Icons.date_range_outlined,
            ModoLancamento.replicado => Icons.repeat_outlined,
          };
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Tooltip(
              message: label,
              child: InkWell(
                onTap: () => onChanged(modo),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.05) : theme.cardColor,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? theme.colorScheme.primary : theme.hintColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
