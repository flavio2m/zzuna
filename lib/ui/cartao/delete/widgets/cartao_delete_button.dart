import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_delete.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_excluir_button.dart';

class CartaoDeleteButton extends ConsumerWidget {
  final String cartaoId;
  final String cartaoDescricao;

  const CartaoDeleteButton({super.key, required this.cartaoId, required this.cartaoDescricao});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await AppConfirmationDialog.show(
      context: context,
      title: 'Excluir Cartão',
      message: 'Deseja realmente excluir o cartão "$cartaoDescricao"?',
    );

    if (confirm == 'confirm') {
      ref.read(cartaoDeleteViewModelProvider).deleteCommand.execute(cartaoId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cartaoDeleteViewModelProvider);

    return ListenableBuilder(
      listenable: viewModel.deleteCommand,
      builder: (_, __) {
        return IconExcluirButton(
          onPressed: //
          viewModel.deleteCommand.value.isRunning
              ? null
              : () => _handleDelete(context, ref),
        );
      },
    );
  }
}
