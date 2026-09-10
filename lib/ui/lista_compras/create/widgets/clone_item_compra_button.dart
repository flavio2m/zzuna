import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/ui/lista_compras/create/widgets/item_compra_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class CloneItemCompraButton extends StatelessWidget {
  final ItemCompra item;

  const CloneItemCompraButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 18, color: AppColors.slate600),
      tooltip: 'Clonar Item',
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(4),
      onPressed: () {
        ItemCompraModal.show(context, cloneItem: item);
      },
    );
  }
}
