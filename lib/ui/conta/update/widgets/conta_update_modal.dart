import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/validators/conta_validator.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
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
  late final LoadedContaDto dto;
  final validator = ContaValidator<LoadedContaDto>();

  @override
  void initState() {
    super.initState();
    dto = LoadedContaDto(
      id: widget.conta.id,
      descricao: widget.conta.descricao,
      bancoSigla: widget.conta.bancoSigla,
      ativo: widget.conta.ativo,
    );
    final viewModel = ref.read(contaUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    final viewModel = ref.read(contaUpdateViewModelProvider);
    viewModel.updateCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final viewModel = ref.read(contaUpdateViewModelProvider);
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((Conta) {
      AppSnackBar.showSuccess(context, 'Conta atualizada com sucesso');
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
              onPressed: //
              viewModel.updateCommand.value.isRunning || !_canSubmit
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
          DropdownButtonFormField<String>(
            value: dto.bancoSigla,
            decoration: const InputDecoration(
              labelText: 'Banco',
              border: OutlineInputBorder(), //
            ),
            items: Bancos.items.map((b) {
              return DropdownMenuItem(value: b.sigla, child: AppText(b.descricao));
            }).toList(),
            onChanged: (value) {
              dto.setBancoSigla(value ?? '');
              setState(() {});
            },
            validator: validator.byField(dto, 'bancoSigla'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          SwitchListTile(
            title: const AppText('Ativo'),
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
