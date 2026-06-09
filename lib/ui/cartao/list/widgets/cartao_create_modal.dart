import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/cartao_dto.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_banco_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CartaoCreateModal extends ConsumerStatefulWidget {
  const CartaoCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(
      context,
      child: const CartaoCreateModal(),
    );
  }

  @override
  ConsumerState<CartaoCreateModal> createState() => _CartaoCreateModalState();
}

class _CartaoCreateModalState extends ConsumerState<CartaoCreateModal> {
  final dto = CartaoDto();

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(cartaoCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    final viewModel = ref.read(cartaoCreateViewModelProvider);
    viewModel.createCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final viewModel = ref.read(cartaoCreateViewModelProvider);
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Cartão criado com sucesso');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit {
    return dto.descricao.isNotEmpty && dto.bancoSigla.isNotEmpty;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      ref.read(cartaoCreateViewModelProvider).createCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(cartaoCreateViewModelProvider);

    return AppForm(
      title: 'Novo Cartão',
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
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  label: 'Limite',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    dto.setLimite(double.tryParse(value) ?? 0);
                    setState(() {});
                  },
                ),
              ),
              const AppSpacing(size: AppSpacingSize.md, isHorizontal: true),
              Expanded(
                child: AppTextFormField(
                  label: 'Dia Fechamento',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    dto.setDiaFechamento(int.tryParse(value) ?? 1);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppBancoDropdown(
            value: dto.bancoSigla.isEmpty ? null : dto.bancoSigla,
            onChanged: (value) {
              dto.setBancoSigla(value ?? '');
              setState(() {});
            },
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppStatusDropdown(
            value: dto.ativo,
            onChanged: (value) {
              dto.setAtivo(value ?? true);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
