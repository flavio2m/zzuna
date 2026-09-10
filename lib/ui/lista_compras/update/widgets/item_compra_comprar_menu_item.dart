import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/lista_compras/update/widgets/comprar_item_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ItemCompraComprarMenuItem extends PopupMenuItem<void> {
  ItemCompraComprarMenuItem({
    super.key,
    required BuildContext context,
    required ItemCompra item,
    required ListaCompras lista,
  }) : super(
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.shopping_cart_outlined,
               size: 16,
               color: AppColors.slate600,
             ),
             const SizedBox(width: 8),
             Text(
               item.situacao == ItemCompraSituacao.comprado
                   ? 'Editar Compra'
                   : 'Comprar Item',
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
             ComprarItemModal.show(context, item: item, lista: lista);
           });
         },
       );
}
