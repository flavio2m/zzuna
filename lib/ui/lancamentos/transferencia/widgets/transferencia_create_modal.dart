import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
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
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class TransferenciaCreateModal extends ConsumerStatefulWidget {
  const TransferenciaCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const TransferenciaCreateModal());
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

  late final TransferenciaCreateViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(transferenciaCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);

    _loadData();
  }

  void _loadData() {
    viewModel.load().then((_) {
      if (!mounted) return;
      _preencherOrigensDoFiltro();
    });
  }

  void _preencherOrigensDoFiltro() {
    if (_origemSaida != null || _origemEntrada != null) return;

    final filter = ref.read(lancamentoFilterProvider);
    final contas = filter.contasSelecionadas;
    final cartoes = filter.cartoesSelecionados;

    if (contas.isEmpty && cartoes.isEmpty) return;

    final selectedOrigens = viewModel.origens.where((d) => switch (d) {
      LancamentoOrigemContaDetail(:final conta) => contas.contains(conta.id),
      LancamentoOrigemCartaoDetail(:final cartao) => cartoes.contains(cartao.id),
    }).toList();

    if (selectedOrigens.isNotEmpty) {
      setState(() {
        _origemSaida = selectedOrigens[0].origem;

        if (selectedOrigens.length > 1) {
          _origemEntrada = selectedOrigens[1].origem;
        }
      });
    }
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);
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
                  onPressed: viewModel.createCommand.value.isRunning
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
                  initialValue: _formatDate(_data),
                  onDateSelected: (date) => setState(() => _data = date),
                ),
                right: AppTextFormField(
                  label: 'Descrição',
                  icon: Icons.description_outlined,
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
                  origens: viewModel.origens,
                  value: _origemSaida,
                  onChanged: (origem) {
                    if (origem != null) setState(() => _origemSaida = origem);
                  },
                ),
                right: LancamentoOrigemField(
                  label: 'Conta/Cartão de Destino',
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
                  onChanged: (raw) {
                    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                    setState(() {
                      _valor = clean.isEmpty ? 0 : double.parse(clean) / 100;
                    });
                  },
                ),
                right: AppTextAreaFormField(
                  label: 'Observação',
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
