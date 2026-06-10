import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_excluir_button.dart';

class ContaDeleteButton extends ConsumerWidget {
  final String contaId;
  final String descricao;

  const ContaDeleteButton({
    super.key,
    required this.contaId,
    required this.descricao, //
  });

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await AppConfirmationDialog.show(
      context: context,
      title: 'Excluir Conta',
      message: 'Deseja realmente excluir a conta "$descricao"?',
    );

    if (confirm == 'confirm') {
      ref.read(contaDeleteViewModelProvider).deleteCommand.execute(contaId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(contaDeleteViewModelProvider);

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
