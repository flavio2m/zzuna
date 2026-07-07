import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';

class ParceladoPanel extends StatelessWidget {
  final int numParcelas;
  final ValueChanged<int> onNumParcelasChanged;
  final double totalValor;
  final List<double> previewValores;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  const ParceladoPanel({
    super.key,
    required this.numParcelas,
    required this.onNumParcelasChanged,
    required this.totalValor,
    required this.previewValores,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  min: 2,
                  max: 24,
                  label: 'Número de Parcelas',
                  focusNode: focusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: onFieldSubmitted,
                  initialValue: numParcelas.toString(),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= 2) {
                      onNumParcelasChanged(parsed);
                    }
                  },
                ),
              ),
            ],
          ),
          if (previewValores.isNotEmpty) ...[
            const SizedBox(height: 12),
            const AppText(
              'Preview das parcelas:',
              variant: AppTextVariant.caption, //
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 96),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: previewValores.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          'Parcela ${i + 1}/$numParcelas',
                          variant: AppTextVariant.caption,
                          fontWeight: FontWeight.normal,
                        ),
                        AppText(
                          'R\$ ${previewValores[i].toStringAsFixed(2)}',
                          variant: AppTextVariant.caption, //
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
