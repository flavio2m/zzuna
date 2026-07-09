import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';
import 'package:zzuna/ui/lancamentos/transferencia/viewmodels/transferencia_update_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_origem_field.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_area_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class TransferenciaUpdateModal extends ConsumerStatefulWidget {
  final String grupoId;

  const TransferenciaUpdateModal({super.key, required this.grupoId});

  static void show(BuildContext context, {required String grupoId}) {
    AppDialog.show(
      context: context,
      child: TransferenciaUpdateModal(grupoId: grupoId),
    );
  }

  @override
  ConsumerState<TransferenciaUpdateModal> createState() =>
      _TransferenciaUpdateModalState();
}

class _TransferenciaUpdateModalState
    extends ConsumerState<TransferenciaUpdateModal> {
  final _formKey = GlobalKey<FormState>();
  final validator = TransferenciaValidator();

  DateTime? _data;
  String? _descricao;
  double? _valor;
  LancamentoOrigem? _origemSaida;
  LancamentoOrigem? _origemEntrada;
  String? _observacao;
  bool _initialized = false;

  final _dataFocus = FocusNode();
  final _descFocus = FocusNode();
  final _origemSaidaFocus = FocusNode();
  final _origemEntradaFocus = FocusNode();
  final _valorFocus = FocusNode();
  final _obsFocus = FocusNode();
  final _saveFocus = FocusNode();

  late final TransferenciaUpdateViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(transferenciaUpdateViewModelProvider(widget.grupoId));
    viewModel.updateCommand.addListener(_commandListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _dataFocus.requestFocus();
      }
    });

    Future(() {
      viewModel.load().then((_) {
        if (mounted) {
          setState(() {
            _data = viewModel.data;
            _descricao = viewModel.descricao;
            _valor = viewModel.valor;
            _origemSaida = viewModel.origemSaida;
            _origemEntrada = viewModel.origemEntrada;
            _observacao = viewModel.observacao;
            _initialized = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    viewModel.updateCommand.removeListener(_commandListener);
    _dataFocus.dispose();
    _descFocus.dispose();
    _origemSaidaFocus.dispose();
    _origemEntradaFocus.dispose();
    _valorFocus.dispose();
    _obsFocus.dispose();
    _saveFocus.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Transferência atualizada com sucesso');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit {
    if (_origemSaida == null || _origemEntrada == null) return false;
    if (_origemSaida == _origemEntrada) return false;

    final dto = CreateTransferenciaDto(
      data: _data ?? DateTime.now(),
      descricao: _descricao ?? 'Transferência',
      valor: _valor ?? 0,
      origemSaida: _origemSaida!,
      origemEntrada: _origemEntrada!,
      observacao: _observacao,
    );
    return validator.validate(dto).isValid;
  }

  void _handleSubmit() {
    if (_origemSaida == null) {
      AppSnackBar.showError(context, 'Selecione a conta ou cartão de origem');
      return;
    }
    if (_origemEntrada == null) {
      AppSnackBar.showError(context, 'Selecione a conta ou cartão de destino');
      return;
    }
    if (_origemSaida == _origemEntrada) {
      AppSnackBar.showError(
        context,
        'A conta/cartão de origem deve ser diferente do destino',
      );
      return;
    }

    final dto = CreateTransferenciaDto(
      data: _data ?? DateTime.now(),
      descricao: _descricao ?? 'Transferência',
      valor: _valor ?? 0,
      origemSaida: _origemSaida!,
      origemEntrada: _origemEntrada!,
      observacao: _observacao,
    );

    if (_formKey.currentState?.validate() ?? false) {
      viewModel.updateCommand.execute(dto);
    }
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading || !_initialized) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return AppForm(
          formKey: _formKey,
          title: 'Editar Transferência',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ListenableBuilder(
              listenable: viewModel.updateCommand,
              builder: (_, _) {
                return ButtonSave(
                  focusNode: _saveFocus,
                  loading: viewModel.updateCommand.value.isRunning,
                  onPressed:
                      viewModel.updateCommand.value.isRunning || !_canSubmit
                      ? null
                      : _handleSubmit,
                );
              },
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Data (25%) + Descrição (75%)
              _FormRow(
                isDesktop: isDesktop,
                leftFlex: 2,
                rightFlex: 5,
                left: AppDateFormField(
                  label: 'Data',
                  focusNode: _dataFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _descFocus.requestFocus(),
                  initialValue: _data != null ? _formatDate(_data!) : '',
                  onDateSelected: (date) => setState(() => _data = date),
                ),
                right: AppTextFormField(
                  label: 'Descrição',
                  focusNode: _descFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _origemSaidaFocus.requestFocus(),
                  initialValue: _descricao,
                  onChanged: (value) => setState(() => _descricao = value),
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 2. Origem (50%) + Destino (50%)
              _FormRow(
                isDesktop: isDesktop,
                left: LancamentoOrigemField(
                  label: 'Conta/Cartão de Origem',
                  focusNode: _origemSaidaFocus,
                  onEnterPressed: () => _origemEntradaFocus.requestFocus(),
                  origens: viewModel.origens,
                  value: _origemSaida,
                  onChanged: (origem) {
                    if (origem != null) setState(() => _origemSaida = origem);
                  },
                ),
                right: LancamentoOrigemField(
                  label: 'Conta/Cartão de Destino',
                  focusNode: _origemEntradaFocus,
                  onEnterPressed: () => _valorFocus.requestFocus(),
                  origens: viewModel.origens,
                  value: _origemEntrada,
                  onChanged: (origem) {
                    if (origem != null) setState(() => _origemEntrada = origem);
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 3. Valor (25%) + Observação (75%)
              _FormRow(
                isDesktop: isDesktop,
                leftFlex: 2,
                rightFlex: 5,
                left: AppCurrencyFormField(
                  label: 'Valor',
                  focusNode: _valorFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _obsFocus.requestFocus(),
                  initialValue: _valor != null
                      ? UtilBrasilFields.obterReal(_valor!)
                      : null,
                  onChanged: (raw) {
                    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                    setState(() {
                      _valor = clean.isEmpty ? 0 : double.parse(clean) / 100;
                    });
                  },
                ),
                right: AppTextAreaFormField(
                  label: 'Observação',
                  focusNode: _obsFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _saveFocus.requestFocus(),
                  initialValue: _observacao,
                  onChanged: (value) => setState(() {
                    _observacao = value.isEmpty ? null : value;
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FormRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool isDesktop;
  final int leftFlex;
  final int rightFlex;

  const _FormRow({
    required this.left,
    required this.right,
    required this.isDesktop,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [left, const SizedBox(height: 16), right],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: leftFlex, child: left),
        const SizedBox(width: 16),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }
}
