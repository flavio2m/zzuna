import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zzuna/ui/lancamentos/recorrencia/atualizar_sequencia/viewmodels/lancamentos_atualizar_sequencia_recorrencia_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosAtualizarSequenciaRecorrenciaModal
    extends ConsumerStatefulWidget {
  final String lancamentoId;
  final int sequenciaAtual;

  const LancamentosAtualizarSequenciaRecorrenciaModal({
    super.key,
    required this.lancamentoId,
    required this.sequenciaAtual,
  });

  static void show({
    required BuildContext context,
    required String lancamentoId,
    required int sequenciaAtual,
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosAtualizarSequenciaRecorrenciaModal(
        lancamentoId: lancamentoId,
        sequenciaAtual: sequenciaAtual,
      ),
    );
  }

  @override
  ConsumerState<LancamentosAtualizarSequenciaRecorrenciaModal> createState() =>
      _LancamentosAtualizarSequenciaRecorrenciaModalState();
}

class _LancamentosAtualizarSequenciaRecorrenciaModalState
    extends ConsumerState<LancamentosAtualizarSequenciaRecorrenciaModal> {
  final _formKey = GlobalKey<FormState>();
  final _saveFocus = FocusNode();
  final _sequenciaController = TextEditingController();

  late final LancamentosAtualizarSequenciaRecorrenciaViewModel _viewModel;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _sequenciaController.text = widget.sequenciaAtual.toString();
    _sequenciaController.addListener(_onControllerChanged);
    _viewModel = ref.read(
      lancamentosAtualizarSequenciaRecorrenciaViewModelProvider,
    );
    _viewModel.updateCommand.addListener(_commandListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _saveFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.updateCommand.removeListener(_commandListener);
    _sequenciaController.removeListener(_onControllerChanged);
    _sequenciaController.dispose();
    _saveFocus.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _canSubmit {
    final v = int.tryParse(_sequenciaController.text);
    return v != null && v > 0;
  }

  void _commandListener() {
    final result = _viewModel.updateCommand.value;

    result.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Sequência da recorrência atualizada com sucesso!',
        );
        Navigator.of(context).pop();
      }
    });

    result.onFailure((exception) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro desconhecido ao atualizar sequência.',
        );
      }
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isExecuting = true;
      });
      final novaSequencia = int.parse(_sequenciaController.text);
      _viewModel.updateCommand.execute((
        lancamentoId: widget.lancamentoId,
        novaSequencia: novaSequencia,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel.updateCommand,
      builder: (context, _) {
        final isRunning = _viewModel.updateCommand.value.isRunning;
        final isLoading = isRunning && _isExecuting;

        return AppForm(
          formKey: _formKey,
          title: 'Atualizar Sequência',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ButtonSave(
              focusNode: _saveFocus,
              loading: isLoading,
              onPressed: isLoading || !_canSubmit ? null : _handleSubmit,
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Isso mudará a sequência a partir deste mês e ajustará '
                'as próximas',
                style: TextStyle(fontSize: 14, color: AppColors.slate500),
              ),
              const SizedBox(height: 24),
              AppIntegerFormField(
                controller: _sequenciaController,
                label: 'Nova Sequência',
                min: 1,
                onFieldSubmitted: (_) {
                  if (_canSubmit) {
                    _handleSubmit();
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a nova sequência';
                  }
                  final v = int.tryParse(value);
                  if (v == null || v <= 0) {
                    return 'A sequência deve ser maior que zero';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
