import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/viewmodels/lista_compras_comprar_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/widgets/editar_registro_compra_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:zzuna/utils/formatters/date_formatter.dart';

class ItemCompraHistoricoModal extends ConsumerStatefulWidget {
  final ItemCompra item;
  final ListaCompras lista;

  const ItemCompraHistoricoModal({
    super.key,
    required this.item,
    required this.lista,
  });

  static void show(
    BuildContext context, {
    required ItemCompra item,
    required ListaCompras lista,
  }) {
    AppDialog.show(
      context: context,
      child: ItemCompraHistoricoModal(item: item, lista: lista),
    );
  }

  @override
  ConsumerState<ItemCompraHistoricoModal> createState() =>
      _ItemCompraHistoricoModalState();
}

class _ItemCompraHistoricoModalState
    extends ConsumerState<ItemCompraHistoricoModal> {
  late final ListaComprasComprarViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(listaComprasComprarViewModelProvider);
    _viewModel.removerRegistroCompraCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    _viewModel.removerRegistroCompraCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.removerRegistroCompraCommand.value;
    commandValue.onSuccess((_) {
      if (mounted) {
        AppSnackBar.showSuccess(context, 'Compra estornada com sucesso.');
      }
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro ao estornar compra.',
        );
      }
    });
  }

  String _formatNum(double num) {
    return num % 1 == 0 ? num.toInt().toString() : num.toString();
  }

  @override
  Widget build(BuildContext context) {
    final listVm = ref.watch(listaComprasListViewModelProvider);
    final currentLista = listVm.listaAtual ?? widget.lista;
    final currentItem = currentLista.itens.firstWhere(
      (i) => i.id == widget.item.id,
      orElse: () => widget.item,
    );

    final comprarVm = ref.watch(listaComprasComprarViewModelProvider);
    final isLoading = comprarVm.removerRegistroCompraCommand.value.isRunning;

    final restante =
        currentItem.quantidadePlanejada - currentItem.quantidadeComprada;
    final restanteDisplay = restante > 0 ? restante : 0.0;

    final totalGasto = currentItem.historicoCompras.fold(
      0.0,
      (sum, r) => sum + r.valorTotal,
    );

    return AppForm(
      title: 'Histórico de Compras',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(
          label: 'Fechar',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com resumo do item
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  currentItem.produto,
                  variant: AppTextVariant.subtitle,
                  fontWeight: FontWeight.bold,
                ),
                const AppSpacing(size: AppSpacingSize.xs),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    AppText(
                      'Planejado: ${_formatNum(currentItem.quantidadePlanejada)}',
                      variant: AppTextVariant.caption,
                      color: AppColors.slate600,
                    ),
                    const AppText(
                      '•',
                      variant: AppTextVariant.caption,
                      color: AppColors.slate400,
                    ),
                    AppText(
                      'Comprado: ${_formatNum(currentItem.quantidadeComprada)}',
                      variant: AppTextVariant.caption,
                      color: AppColors.emerald600,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppText(
                      '•',
                      variant: AppTextVariant.caption,
                      color: AppColors.slate400,
                    ),
                    AppText(
                      'Restante: ${_formatNum(restanteDisplay)}',
                      variant: AppTextVariant.caption,
                      color: AppColors.slate600,
                    ),
                    if (totalGasto > 0) ...[
                      const AppText(
                        '•',
                        variant: AppTextVariant.caption,
                        color: AppColors.slate400,
                      ),
                      AppText(
                        'Total: ${UtilBrasilFields.obterReal(totalGasto, moeda: true)}',
                        variant: AppTextVariant.caption,
                        color: AppColors.indigo600,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          // Lista de registros
          if (currentItem.historicoCompras.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 40,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  const AppSpacing(size: AppSpacingSize.sm),
                  const AppText(
                    'Nenhuma compra registrada para este item.',
                    variant: AppTextVariant.body,
                    color: AppColors.slate500,
                  ),
                ],
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: currentItem.historicoCompras.length,
                separatorBuilder: (_, _) =>
                    const AppSpacing(size: AppSpacingSize.xs),
                itemBuilder: (context, index) {
                  // Mostrar registros (do mais recente ao mais antigo)
                  final reversedIndex =
                      currentItem.historicoCompras.length - 1 - index;
                  final registro = currentItem.historicoCompras[reversedIndex];

                  return _RegistroCompraCard(
                    registro: registro,
                    isLoading: isLoading,
                    onEdit: () {
                      EditarRegistroCompraModal.show(
                        context,
                        lista: currentLista,
                        item: currentItem,
                        registroIndex: reversedIndex,
                        registro: registro,
                      );
                    },
                    onDelete: () async {
                      final confirmed = await AppConfirmationDialog.show<String>(
                        context: context,
                        title: 'Estornar Compra',
                        message:
                            'Deseja estornar a compra de '
                            '${_formatNum(registro.quantidade)} unidade(s). '
                            'realizada em ${DateFormatter.dma(registro.data)}?',
                        actions: const {
                          'cancel': 'Cancelar',
                          'confirm': 'Estornar',
                        },
                      );

                      if (confirmed == 'confirm' && context.mounted) {
                        _viewModel.removerRegistroCompraCommand.execute((
                          lista: currentLista,
                          itemId: currentItem.id,
                          registroIndex: reversedIndex,
                        ));
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RegistroCompraCard extends StatelessWidget {
  final RegistroCompra registro;
  final bool isLoading;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RegistroCompraCard({
    required this.registro,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatNum(double num) {
    return num % 1 == 0 ? num.toInt().toString() : num.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              AppText(
                DateFormatter.dma(registro.data),
                variant: AppTextVariant.caption,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              if (registro.supermercadoNome != null &&
                  registro.supermercadoNome!.isNotEmpty) ...[
                const SizedBox(width: 6),
                const AppText('•', variant: AppTextVariant.caption),
                const SizedBox(width: 6),
                Icon(
                  Icons.storefront_outlined,
                  size: 13,
                  color: AppColors.slate500,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: AppText(
                    registro.supermercadoNome!,
                    variant: AppTextVariant.caption,
                    color: AppColors.slate600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                'Qtd: ${_formatNum(registro.quantidade)} un.',
                variant: AppTextVariant.body,
                fontWeight: FontWeight.w600,
              ),
              if (registro.precoReal > 0) ...[
                const SizedBox(width: 6),
                AppText(
                  '(${UtilBrasilFields.obterReal(registro.precoReal, moeda: true)}/un)',
                  variant: AppTextVariant.caption,
                  color: AppColors.slate500,
                ),
              ],
              const Spacer(),
              if (registro.precoReal > 0) ...[
                AppText(
                  UtilBrasilFields.obterReal(registro.valorTotal, moeda: true),
                  variant: AppTextVariant.body,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald600,
                ),
                const SizedBox(width: 8),
              ],
              InkWell(
                onTap: isLoading ? null : onEdit,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Tooltip(
                    message: 'Editar compra',
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.slate600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: isLoading ? null : onDelete,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Tooltip(
                    message: 'Estornar compra',
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
