import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

enum ModoLancamento { simples, parcelado, replicado }

class ModoSelector extends StatelessWidget {
  final ModoLancamento selected;
  final bool showItens;
  final ValueChanged<ModoLancamento> onModoChanged;
  final ValueChanged<bool> onShowItensChanged;

  const ModoSelector({
    super.key,
    required this.selected,
    required this.showItens,
    required this.onModoChanged,
    required this.onShowItensChanged,
  });

  Widget _buildModoButton(
    BuildContext context,
    ModoLancamento modo,
    IconData icon,
    String label, //
  ) {
    final theme = Theme.of(context);
    final isSelected = selected == modo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () => onModoChanged(modo),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: //
              isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected ? theme.colorScheme.primary : theme.hintColor, //
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Modo de Lançamento agrupado com borda e texto
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const AppText('Modo de Lançamento', variant: AppTextVariant.body),
                const Spacer(),
                _buildModoButton(
                  context,
                  ModoLancamento.simples,
                  Icons.payment_outlined,
                  'Simples', //
                ),
                _buildModoButton(
                  context,
                  ModoLancamento.parcelado,
                  Icons.date_range_outlined,
                  'Parcelado', //
                ),
                _buildModoButton(
                  context,
                  ModoLancamento.replicado,
                  Icons.repeat_outlined,
                  'Replicado', //
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Detalhamento do Valor agrupado à direita
        Expanded(
          child: Tooltip(
            message: showItens ? 'Ocultar Detalhamento' : 'Mostrar Detalhamento',
            child: InkWell(
              onTap: () => onShowItensChanged(!showItens),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    AppText(
                      'Detalhamento do Valor',
                      variant: AppTextVariant.body,
                      color: showItens ? theme.colorScheme.primary : null,
                      fontWeight: showItens ? FontWeight.bold : null,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.list_alt_outlined,
                      size: 20,
                      color: //
                      showItens
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
