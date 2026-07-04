// lib/ui/centro_custo/update/widgets/centro_custo_update_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/validators/centro_custo_validator.dart';
import 'package:zzuna/ui/centro_custo/update/viewmodels/centro_custo_update_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

/// Modal para edição de um Centro de Custo.
class CentroCustoUpdateModal extends ConsumerStatefulWidget {
  final CentroCustoDto centroCusto;

  const CentroCustoUpdateModal({super.key, required this.centroCusto});

  static void show(BuildContext context, CentroCustoDto centroCusto) {
    AppDialog.show(
      context: context,
      child: CentroCustoUpdateModal(centroCusto: centroCusto),
    );
  }

  @override
  ConsumerState<CentroCustoUpdateModal> createState() =>
      _CentroCustoUpdateModalState();
}

class _CentroCustoUpdateModalState
    extends ConsumerState<CentroCustoUpdateModal> {
  late final CentroCustoDto dto;
  final validator = CentroCustoValidator<CentroCustoDto>();
  late final CentroCustoUpdateViewModel viewModel;

  @override
  void initState() {
    super.initState();
    // Copia os valores do DTO recebido para um novo DTO editável.
    dto = CentroCustoDto(
      id: widget.centroCusto.id,
      descricao: widget.centroCusto.descricao,
      ativo: widget.centroCusto.ativo,
    );
    viewModel = ref.read(centroCustoUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.updateCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateCommand.value;
    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(
        context,
        'Centro de Custo atualizado com sucesso.',
      );
      Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit => validator.validate(dto).isValid;

  void _handleSubmit() {
    if (_canSubmit) {
      viewModel.updateCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(centroCustoUpdateViewModelProvider);
    return AppForm(
      title: 'Editar Centro de Custo',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: vm.updateCommand,
          builder: (_, _) {
            return ButtonSave(
              loading: vm.updateCommand.value.isRunning,
              onPressed: //
              vm.updateCommand.value.isRunning || !_canSubmit
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
            initialValue: dto.descricao,
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'descricao'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppSwitchField(
            label: 'Ativo',
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
