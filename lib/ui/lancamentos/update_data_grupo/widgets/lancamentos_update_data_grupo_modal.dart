import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/shared/widgets/lancamento_update_data_base_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateDataGrupoModal extends ConsumerStatefulWidget {
  final String lancamentoId;
  final VoidCallback? onSuccess;

  const LancamentosUpdateDataGrupoModal({
    super.key,
    required this.lancamentoId,
    this.onSuccess,
  });

  static void show({
    required BuildContext context,
    required String lancamentoId,
    VoidCallback? onSuccess,
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosUpdateDataGrupoModal(
        lancamentoId: lancamentoId,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateDataGrupoModal> createState() =>
      _LancamentosUpdateDataGrupoModalState();
}

class _LancamentosUpdateDataGrupoModalState
    extends ConsumerState<LancamentosUpdateDataGrupoModal> {
  bool _isExecuting = false;

  late final _viewModel = ref.read(lancamentosUpdateDataGrupoViewModelProvider);

  @override
  void initState() {
    super.initState();
    _viewModel.updateDataGrupoCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    _viewModel.updateDataGrupoCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.updateDataGrupoCommand.value;
    commandValue.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Data dos lançamentos do grupo alterada com sucesso',
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
    _viewModel.updateDataGrupoCommand.execute((
      lancamentoId: widget.lancamentoId,
      novaData: selectedData,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel.updateDataGrupoCommand,
      builder: (context, _) {
        final isRunning = _viewModel.updateDataGrupoCommand.value.isRunning;
        final isLoading = isRunning && _isExecuting;

        return LancamentoUpdateDataBaseModal(
          title: 'Alterar Data em Lote',
          description: 'Escolha a nova data para os lançamentos do grupo:',
          isExecuting: isLoading,
          onSave: _handleSave,
        );
      },
    );
  }
}
