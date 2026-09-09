import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/lista_compras/create/widgets/item_compra_modal.dart';
import 'package:zzuna/ui/lista_compras/update/widgets/comprar_item_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';

class ItemCompraCard extends ConsumerWidget {
  final ItemCompra item;
  final ListaCompras lista;

  const ItemCompraCard({
    super.key,
    required this.item,
    required this.lista,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusVm = ref.watch(listaComprasStatusViewModelProvider);
    final deleteVm = ref.watch(listaComprasDeleteViewModelProvider);
    final isRunning = statusVm.alternarStatusItemCommand.value.isRunning ||
        deleteVm.removerItemCommand.value.isRunning;

    final isComprado = item.situacao == ItemCompraSituacao.comprado;
    final isCancelado = item.situacao == ItemCompraSituacao.cancelado;
    final isParcial = !isComprado && !isCancelado && item.quantidadeComprada > 0;

    final ultimoSupermercado = item.supermercados
        .where((s) => s.ultimoUtilizado)
        .firstOrNull;

    final String precoFormatado = UtilBrasilFields.obterReal(
      item.precoEstimado,
      moeda: true,
    );

    return Opacity(
      opacity: isCancelado ? 0.55 : 1.0,
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Checkbox / Status Icon / Loading
              IconButton(
                icon: isRunning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _buildStatusIcon(isComprado, isCancelado, isParcial),
                onPressed: isRunning
                    ? null
                    : () {
                        if (isComprado || isCancelado) {
                          statusVm.alternarStatusItemCommand.execute((
                            lista: lista,
                            itemId: item.id,
                            situacao: ItemCompraSituacao.pendente,
                          ));
                        } else {
                          ComprarItemModal.show(context, item: item, lista: lista);
                        }
                      },
              ),
              const SizedBox(width: 8),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.produto,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: (isComprado || isCancelado)
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCancelado
                                  ? AppColors.slate500
                                  : Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        if (isCancelado) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.slate500.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'CANCELADO',
                              style: TextStyle(fontSize: 10, color: AppColors.slate500, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Qtd: ${_formatQtd(item.quantidadeComprada)} / ${_formatQtd(item.quantidadePlanejada)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isParcial ? Colors.orange.shade800 : AppColors.slate500,
                            fontWeight: isParcial ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          'Estimado: $precoFormatado',
                          style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                        ),
                        if (ultimoSupermercado != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.storefront, size: 12, color: AppColors.indigo600),
                              const SizedBox(width: 2),
                              Text(
                                ultimoSupermercado.nome,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.indigo600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Menu Popup
              PopupMenuButton<String>(
                enabled: !isRunning,
                icon: const Icon(Icons.more_vert, color: AppColors.slate500),
                onSelected: (action) async {
                  switch (action) {
                    case 'comprar':
                      ComprarItemModal.show(context, item: item, lista: lista);
                      break;
                    case 'editar':
                      ItemCompraModal.show(context, item);
                      break;
                    case 'cancelar':
                      final novoStatus = isCancelado
                          ? ItemCompraSituacao.pendente
                          : ItemCompraSituacao.cancelado;
                      statusVm.alternarStatusItemCommand.execute((
                        lista: lista,
                        itemId: item.id,
                        situacao: novoStatus,
                      ));
                      break;
                    case 'excluir':
                      _confirmarExclusao(context, ref);
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'comprar',
                    child: Row(
                      children: [
                        Icon(Icons.shopping_cart_checkout, color: Colors.green.shade700, size: 18),
                        const SizedBox(width: 8),
                        Text(isComprado ? 'Editar Compra' : 'Comprar Item'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppColors.indigo600, size: 18),
                        SizedBox(width: 8),
                        Text('Editar Produto'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'cancelar',
                    child: Row(
                      children: [
                        Icon(
                          isCancelado ? Icons.refresh : Icons.block,
                          color: Colors.orange.shade800,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(isCancelado ? 'Reativar Item' : 'Cancelar Item'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.danger, size: 18),
                        SizedBox(width: 8),
                        Text('Excluir do Mês', style: TextStyle(color: AppColors.danger)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(bool isComprado, bool isCancelado, bool isParcial) {
    if (isComprado) {
      return const Icon(Icons.check_circle, color: AppColors.emerald800, size: 24);
    }
    if (isCancelado) {
      return const Icon(Icons.block, color: AppColors.slate500, size: 24);
    }
    if (isParcial) {
      return Icon(Icons.timelapse, color: Colors.orange.shade800, size: 24);
    }
    return const Icon(Icons.radio_button_unchecked, color: AppColors.slate500, size: 24);
  }

  String _formatQtd(double val) {
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    return val.toString();
  }

  void _confirmarExclusao(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Produto'),
        content: Text('Deseja remover "${item.produto}" definitivamente desta lista?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Excluir', style: TextStyle(color: AppColors.danger)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(listaComprasDeleteViewModelProvider).removerItemCommand.execute((
                lista: lista,
                itemId: item.id,
              ));
            },
          ),
        ],
      ),
    );
  }
}
