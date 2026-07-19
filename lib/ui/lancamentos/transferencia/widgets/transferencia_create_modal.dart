import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';
import 'package:zzuna/ui/lancamentos/transferencia/viewmodels/transferencia_create_viewmodel.dart';
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
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class TransferenciaCreateModal extends ConsumerStatefulWidget {
  final LancamentoDetails? cloneTransferencia;

  const TransferenciaCreateModal({super.key, this.cloneTransferencia});

  static void show(
    BuildContext context, {
    LancamentoDetails? cloneTransferencia,
  }) {
    AppDialog.show(
      context: context,
      child: TransferenciaCreateModal(cloneTransferencia: cloneTransferencia),
    );
  }

  @override
  ConsumerState<TransferenciaCreateModal> createState() =>
      _TransferenciaCreateModalState();
}

class _TransferenciaCreateModalState
    extends ConsumerState<TransferenciaCreateModal> {
  final _formKey = GlobalKey<FormState>();
  final validator = TransferenciaValidator();

  DateTime _data = DateTime.now();
  String _descricao = 'Transferência';
  double _valor = 0;
  LancamentoOrigem? _origemSaida;
  LancamentoOrigem? _origemEntrada;
  String? _observacao;
  int _ocorrencias = 1;

  final _dataFocus = FocusNode();
  final _descFocus = FocusNode();
  final _origemSaidaFocus = FocusNode();
  final _origemEntradaFocus = FocusNode();
  final _valorFocus = FocusNode();
  final _obsFocus = FocusNode();
  final _ocorrenciasFocus = FocusNode();
  final _saveFocus = FocusNode();

  late final TransferenciaCreateViewModel viewModel;

  @override
  void initState() {
    super.initState();

    if (widget.cloneTransferencia != null) {
      final clone = widget.cloneTransferencia!;
      _data = clone.data;
      _descricao = clone.descricao;
      _valor = clone.valor;
      _observacao = clone.observacao;

      if (clone.itens.isNotEmpty) {
        clone.itens.first.map(
          (standard) {
            _origemSaida = clone.origem.origem;
          },
          transferencia: (t) {
            _origemSaida = t.origemSaida.origem;
            _origemEntrada = t.origemEntrada.origem;
          },
        );
      } else {
        _origemSaida = clone.origem.origem;
      }
    }

    viewModel = ref.read(transferenciaCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _dataFocus.requestFocus();
      }
    });

    _loadData();
  }

  void _loadData() {
    Future(() {
      viewModel.load().then((_) {
        if (!mounted) return;
        _preencherOrigensDoFiltro();
      });
    });
  }

  void _preencherOrigensDoFiltro() {
    if (_origemSaida != null || _origemEntrada != null) return;

    final filter = ref.read(lancamentoFilterProvider);
    final contas = filter.contasSelecionadas;
    final cartoes = filter.cartoesSelecionados;

    if (contas.isEmpty && cartoes.isEmpty) return;

    final selectedOrigens = viewModel.origens
        .where(
          (d) => switch (d) {
            LancamentoOrigemContaDetail(:final conta) => contas.contains(
              conta.id,
            ),
            LancamentoOrigemCartaoDetail(:final cartao) => cartoes.contains(
              cartao.id,
            ),
          },
        )
        .toList();

    if (selectedOrigens.isNotEmpty) {
      setState(() {
        _origemSaida ??= selectedOrigens[0].origem;

        if (selectedOrigens.length > 1 && _origemEntrada == null) {
          _origemEntrada = selectedOrigens[1].origem;
        }
      });
    }
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);
    _dataFocus.dispose();
    _descFocus.dispose();
    _origemSaidaFocus.dispose();
    _origemEntradaFocus.dispose();
    _valorFocus.dispose();
    _obsFocus.dispose();
    _ocorrenciasFocus.dispose();
    _saveFocus.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Transferência realizada com sucesso');
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
      data: _data,
      descricao: _descricao,
      valor: _valor,
      origemSaida: _origemSaida!,
      origemEntrada: _origemEntrada!,
      observacao: _observacao,
      ocorrencias: _ocorrencias,
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
      data: _data,
      descricao: _descricao,
      valor: _valor,
      origemSaida: _origemSaida!,
      origemEntrada: _origemEntrada!,
      observacao: _observacao,
      ocorrencias: _ocorrencias,
    );

    if (_formKey.currentState?.validate() ?? false) {
      viewModel.createCommand.execute(dto);
    }
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d/$m/$y';
  }

  void _swapOrigens() {
    if (_origemSaida != null && _origemEntrada != null) {
      setState(() {
        final temp = _origemSaida;
        _origemSaida = _origemEntrada;
        _origemEntrada = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return AppForm(
          formKey: _formKey,
          title: 'Nova Transferência',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ListenableBuilder(
              listenable: viewModel.createCommand,
              builder: (_, _) {
                return ButtonSave(
                  focusNode: _saveFocus,
                  loading: viewModel.createCommand.value.isRunning,
                  onPressed:
                      viewModel.createCommand.value.isRunning || !_canSubmit
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
                  initialValue: _formatDate(_data),
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
                middle: Padding(
                  padding: EdgeInsets.only(top: isDesktop ? 4.0 : 0.0),
                  child: IconButton(
                    icon: Icon(isDesktop ? Icons.swap_horiz : Icons.swap_vert),
                    onPressed: (_origemSaida != null && _origemEntrada != null)
                        ? _swapOrigens
                        : null,
                    tooltip: 'Inverter contas',
                  ),
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
                leftFlex: 1,
                rightFlex: 1,
                left: AppCurrencyFormField(
                  label: 'Valor',
                  focusNode: _valorFocus,
                  initialValue: _valor > 0
                      ? UtilBrasilFields.obterReal(_valor)
                      : null,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _obsFocus.requestFocus(),
                  onChanged: (raw) {
                    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                    setState(() {
                      _valor = clean.isEmpty ? 0 : double.parse(clean) / 100;
                    });
                  },
                ),
                right: AppIntegerFormField(
                  label: 'Replicar no mês seguinte:',
                  focusNode: _ocorrenciasFocus,
                  initialValue: _ocorrencias.toString(),
                  min: 1,
                  max: 24,
                  onFieldSubmitted: (_) => _saveFocus.requestFocus(),
                  onChanged: (val) {
                    final parsed = int.tryParse(val) ?? 1;
                    setState(() => _ocorrencias = parsed);
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),
              AppTextAreaFormField(
                label: 'Observação',
                focusNode: _obsFocus,
                initialValue: _observacao,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _ocorrenciasFocus.requestFocus(),
                onChanged: (value) => setState(() {
                  _observacao = value.isEmpty ? null : value;
                }),
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
  final Widget? middle;
  final bool isDesktop;
  final int leftFlex;
  final int rightFlex;

  const _FormRow({
    required this.left,
    required this.right,
    this.middle,
    required this.isDesktop,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          left,
          if (middle != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: middle,
              ),
            )
          else
            const SizedBox(height: 16),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: leftFlex, child: left),
        if (middle != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: middle,
          )
        else
          const SizedBox(width: 16),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }
}
