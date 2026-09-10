import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ItemCompraDeleteMenuItem extends PopupMenuItem<void> {
  ItemCompraDeleteMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required ItemCompra item,
    required ListaCompras lista,
  }) : super(
          height: 36,
          child: const Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 16,
                color: AppColors.danger,
              ),
              SizedBox(width: 8),
              Text(
                'Excluir do Mês',
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              if (!context.mounted) return;
              _showDeleteDialog(context, ref, item, lista);
            });
          },
        );

  static Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    ItemCompra item,
    ListaCompras lista,
  ) async {
    final result = await AppConfirmationDialog.show<String>(
      context: context,
      title: 'Excluir Produto',
      message: 'Deseja remover "${item.produto}" definitivamente desta lista?',
      actions: const {
        'cancel': 'Cancelar',
        'confirm': 'Excluir',
      },
    );

    if (result == 'confirm') {
      ref
          .read(listaComprasDeleteViewModelProvider)
          .removerItemCommand
          .execute((lista: lista, itemId: item.id));
    }
  }
}
