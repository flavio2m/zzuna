import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_conciliado_button.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosReconcileButton extends ConsumerStatefulWidget {
  final bool conciliado;
  final List<String> selectedIds;
  final VoidCallback? onSuccess;

  const LancamentosReconcileButton({
    super.key,
    required this.conciliado,
    required this.selectedIds,
    this.onSuccess,
  });

  @override
  ConsumerState<LancamentosReconcileButton> createState() =>
      _LancamentosReconcileButtonState();
}

class _LancamentosReconcileButtonState
    extends ConsumerState<LancamentosReconcileButton> {
  bool _isExecuting = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(lancamentoReconcileViewModelProvider);

    ref.listen(
      //
      lancamentoReconcileViewModelProvider.select(
        (vm) => vm.reconcileCommand.value,
      ),
      (previous, next) {
        if (next.isSuccess && _isExecuting) {
          _isExecuting = false;
          widget.onSuccess?.call();
        } else if (next.isFailure && _isExecuting) {
          _isExecuting = false;
          final errorMessage = //
              next.getExceptionOrNull()?.toString() ??
              'Erro ao conciliar lançamentos';
          AppSnackBar.showError(context, errorMessage);
        }
      },
    );

    return ListenableBuilder(
      listenable: viewModel.reconcileCommand,
      builder: (context, _) {
        final isRunning = viewModel.reconcileCommand.value.isRunning;
        if (!isRunning) {
          _isExecuting = false;
        }
        final isLoading = isRunning && _isExecuting;

        return IconConciliadoButton(
          conciliado: widget.conciliado,
          size: 20,
          tooltip: //
          widget.conciliado
              ? 'Conciliar selecionados'
              : 'Desconciliar selecionados',
          loading: isLoading,
          onPressed: isRunning || widget.selectedIds.isEmpty
              ? null
              : () {
                  _isExecuting = true;
                  viewModel //
                      .reconcileCommand
                      .execute((
                        ids: widget.selectedIds,
                        conciliado: widget.conciliado,
                      ));
                },
        );
      },
    );
  }
}
