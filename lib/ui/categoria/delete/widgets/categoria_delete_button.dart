import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_excluir_button.dart';

class CategoriaDeleteButton extends ConsumerWidget {
  final String categoriaId;
  final String categoriaDescricao;

  const CategoriaDeleteButton({super.key, required this.categoriaId, required this.categoriaDescricao});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await AppConfirmationDialog.show(
      context: context,
      title: 'Excluir Categoria',
      message: 'Deseja realmente excluir a categoria "$categoriaDescricao"?',
    );

    if (confirm == 'confirm') {
      ref.read(categoriaDeleteViewModelProvider).deleteCommand.execute(categoriaId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(categoriaDeleteViewModelProvider);

    return ListenableBuilder(
      listenable: viewModel.deleteCommand,
      builder: (_, _) {
        return IconExcluirButton(
          onPressed: viewModel.deleteCommand.value.isRunning
              ? null
              : () => _handleDelete(context, ref),
        );
      },
    );
  }
}
