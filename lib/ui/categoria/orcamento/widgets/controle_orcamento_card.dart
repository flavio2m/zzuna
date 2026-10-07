import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/ui/categoria/orcamento/definir_orcamento/widgets/definir_orcamento_modal.dart';
import 'package:zzuna/ui/categoria/orcamento/widgets/categoria_orcamento_slider_item.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';

class ControleOrcamentoCard extends ConsumerStatefulWidget {
  final EdgeInsetsGeometry? margin;
  final bool isExpanded;

  const ControleOrcamentoCard({
    super.key,
    this.margin,
    this.isExpanded = false,
  });

  @override
  ConsumerState<ControleOrcamentoCard> createState() =>
      _ControleOrcamentoCardState();
}

class _ControleOrcamentoCardState extends ConsumerState<ControleOrcamentoCard> {
  // Cache temporário para valores enquanto o slider é arrastado
  final Map<String, double> _tempPercentages = {};

  @override
  Widget build(BuildContext context) {
    final listVM = ref.watch(categoriaListViewModelProvider);
    final currentUser = ref.watch(userProvider).value;
    final orcamento = currentUser?.orcamentoValor ?? 0.0;

    // Filtra as categorias pai de despesa (saída) que fazem parte do orçamento (com percentual definido)
    final categoriasOrcamento = listVM.categoriasPai
        .where(
          (c) =>
              c.ativo &&
              c.natureza == CategoriaNatureza.saida &&
              c.percentualOrcamento != null,
        )
        .toList();

    // Limpa do cache temporário as categorias cujo percentual salvo já bate com o valor da lista
    for (final cat in categoriasOrcamento) {
      if (_tempPercentages.containsKey(cat.id) &&
          _tempPercentages[cat.id] == cat.percentualOrcamento) {
        _tempPercentages.remove(cat.id);
      }
    }

    // Calcula o percentual total alocado
    final totalAlocado = categoriasOrcamento.fold<double>(0.0, (sum, cat) {
      final p = _tempPercentages[cat.id] ?? cat.percentualOrcamento ?? 0.0;
      return sum + p;
    });

    return AppCard(
      margin:
          widget.margin ??
          const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    AppText('Orçamento', variant: AppTextVariant.title),
                    AppSpacing(size: AppSpacingSize.xs),
                    AppText(
                      '% da renda de referência — o valor é recalculado',
                      variant: AppTextVariant.caption,
                      color: AppColors.slate400,
                    ),
                  ],
                ),
              ),

              // Botão de definir/editar o orçamento mensal
              if (currentUser != null)
                InkWell(
                  onTap: () => DefinirOrcamentoModal.show(
                    context,
                    currentUser,
                    orcamento,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.slate800,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.slate700),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: orcamento > 0
                              ? AppColors.primary
                              : AppColors.slate400,
                        ),
                        const AppSpacing(
                          size: AppSpacingSize.xs,
                          axis: Axis.horizontal,
                        ),
                        AppText(
                          orcamento > 0
                              ? UtilBrasilFields.obterReal(orcamento)
                              : 'Definir Renda',
                          variant: AppTextVariant.body,
                          fontWeight: FontWeight.w600,
                          color: orcamento > 0
                              ? Colors.white
                              : AppColors.slate300,
                        ),
                        const AppSpacing(
                          size: AppSpacingSize.xs,
                          axis: Axis.horizontal,
                        ),
                        const Icon(
                          Icons.edit,
                          size: 13,
                          color: AppColors.slate400,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const AppSpacing(size: AppSpacingSize.sm),

          if (listVM.loadCommand.value.isRunning &&
              listVM.categoriasPai.isEmpty) ...[
            widget.isExpanded
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ] else if (categoriasOrcamento.isEmpty) ...[
            widget.isExpanded
                ? const Expanded(
                    child: Center(
                      child: AppText(
                        'Nenhuma categoria pai de despesa com percentual de '
                        'orçamento configurado.',
                        variant: AppTextVariant.body,
                        color: AppColors.slate400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: AppText(
                        'Nenhuma categoria pai de despesa com percentual de '
                        'orçamento configurado.',
                        variant: AppTextVariant.body,
                        color: AppColors.slate400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ] else ...[
            // Lista de categorias com sliders reutilizáveis
            if (widget.isExpanded)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildSliderItems(categoriasOrcamento, orcamento),
                  ),
                ),
              )
            else
              ..._buildSliderItems(categoriasOrcamento, orcamento),

            const AppSpacing(size: AppSpacingSize.xs),
            const AppDivider(),
            const AppSpacing(size: AppSpacingSize.xs),

            // Alocado Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Alocado',
                  variant: AppTextVariant.subtitle,
                  color: AppColors.slate400,
                ),
                AppText(
                  '${totalAlocado.toPercentFormatted()} / 100%',
                  variant: AppTextVariant.subtitle,
                  fontWeight: FontWeight.bold,
                  color: _getTotalColor(totalAlocado),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getTotalColor(double totalAlocado) {
    if (totalAlocado > 100) {
      return AppColors.danger;
    }
    final t = (totalAlocado / 100).clamp(0.0, 1.0);
    if (t < 0.5) {
      return Color.lerp(AppColors.danger, const Color(0xFFEAB308), t * 2)!;
    } else {
      return Color.lerp(
        const Color(0xFFEAB308),
        AppColors.emerald800,
        (t - 0.5) * 2,
      )!;
    }
  }

  List<Widget> _buildSliderItems(
    List<Categoria> categoriasOrcamento,
    double orcamento,
  ) {
    return categoriasOrcamento.map((cat) {
      final percentual =
          _tempPercentages[cat.id] ?? cat.percentualOrcamento ?? 0.0;

      return CategoriaOrcamentoSliderItem(
        key: ValueKey(cat.id),
        categoria: cat,
        percentual: percentual,
        orcamentoTotal: orcamento,
        onDragging: (novoValor) {
          setState(() {
            _tempPercentages[cat.id] = novoValor;
          });
        },
        onPercentualChanged: (novoValor) async {
          final vm = ref.read(categoriaPercentualViewModelProvider);
          await vm.updatePercentualCommand.execute((
            categoria: cat,
            percentual: novoValor,
          ));
          setState(() {
            _tempPercentages.remove(cat.id);
          });
        },
        onSavedFromModal: (novoValor) {
          setState(() {
            _tempPercentages[cat.id] = novoValor;
          });
        },
      );
    }).toList();
  }
}
