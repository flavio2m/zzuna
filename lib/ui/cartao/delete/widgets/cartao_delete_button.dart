import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_delete.dart';

class CartaoDeleteButton extends ConsumerWidget {
  final String cartaoId;
  final String cartaoDescricao;

  const CartaoDeleteButton({
    super.key,
    required this.cartaoId,
    required this.cartaoDescricao,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cartaoDeleteViewModelProvider);

    return ButtonDelete(
      onPressed: () async {
        final confirm = await AppConfirmationDialog.show(
          context,
          title: 'Excluir Cartão',
          message: 'Deseja realmente excluir o cartão "$cartaoDescricao"?',
        );

        if (confirm == 'confirm') {
          viewModel.deleteCommand.execute(cartaoId);
        }
      },
    );
  }
}
