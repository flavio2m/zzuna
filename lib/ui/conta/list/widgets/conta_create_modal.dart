import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/validators/conta_validator.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ContaCreateModal extends ConsumerStatefulWidget {
  const ContaCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(
      context,
      child: const ContaCreateModal(),
    );
  }

  @override
  ConsumerState<ContaCreateModal> createState() => _ContaCreateModalState();
}

class _ContaCreateModalState extends ConsumerState<ContaCreateModal> {
  final dto = CreateContaDto();
  final validator = ContaValidator<CreateContaDto>();

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(contaListViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    final viewModel = ref.read(contaListViewModelProvider);
    viewModel.createCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final viewModel = ref.read(contaListViewModelProvider);
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Conta criada com sucesso');
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
      ref.read(contaListViewModelProvider).createCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(contaListViewModelProvider);

    return AppForm(
      title: 'Nova Conta',
      type: AppFormType.modal,
      actions: [
        ListenableBuilder(
          listenable: viewModel.createCommand,
          builder: (context, _) {
            return ButtonSave(
              onPressed: viewModel.createCommand.value.isRunning || !_canSubmit ? null : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFormField(
            label: 'Descrição',
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: (value) => validator.byField(dto, 'descricao'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Banco',
              border: OutlineInputBorder(),
            ),
            items: Bancos.items.map((b) {
              return DropdownMenuItem(value: b.sigla, child: Text(b.descricao));
            }).toList(),
            onChanged: (value) {
              dto.setBancoSigla(value ?? '');
              setState(() {});
            },
            validator: (value) => validator.byField(dto, 'bancoSigla'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          SwitchListTile(
            title: const Text('Ativo'),
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
