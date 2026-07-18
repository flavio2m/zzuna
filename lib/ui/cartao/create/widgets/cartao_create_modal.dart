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
import 'package:zzuna/ui/lancamentos/shared/widgets/app_cartao_comportamento_dropdown.dart';
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

  final _descFocus = FocusNode();
  final _limiteFocus = FocusNode();
  final _fechamentoFocus = FocusNode();
  final _bancoFocus = FocusNode();
  final _ativoFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    viewModel = ref.read(cartaoCreateViewModelProvider);

    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);

    _descFocus.dispose();
    _limiteFocus.dispose();
    _fechamentoFocus.dispose();
    _bancoFocus.dispose();
    _ativoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Cartão criado com sucesso.');

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AppTextFormField(
                  label: 'Descrição',
                  autofocus: true,
                  focusNode: _descFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _limiteFocus.requestFocus(),
                  onChanged: (value) {
                    dto.setDescricao(value);
                    setState(() {});
                  },
                  validator: validator.byField(dto, 'descricao'),
                ),
              ),
              const AppSpacing(size: AppSpacingSize.md, axis: Axis.horizontal),
              Expanded(
                flex: 1,
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
            ],
          ),

          const AppSpacing(size: AppSpacingSize.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
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
              const AppSpacing(size: AppSpacingSize.md, axis: Axis.horizontal),
              Expanded(
                flex: 3,
                child: AppCartaoComportamentoDropdown(
                  initialValue: dto.comportamentoFechamento,
                  onChanged: (value) {
                    if (value != null) {
                      dto.setComportamentoFechamento(value);
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),

          const AppSpacing(size: AppSpacingSize.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: AppBancoDropdown(
                  focusNode: _bancoFocus,
                  onEnterPressed: () => _ativoFocus.requestFocus(),
                  value: dto.bancoSigla.isEmpty ? null : dto.bancoSigla,
                  onChanged: (value) {
                    dto.setBancoSigla(value ?? '');
                    setState(() {});
                  },
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
