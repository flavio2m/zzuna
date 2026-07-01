import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/shared/widgets/lancamento_update_data_base_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateDataModal extends ConsumerStatefulWidget {
  final List<String> selectedIds;
  final VoidCallback? onSuccess;

  const LancamentosUpdateDataModal({
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
      child: LancamentosUpdateDataModal(
        selectedIds: selectedIds,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateDataModal> createState() =>
      _LancamentosUpdateDataModalState();
}

class _LancamentosUpdateDataModalState
    extends ConsumerState<LancamentosUpdateDataModal> {
  bool _isExecuting = false;

  late final _viewModel = ref.read(lancamentoUpdateDataViewModelProvider);

  @override
  void initState() {
    super.initState();
    _viewModel.updateDataCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    _viewModel.updateDataCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.updateDataCommand.value;
    commandValue.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Data dos lançamentos alterada com sucesso',
        );
        widget.onSuccess?.call();
        Navigator.of(context).pop();
      }
    });

    commandValue.onFailure((exception) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showError(context, exception.toString());
      }
    });
  }

  void _handleSave(DateTime selectedData) {
    setState(() {
      _isExecuting = true;
    });
    _viewModel.updateDataCommand.execute((
      ids: widget.selectedIds,
      novaData: selectedData,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel.updateDataCommand,
      builder: (context, _) {
        final isRunning = _viewModel.updateDataCommand.value.isRunning;
        final isLoading = isRunning && _isExecuting;

        return LancamentoUpdateDataBaseModal(
          title: 'Alterar Data',
          description: 'Escolha a nova data para os lançamentos selecionados:',
          isExecuting: isLoading,
          onSave: _handleSave,
        );
      },
    );
  }
}
