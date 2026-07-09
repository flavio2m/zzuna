import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_origem/viewmodels/lancamentos_update_origem_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/shared/widgets/lancamentos_update_origem_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateOrigemModal extends ConsumerStatefulWidget {
  final List<String> selectedIds;
  final VoidCallback? onSuccess;

  const LancamentosUpdateOrigemModal({
    super.key,
    required this.selectedIds,
    this.onSuccess,
  });

  static void show({
    required BuildContext context,
    required List<String> selectedIds,
    VoidCallback? onSuccess,
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosUpdateOrigemModal(
        selectedIds: selectedIds,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateOrigemModal> createState() =>
      _LancamentosUpdateOrigemModalState();
}

class _LancamentosUpdateOrigemModalState
    extends ConsumerState<LancamentosUpdateOrigemModal> {
  late final LancamentosUpdateOrigemViewModel _viewModel;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(lancamentosUpdateOrigemViewModelProvider);
    _viewModel.updateOrigemSelectedCommand.addListener(_commandListener);
    Future(() {
      _viewModel.load();
    });
  }

  @override
  void dispose() {
    _viewModel.updateOrigemSelectedCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.updateOrigemSelectedCommand.value;

    commandValue.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Conta/Cartão dos lançamentos alterados com sucesso',
        );
        widget.onSuccess?.call();
        Navigator.pop(context);
      }
    });

    commandValue.onFailure((exception) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showError(context, exception.toString());
      }
    });
  }

  void _handleSubmit(LancamentoOrigem novaOrigem) {
    setState(() {
      _isExecuting = true;
    });
    _viewModel.updateOrigemSelectedCommand.execute((
      lancamentoIds: widget.selectedIds,
      novaOrigem: novaOrigem,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isRunning =
            _viewModel.updateOrigemSelectedCommand.value.isRunning;
        final isLoading = isRunning && _isExecuting;

        return LancamentosUpdateOrigemDialog(
          title: 'Alterar Conta/Cartão',
          subtitle:
              'Escolha a nova conta ou cartão para os lançamentos selecionados:',
          origens: _viewModel.origens,
          initialOrigem: const LancamentoOrigem.conta(contaId: ''),
          isLoading: isLoading,
          onSave: _handleSubmit,
        );
      },
    );
  }
}
