import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/ui/lista_compras/create/widgets/item_compra_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ItemCompraEditarMenuItem extends PopupMenuItem<void> {
  ItemCompraEditarMenuItem({
    super.key,
    required BuildContext context,
    required ItemCompra item,
  }) : super(
          height: 36,
          child: const Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.slate600,
              ),
              SizedBox(width: 8),
              Text(
                'Editar Produto',
                style: TextStyle(
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
              ItemCompraModal.show(context, item: item);
            });
          },
        );
}
