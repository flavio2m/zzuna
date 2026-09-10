import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ItemCompraStatusMenuItem extends PopupMenuItem<void> {
  ItemCompraStatusMenuItem({
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
               item.situacao == ItemCompraSituacao.cancelado
                   ? Icons.refresh_outlined
                   : Icons.block_outlined,
               size: 16,
               color: AppColors.slate600,
             ),
             const SizedBox(width: 8),
             Text(
               item.situacao == ItemCompraSituacao.cancelado
                   ? 'Reativar Item'
                   : 'Cancelar Item',
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
             final novoStatus = item.situacao == ItemCompraSituacao.cancelado
                 ? ItemCompraSituacao.pendente
                 : ItemCompraSituacao.cancelado;
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
