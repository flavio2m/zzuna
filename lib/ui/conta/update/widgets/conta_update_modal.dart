import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/validators/conta_validator.dart';
import 'package:zzuna/ui/conta/update/viewmodels/conta_update_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ContaUpdateModal extends ConsumerStatefulWidget {
  final LoadedContaDto conta;

  const ContaUpdateModal({super.key, required this.conta});

  static void show(BuildContext context, LoadedContaDto conta) {
    AppDialog.show(
      context: context,
      child: ContaUpdateModal(conta: conta),
    );
  }

  @override
  ConsumerState<ContaUpdateModal> createState() => _ContaUpdateModalState();
}

class _ContaUpdateModalState extends ConsumerState<ContaUpdateModal> {
  late final ContaUpdateViewModel viewModel;
  late final LoadedContaDto dto;
  final validator = ContaValidator<LoadedContaDto>();

  late final TextEditingController _descController;
  final _descFocus = FocusNode();
  final _bancoFocus = FocusNode();
  final _ativoFocus = FocusNode();
  final _dataFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    dto = LoadedContaDto(
      id: widget.conta.id,
      descricao: widget.conta.descricao,
      bancoSigla: widget.conta.bancoSigla,
      ativo: widget.conta.ativo,
      dataInicial: widget.conta.dataInicial,
    );
    viewModel = ref.read(contaUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);

    _descController = TextEditingController(text: dto.descricao);
    _descFocus.addListener(() {
      if (_descFocus.hasFocus && _descController.text.isNotEmpty) {
        _descController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _descController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    viewModel.updateCommand.removeListener(_commandListener);

    _descController.dispose();
    _descFocus.dispose();
    _bancoFocus.dispose();
    _ativoFocus.dispose();
    _dataFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Conta atualizada com sucesso.');
      Navigator.pop(context);
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
      ref.read(contaUpdateViewModelProvider).updateCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(contaUpdateViewModelProvider);

    return AppForm(
      title: 'Editar Conta',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: viewModel.updateCommand,
          builder: (context, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              loading: viewModel.updateCommand.value.isRunning,
              onPressed: viewModel.updateCommand.value.isRunning || !_canSubmit
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
            controller: _descController,
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
                  value: dto.bancoSigla,
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
                  onEnterPressed: () => _dataFocus.requestFocus(),
                  value: dto.ativo,
                  onChanged: (value) {
                    dto.setAtivo(value);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppDateFormField(
            label: 'Data Inicial',
            focusNode: _dataFocus,
            textInputAction: TextInputAction.next,
            initialValue: UtilData.obterDataDDMMAAAA(dto.dataInicial),
            onDateSelected: (date) {
              dto.setDataInicial(date);
            },
            validator: validator.byField(dto, 'dataInicial'),
          ),
        ],
      ),
    );
  }
}
