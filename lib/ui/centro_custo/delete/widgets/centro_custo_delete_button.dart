// lib/ui/centro_custo/delete/widgets/centro_custo_delete_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_excluir_button.dart';

class CentroCustoDeleteButton extends ConsumerWidget {
  final String centroCustoId;
  final String centroCustoDescricao;

  const CentroCustoDeleteButton({
    required this.centroCustoId,
    required this.centroCustoDescricao,
    super.key, //
  });

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await AppConfirmationDialog.show(
      context: context,
      title: 'Excluir Centro de Custo',
      message: 'Deseja realmente excluir o centro de custo "$centroCustoDescricao"?',
    );

    if (confirm == 'confirm') {
      ref //
          .read(centroCustoDeleteViewModelProvider)
          .deleteCommand
          .execute(centroCustoId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(centroCustoDeleteViewModelProvider);
    return IconExcluirButton(
      onPressed:
          viewModel
              .deleteCommand
              .value
              .isRunning //
          ? null
          : () => _handleDelete(context, ref),
    );
  }
}
