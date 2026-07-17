// lib/ui/centro_custo/create/widgets/centro_custo_create_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/validators/centro_custo_validator.dart';
import 'package:zzuna/ui/centro_custo/create/viewmodels/centro_custo_create_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

/// Modal para criação de um Centro de Custo.
class CentroCustoCreateModal extends ConsumerStatefulWidget {
  const CentroCustoCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const CentroCustoCreateModal());
  }

  @override
  ConsumerState<CentroCustoCreateModal> createState() =>
      _CentroCustoCreateModalState();
}

class _CentroCustoCreateModalState
    extends ConsumerState<CentroCustoCreateModal> {
  final dto = CentroCustoDto();
  final validator = CentroCustoValidator<CentroCustoDto>();
  late final CentroCustoCreateViewModel viewModel;

  final _descFocus = FocusNode();
  final _ativoFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(centroCustoCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);

    _descFocus.dispose();
    _ativoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;
    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Centro de Custo criado com sucesso.');
      Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit => validator.validate(dto).isValid;

  void _handleSubmit() {
    if (_canSubmit) {
      viewModel.createCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(centroCustoCreateViewModelProvider);
    return AppForm(
      title: 'Novo Centro de Custo',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: vm.createCommand,
          builder: (context, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              loading: vm.createCommand.value.isRunning,
              onPressed: vm.createCommand.value.isRunning || !_canSubmit
                  ? null
                  : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFormField(
            label: 'Descrição',
            autofocus: true,
            focusNode: _descFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _ativoFocus.requestFocus(),
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'descricao'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppSwitchField(
            label: 'Ativo',
            focusNode: _ativoFocus,
            onEnterPressed: () => _saveFocus.requestFocus(),
            value: dto.ativo,
            onChanged: (value) {
              dto.setAtivo(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
