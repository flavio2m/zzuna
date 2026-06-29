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
  final List<String> selectedIds;
  final VoidCallback? onSuccess;

  const LancamentosUpdateMetadataModal({
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
      child: LancamentosUpdateMetadataModal(
        selectedIds: selectedIds,
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

    if (desc.isEmpty && obs.isEmpty) {
      AppSnackBar.showWarning(
        context,
        'Informe ao menos um campo para alteração.',
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isExecuting = true;
      });
      _viewModel.updateMetadataCommand.execute(
        UpdateLancamentosMetadataDto(
          ids: widget.selectedIds,
          descricao: desc.isEmpty ? null : desc,
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
          ButtonCancel(
            onPressed: () => Navigator.of(context).pop(),
          ),
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
              'Preencha apenas os campos que deseja alterar nos lançamentos selecionados:',
              style: TextStyle(fontSize: 14, color: AppColors.slate600),
            ),
            const AppSpacing(size: AppSpacingSize.md),
            AppTextFormField(
              label: 'Nova Descrição',
              controller: _descricaoController,
              validator: (v) {
                if (v != null && v.trim().isNotEmpty && v.trim().length < 3) {
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
