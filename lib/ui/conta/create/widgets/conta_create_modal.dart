import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/validators/conta_validator.dart';
import 'package:zzuna/ui/conta/create/viewModels/conta_create_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ContaCreateModal extends ConsumerStatefulWidget {
  const ContaCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const ContaCreateModal());
  }

  @override
  ConsumerState<ContaCreateModal> createState() => _ContaCreateModalState();
}

class _ContaCreateModalState extends ConsumerState<ContaCreateModal> {
  late final ContaCreateViewModel viewModel;
  final dto = CreateContaDto();
  final validator = ContaValidator<CreateContaDto>();

  final _descFocus = FocusNode();
  final _bancoFocus = FocusNode();
  final _ativoFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(contaCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);

    _descFocus.dispose();
    _bancoFocus.dispose();
    _ativoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Conta criada com sucesso.');
      Navigator.of(context).pop();
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit {
    return validator.validate(dto).isValid;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      ref.read(contaCreateViewModelProvider).createCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(contaCreateViewModelProvider);

    return AppForm(
      title: 'Nova Conta',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: viewModel.createCommand,
          builder: (context, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              loading: viewModel.createCommand.value.isRunning,
              onPressed: viewModel.createCommand.value.isRunning || !_canSubmit
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
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            onFieldSubmitted: (_) => _bancoFocus.requestFocus(),
            validator: validator.byField(dto, 'descricao'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: AppDropdownFormField<String>(
                  label: 'Banco',
                  focusNode: _bancoFocus,
                  onEnterPressed: () => _ativoFocus.requestFocus(),
                  items: Bancos.items.map((b) {
                    return AppDropdownMenuItem(
                      value: b.sigla,
                      label: b.descricao,
                    );
                  }).toList(),
                  onChanged: (value) {
                    dto.setBancoSigla(value ?? '');
                    setState(() {});
                  },
                  validator: validator.byField(dto, 'bancoSigla'),
                ),
              ),
              const AppSpacing(size: AppSpacingSize.md, axis: Axis.horizontal),
              Expanded(
                flex: 1,
                child: AppSwitchField(
                  label: 'Ativo',
                  focusNode: _ativoFocus,
                  onEnterPressed: () => _saveFocus.requestFocus(),
                  value: dto.ativo,
                  onChanged: (value) {
                    dto.setAtivo(value);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
