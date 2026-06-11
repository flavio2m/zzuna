import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/validators/cartao_validator.dart';
import 'package:zzuna/ui/cartao/create/viewModels/cartao_create_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_banco_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CartaoCreateModal extends ConsumerStatefulWidget {
  const CartaoCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const CartaoCreateModal());
  }

  @override
  ConsumerState<CartaoCreateModal> createState() => _CartaoCreateModalState();
}

class _CartaoCreateModalState extends ConsumerState<CartaoCreateModal> {
  final dto = CartaoDto();

  final validator = CartaoValidator<CartaoDto>();

  late final CartaoCreateViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ref.read(cartaoCreateViewModelProvider);

    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);

    super.dispose();
  }

  void _commandListener() {
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
    return validator.validate(dto).isValid;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      viewModel.createCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(cartaoCreateViewModelProvider);

    return AppForm(
      title: 'Novo Cartão de Crédito',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),

        ListenableBuilder(
          listenable: viewModel.createCommand,
          builder: (_, _) {
            return ButtonSave(onPressed: viewModel.createCommand.value.isRunning || !_canSubmit ? null : _handleSubmit);
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
            validator: validator.byField(dto, 'descricao'),
          ),

          const AppSpacing(size: AppSpacingSize.md),

          Row(
            children: [
              Expanded(
                child: AppCurrencyFormField(
                  label: 'Limite',
                  initialValue: UtilBrasilFields.obterReal(dto.limite, moeda: true),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final valor = UtilBrasilFields.converterMoedaParaDouble(value);
                      dto.setLimite(valor);
                    } else {
                      dto.setLimite(0);
                    }
                    setState(() {});
                  },
                  validator: validator.byField(dto, 'limite'),
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md, axis: Axis.horizontal),

              Expanded(
                child: AppIntegerFormField(
                  label: 'Dia Fechamento',
                  onChanged: (value) {
                    dto.setDiaFechamento(int.tryParse(value) ?? 0);
                    setState(() {});
                  },
                  validator: validator.byField(dto, 'diaFechamento'),
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
