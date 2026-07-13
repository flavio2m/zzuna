import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_origem_grupo/viewmodels/lancamentos_update_origem_grupo_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/shared/widgets/lancamentos_update_origem_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateOrigemGrupoModal extends ConsumerStatefulWidget {
  final String lancamentoId;
  final LancamentoOrigem currentOrigem;
  final VoidCallback? onSuccess;

  const LancamentosUpdateOrigemGrupoModal({
    super.key,
    required this.lancamentoId,
    required this.currentOrigem,
    this.onSuccess,
  });

  static void show({
    required BuildContext context,
    required String lancamentoId,
    required LancamentoOrigem currentOrigem,
    VoidCallback? onSuccess,
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosUpdateOrigemGrupoModal(
        lancamentoId: lancamentoId,
        currentOrigem: currentOrigem,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateOrigemGrupoModal> createState() =>
      _LancamentosUpdateOrigemGrupoModalState();
}

class _LancamentosUpdateOrigemGrupoModalState
    extends ConsumerState<LancamentosUpdateOrigemGrupoModal> {
  late final LancamentosUpdateOrigemGrupoViewModel _viewModel;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(lancamentosUpdateOrigemGrupoViewModelProvider);
    _viewModel.updateOrigemGrupoCommand.addListener(_commandListener);
    Future(() {
      _viewModel.load();
    });
  }

  @override
  void dispose() {
    _viewModel.updateOrigemGrupoCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.updateOrigemGrupoCommand.value;

    commandValue.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Conta/Cartão dos lançamentos do grupo alterados com sucesso',
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
    _viewModel.updateOrigemGrupoCommand.execute((
      lancamentoId: widget.lancamentoId,
      novaOrigem: novaOrigem,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isRunning = _viewModel.updateOrigemGrupoCommand.value.isRunning;
        final isLoading = isRunning && _isExecuting;

        return LancamentosUpdateOrigemDialog(
          title: 'Alterar Conta/Cartão do Grupo',
          subtitle:
              'Escolha a nova conta ou cartão para os lançamentos do grupo a '
              'partir deste mês:',
          origens: _viewModel.origens,
          initialOrigem: widget.currentOrigem,
          isLoading: isLoading,
          onSave: _handleSubmit,
        );
      },
    );
  }
}
