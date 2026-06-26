import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateDataModal extends ConsumerStatefulWidget {
  final List<String> selectedIds;
  final VoidCallback? onSuccess;

  const LancamentosUpdateDataModal({
    super.key,
    required this.selectedIds,
    this.onSuccess, //
  });

  static void show({
    required BuildContext context,
    required List<String> selectedIds,
    VoidCallback? onSuccess, //
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosUpdateDataModal(
        selectedIds: selectedIds,
        onSuccess: onSuccess, //
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateDataModal> createState() => _LancamentosUpdateDataModalState();
}

class _LancamentosUpdateDataModalState extends ConsumerState<LancamentosUpdateDataModal> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedData = DateTime.now();
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
          'Data dos lançamentos alterada com sucesso', //
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

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isExecuting = true;
      });
      _viewModel //
          .updateDataCommand
          .execute((ids: widget.selectedIds, novaData: _selectedData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AppForm(
        title: 'Alterar Data',
        type: AppFormType.modal,
        // actionsSize: AppFormActionsSize.intrinsic,
        actions: [
          ButtonCancel(
            onPressed: () => Navigator.of(context).pop(), //
          ),
          ListenableBuilder(
            listenable: _viewModel.updateDataCommand,
            builder: (context, _) {
              final isRunning = _viewModel.updateDataCommand.value.isRunning;
              final isLoading = isRunning && _isExecuting;

              return ButtonSave(
                loading: isLoading,
                onPressed: isRunning ? null : _handleSubmit, //
              );
            },
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Escolha a nova data para os lançamentos selecionados:',
              style: TextStyle(fontSize: 14, color: AppColors.slate600),
            ),
            const AppSpacing(size: AppSpacingSize.md),
            AppDateFormField(
              label: 'Nova Data',
              initialValue: _formatDate(_selectedData),
              onDateSelected: (date) {
                setState(() {
                  _selectedData = date;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
