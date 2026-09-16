import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ItemCompraMarcarCompradoMenuItem extends PopupMenuItem<void> {
  ItemCompraMarcarCompradoMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required ItemCompra item,
    required ListaCompras lista,
  }) : super(
         height: 36,
         child: Row(
           children: [
             Icon(
               item.situacao == ItemCompraSituacao.comprado
                   ? Icons.remove_shopping_cart_outlined
                   : Icons.check_circle_outline,
               size: 16,
               color: item.situacao == ItemCompraSituacao.comprado
                   ? AppColors.slate600
                   : AppColors.emerald800,
             ),
             const SizedBox(width: 8),
             Text(
               item.situacao == ItemCompraSituacao.comprado
                   ? 'Desmarcar Compra'
                   : 'Marcar como Comprado',
               style: const TextStyle(
                 color: AppColors.slate700,
                 fontSize: 13,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ],
         ),
         onTap: () {
           Future.delayed(Duration.zero, () {
             if (!context.mounted) return;
             if (item.situacao == ItemCompraSituacao.cancelado) return;
             final novoStatus = item.situacao == ItemCompraSituacao.comprado
                 ? ItemCompraSituacao.pendente
                 : ItemCompraSituacao.comprado;
             ref
                 .read(listaComprasStatusViewModelProvider)
                 .alternarStatusItemCommand
                 .execute((
                   lista: lista,
                   itemId: item.id,
                   situacao: novoStatus,
                 ));
           });
         },
       );
}
