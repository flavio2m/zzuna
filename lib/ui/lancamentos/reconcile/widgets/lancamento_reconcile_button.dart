import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_conciliado_button.dart';

class LancamentoReconcileButton extends ConsumerStatefulWidget {
  final String lancamentoId;
  final bool conciliado;

  const LancamentoReconcileButton({super.key, required this.lancamentoId, required this.conciliado});

  @override
  ConsumerState<LancamentoReconcileButton> createState() => _LancamentoReconcileButtonState();
}

class _LancamentoReconcileButtonState extends ConsumerState<LancamentoReconcileButton> {
  bool _isExecuting = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(lancamentoReconcileViewModelProvider);

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
          loading: isLoading,
          onPressed: isRunning
              ? null
              : () {
                  _isExecuting = true;
                  viewModel //
                      .reconcileCommand
                      .execute((ids: [widget.lancamentoId], conciliado: !widget.conciliado));
                },
        );
      },
    );
  }
}
