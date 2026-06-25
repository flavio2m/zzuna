import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_editar_button.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_excluir_button.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_dividir_button.dart';

class LancamentoItemCard extends StatelessWidget {
  final LancamentoItem item;
  final double totalValor;
  final String centroCustoDescricao;
  final String categoriaDescricao;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDivide;

  const LancamentoItemCard({
    super.key,
    required this.item,
    required this.totalValor,
    required this.centroCustoDescricao,
    required this.categoriaDescricao,
    this.onEdit,
    this.onDelete,
    this.onDivide,
  });

  @override
  Widget build(BuildContext context) {
    final pct = totalValor > 0 ? (item.valor / totalValor) * 100 : 0.0;

    // Formatar percentual com até 3 casas decimais, mas remover zeros desnecessários
    String pctStr = pct.toStringAsFixed(3);
    if (pctStr.contains('.')) {
      while (pctStr.endsWith('0')) {
        pctStr = pctStr.substring(0, pctStr.length - 1);
      }
      if (pctStr.endsWith('.')) {
        pctStr = pctStr.substring(0, pctStr.length - 1);
      }
    }
    pctStr = pctStr.replaceAll('.', ',');

    final formattedValor = UtilBrasilFields.obterReal(item.valor);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Círculo com o número do item
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.slate200,
              shape: BoxShape.circle, //
            ),
            child: AppText(
              '${item.numero}',
              variant: AppTextVariant.caption,
              fontWeight: FontWeight.bold, //
            ),
          ),
          const SizedBox(width: 12),
          // Tags de Centro de Custo e Categoria
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (centroCustoDescricao.isNotEmpty)
                  AppTag(centroCustoDescricao, variant: AppTagVariant.neutral)
                else
                  const AppTag('Sem Centro de Custo', variant: AppTagVariant.error),
                if (categoriaDescricao.isNotEmpty)
                  AppTag(categoriaDescricao, variant: AppTagVariant.info)
                else
                  const AppTag('Sem Categoria', variant: AppTagVariant.error),
              ],
            ),
          ),

          // Percentual, Valor e Ações de Botões no lado direito
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppTag('$pctStr%', variant: AppTagVariant.neutral),
              const SizedBox(width: 8),
              AppText(
                formattedValor,
                variant: AppTextVariant.body,
                fontWeight: FontWeight.bold, //
              ),
              if (onDivide != null) ...[
                const SizedBox(width: 8),
                IconDividirButton(
                  onPressed: onDivide!, //
                ),
              ],
              if (onEdit != null) ...[
                const SizedBox(width: 8),
                IconEditarButton(
                  onPressed: onEdit!, //
                ),
              ],
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                IconExcluirButton(
                  onPressed: onDelete!, //
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
