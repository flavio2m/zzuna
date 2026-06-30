import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/update_lancamentos_metadata_dto.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_area_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateMetadataModal extends ConsumerStatefulWidget {
  final String lancamentoId;
  final String currentDescricao;
  final String? currentObservacao;
  final VoidCallback? onSuccess;

  const LancamentosUpdateMetadataModal({
    super.key,
    required this.lancamentoId,
    required this.currentDescricao,
    this.currentObservacao,
    this.onSuccess,
  });

  static void show({
    required BuildContext context,
    required String lancamentoId,
    required String currentDescricao,
    String? currentObservacao,
    VoidCallback? onSuccess,
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosUpdateMetadataModal(
        lancamentoId: lancamentoId,
        currentDescricao: currentDescricao,
        currentObservacao: currentObservacao,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateMetadataModal> createState() =>
      _LancamentosUpdateMetadataModalState();
}

class _LancamentosUpdateMetadataModalState
    extends ConsumerState<LancamentosUpdateMetadataModal> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _observacaoController = TextEditingController();
  bool _isExecuting = false;

  late final _viewModel = ref.read(lancamentoUpdateMetadataViewModelProvider);

  @override
  void initState() {
    super.initState();
    _viewModel.updateMetadataCommand.addListener(_commandListener);
    _descricaoController.text = widget.currentDescricao;
    _observacaoController.text = widget.currentObservacao ?? '';
  }

  @override
  void dispose() {
    _viewModel.updateMetadataCommand.removeListener(_commandListener);
    _descricaoController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.updateMetadataCommand.value;
    commandValue.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Dados dos lançamentos alterados com sucesso',
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

  void _handleSubmit() {
    final desc = _descricaoController.text.trim();
    final obs = _observacaoController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isExecuting = true;
      });
      _viewModel.updateMetadataCommand.execute(
        UpdateLancamentosMetadataDto(
          id: widget.lancamentoId,
          descricao: desc,
          observacao: obs.isEmpty ? null : obs,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AppForm(
        title: 'Alterar Descrição / Observação',
        type: AppFormType.modal,
        actions: [
          ButtonCancel(onPressed: () => Navigator.of(context).pop()),
          ListenableBuilder(
            listenable: _viewModel.updateMetadataCommand,
            builder: (context, _) {
              final isRunning =
                  _viewModel.updateMetadataCommand.value.isRunning;
              final isLoading = isRunning && _isExecuting;

              return ButtonSave(
                loading: isLoading,
                onPressed: isRunning ? null : _handleSubmit,
              );
            },
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ajuste os dados para alterar a descrição/observação deste '
              'lançamento e dos posteriores do grupo:',
              style: TextStyle(fontSize: 14, color: AppColors.slate600),
            ),
            const AppSpacing(size: AppSpacingSize.md),
            AppTextFormField(
              label: 'Nova Descrição',
              controller: _descricaoController,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Descrição é obrigatória';
                }
                if (v.trim().length < 3) {
                  return 'Mínimo de 3 caracteres';
                }
                return null;
              },
            ),
            const AppSpacing(size: AppSpacingSize.md),
            AppTextAreaFormField(
              label: 'Nova Observação',
              controller: _observacaoController,
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
