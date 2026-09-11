import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ClonarListaAnteriorButton extends ConsumerWidget {
  final bool iconOnly;

  const ClonarListaAnteriorButton({super.key, this.iconOnly = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(listaComprasFilterProvider);
    final duplicarVm = ref.watch(listaComprasDuplicarViewModelProvider);
    final createVm = ref.watch(listaComprasCreateViewModelProvider);

    final isCreating = createVm.criarListaVaziaCommand.value.isRunning;
    final isCloningAnterior =
        duplicarVm.duplicarListaAnteriorCommand.value.isRunning;

    ref.listen(
      listaComprasDuplicarViewModelProvider.select(
        (vm) => vm.duplicarListaAnteriorCommand.value,
      ),
      (previous, next) {
        next.onSuccess((_) {
          AppSnackBar.showSuccess(
            context,
            'Lista clonada a partir do mês anterior com sucesso!',
          );
        });
        next.onFailure((exception) {
          AppSnackBar.showError(
            context,
            exception?.toString() ?? 'Nenhuma lista anterior encontrada.',
          );
        });
      },
    );

    if (iconOnly) {
      return IconButton(
        icon: isCloningAnterior
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.content_copy_rounded, size: 20),
        color: AppColors.indigo600,
        tooltip: 'Clonar Lista Anterior',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 20,
        onPressed: (isCloningAnterior || isCreating)
            ? null
            : () {
                duplicarVm.duplicarListaAnteriorCommand.execute((
                  anoDestino: filterState.ano,
                  mesDestino: filterState.mes,
                ));
              },
      );
    }

    return ButtonAdd(
      label: 'Clonar Lista Anterior',
      icon: Icons.content_copy_rounded,
      color: AppColors.indigo600,
      loading: isCloningAnterior,
      onPressed: (isCloningAnterior || isCreating)
          ? () {}
          : () {
              duplicarVm.duplicarListaAnteriorCommand.execute((
                anoDestino: filterState.ano,
                mesDestino: filterState.mes,
              ));
            },
    );
  }
}
