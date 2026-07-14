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
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
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

  late final TextEditingController _descController;
  final _descFocus = FocusNode();
  final _limiteFocus = FocusNode();
  final _fechamentoFocus = FocusNode();
  final _bancoFocus = FocusNode();
  final _ativoFocus = FocusNode();
  final _dataFocus = FocusNode();
  final _saveFocus = FocusNode();

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
      dataInicial: widget.cartao.dataInicial,
    );

    viewModel = ref.read(cartaoUpdateViewModelProvider);
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
    _limiteFocus.dispose();
    _fechamentoFocus.dispose();
    _bancoFocus.dispose();
    _ativoFocus.dispose();
    _dataFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Cartão atualizado com sucesso.');

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
            onFieldSubmitted: (_) => _limiteFocus.requestFocus(),
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
                  focusNode: _limiteFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _fechamentoFocus.requestFocus(),
                  initialValue: UtilBrasilFields.obterReal(
                    dto.limite,
                    moeda: true,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final valor = UtilBrasilFields.converterMoedaParaDouble(
                        value,
                      );
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
                  focusNode: _fechamentoFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _bancoFocus.requestFocus(),
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
            focusNode: _bancoFocus,
            onEnterPressed: () => _ativoFocus.requestFocus(),
            value: dto.bancoSigla,
            onChanged: (value) {
              dto.setBancoSigla(value ?? '');

              setState(() {});
            },
          ),

          const AppSpacing(size: AppSpacingSize.md),

          AppSwitchField(
            label: 'Ativo',
            focusNode: _ativoFocus,
            onEnterPressed: () => _dataFocus.requestFocus(),
            value: dto.ativo,
            onChanged: (value) {
              dto.setAtivo(value);

              setState(() {});
            },
          ),

          const AppSpacing(size: AppSpacingSize.md),

          AppDateFormField(
            label: 'Data Inicial',
            focusNode: _dataFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _saveFocus.requestFocus(),
            initialValue: dto.dataInicial != null
                ? UtilData.obterDataDDMMAAAA(dto.dataInicial!)
                : '',
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
