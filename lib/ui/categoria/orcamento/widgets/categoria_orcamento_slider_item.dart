import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/categoria/orcamento/update_percentual/widgets/categoria_percentual_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';

class CategoriaOrcamentoSliderItem extends StatelessWidget {
  final Categoria categoria;
  final double percentual;
  final double orcamentoTotal;
  final ValueChanged<double> onDragging;
  final ValueChanged<double> onPercentualChanged;
  final ValueChanged<double>? onSavedFromModal;

  const CategoriaOrcamentoSliderItem({
    super.key,
    required this.categoria,
    required this.percentual,
    required this.orcamentoTotal,
    required this.onDragging,
    required this.onPercentualChanged,
    this.onSavedFromModal,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoria.categoryColor;
    final valorCalculado = (orcamentoTotal * percentual) / 100;
    final valorFormatado = orcamentoTotal > 0
        ? '≈ ${UtilBrasilFields.obterReal(valorCalculado)} por mês'
        : '≈ R\$ •••,•• por mês';
    final percentualFormatted = percentual.toCleanString(fractionDigits: 2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nome e Badge percentual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const AppSpacing(
                      size: AppSpacingSize.sm,
                      axis: Axis.horizontal,
                    ),
                    Flexible(
                      child: AppText(
                        categoria.descricao,
                        variant: AppTextVariant.subtitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  final novoPercentual = await CategoriaPercentualModal.show(
                    context,
                    categoria,
                  );
                  if (novoPercentual != null) {
                    onSavedFromModal?.call(novoPercentual);
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.slate800,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.slate700),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        percentualFormatted,
                        variant: AppTextVariant.body,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const AppText(
                        '%',
                        variant: AppTextVariant.caption,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Slider customizado compacto
          SizedBox(
            height: 22,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                activeTrackColor: color,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.08),
                thumbColor: color,
                overlayColor: color.withValues(alpha: 0.2),
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                  elevation: 1,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                trackShape: const RoundedRectSliderTrackShape(),
              ),
              child: Slider(
                value: percentual.clamp(0.0, 100.0),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (val) => onDragging(val.roundToDouble()),
                onChangeEnd: (val) => onPercentualChanged(val.roundToDouble()),
              ),
            ),
          ),

          // Valor recalculado
          Align(
            alignment: Alignment.centerRight,
            child: AppText(
              valorFormatado,
              variant: AppTextVariant.caption,
              color: AppColors.slate400,
            ),
          ),
        ],
      ),
    );
  }
}
