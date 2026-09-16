import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/lista_compras/create/item_compra/widgets/clone_item_compra_button.dart';
import 'package:zzuna/ui/lista_compras/delete/item_compra/widgets/item_compra_delete_menu_item.dart';
import 'package:zzuna/ui/lista_compras/update/cancelar/widgets/item_compra_status_menu_item.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/widgets/comprar_item_modal.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/widgets/item_compra_comprar_menu_item.dart';
import 'package:zzuna/ui/lista_compras/update/editar/widgets/item_compra_editar_menu_item.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';

class ItemCompraCard extends ConsumerWidget {
  final ItemCompra item;
  final ListaCompras lista;

  const ItemCompraCard({super.key, required this.item, required this.lista});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusVm = ref.watch(listaComprasStatusViewModelProvider);
    final deleteVm = ref.watch(listaComprasDeleteViewModelProvider);
    final isRunning =
        statusVm.alternarStatusItemCommand.value.isRunning ||
        deleteVm.removerItemCommand.value.isRunning;

    final isComprado = item.situacao == ItemCompraSituacao.comprado;
    final isCancelado = item.situacao == ItemCompraSituacao.cancelado;
    final isParcial =
        !isComprado && !isCancelado && item.quantidadeComprada > 0;

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
                          ComprarItemModal.show(
                            context,
                            item: item,
                            lista: lista,
                          );
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
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        if (isCancelado) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.slate500.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'CANCELADO',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.slate500,
                                fontWeight: FontWeight.bold,
                              ),
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
                            color: isParcial
                                ? Colors.orange.shade800
                                : AppColors.slate500,
                            fontWeight: isParcial
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          'Estimado: $precoFormatado',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.slate500,
                          ),
                        ),
                        if (ultimoSupermercado != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.storefront,
                                size: 12,
                                color: AppColors.indigo600,
                              ),
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
                    if (item.observacao.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Obs: ${item.observacao.trim()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppColors.slate500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Clone Button & Action Menu Popup
              CloneItemCompraButton(item: item),
              const SizedBox(width: 4),
              PopupMenuButton<void>(
                enabled: !isRunning,
                tooltip: 'Ações',
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.slate600,
                  size: 20,
                ),
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.border),
                ),
                elevation: 3,
                onSelected: (_) {},
                itemBuilder: (ctx) => [
                  if (item.situacao == ItemCompraSituacao.pendente)
                    ItemCompraComprarMenuItem(
                      context: context,
                      item: item,
                      lista: lista,
                    ),
                  ItemCompraEditarMenuItem(context: context, item: item),
                  ItemCompraStatusMenuItem(
                    context: context,
                    ref: ref,
                    item: item,
                    lista: lista,
                  ),
                  if (item.situacao != ItemCompraSituacao.comprado)
                    ItemCompraDeleteMenuItem(
                      context: context,
                      ref: ref,
                      item: item,
                      lista: lista,
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
      return const Icon(
        Icons.check_circle,
        color: AppColors.emerald800,
        size: 24,
      );
    }
    if (isCancelado) {
      return const Icon(Icons.block, color: AppColors.slate500, size: 24);
    }
    if (isParcial) {
      return Icon(Icons.timelapse, color: Colors.orange.shade800, size: 24);
    }
    return const Icon(
      Icons.radio_button_unchecked,
      color: AppColors.slate500,
      size: 24,
    );
  }

  String _formatQtd(double val) {
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    return val.toString();
  }
}
