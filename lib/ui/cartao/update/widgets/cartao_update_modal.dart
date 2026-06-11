import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/validators/cartao_validator.dart';
import 'package:zzuna/ui/cartao/update/viewmodels/cartao_update_viewmodel.dart';
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

class CartaoUpdateModal extends ConsumerStatefulWidget {
  final CartaoDto cartao;

  const CartaoUpdateModal({super.key, required this.cartao});

  static void show(BuildContext context, CartaoDto cartao) {
    AppDialog.show(
      context: context,
      child: CartaoUpdateModal(cartao: cartao),
    );
  }

  @override
  ConsumerState<CartaoUpdateModal> createState() => _CartaoUpdateModalState();
}

class _CartaoUpdateModalState extends ConsumerState<CartaoUpdateModal> {
  late final CartaoDto dto;

  final validator = CartaoValidator<CartaoDto>();

  late final CartaoUpdateViewModel viewModel;

  @override
  void initState() {
    super.initState();

    dto = CartaoDto(
      id: widget.cartao.id,
      descricao: widget.cartao.descricao,
      limite: widget.cartao.limite,
      bancoSigla: widget.cartao.bancoSigla,
      ativo: widget.cartao.ativo,
      diaFechamento: widget.cartao.diaFechamento,
    );

    viewModel = ref.read(cartaoUpdateViewModelProvider);

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
      AppSnackBar.showSuccess(context, 'Cartão atualizado com sucesso');

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
      viewModel.updateCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(cartaoUpdateViewModelProvider);

    return AppForm(
      title: 'Editar Cartão',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),

        ListenableBuilder(
          listenable: viewModel.updateCommand,
          builder: (_, _) {
            return ButtonSave(onPressed: viewModel.updateCommand.value.isRunning || !_canSubmit ? null : _handleSubmit);
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
                  initialValue: dto.diaFechamento.toString(),
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
            value: dto.bancoSigla,
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
