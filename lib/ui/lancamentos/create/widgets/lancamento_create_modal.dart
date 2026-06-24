import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/ui/lancamentos/create/viewmodels/lancamento_create_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/modo_selector.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/parcelado_panel.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/replicado_panel.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/centro_custo_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_origem_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_tipo_field.dart';
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
import 'package:uuid/uuid.dart';

class LancamentoCreateModal extends ConsumerStatefulWidget {
  const LancamentoCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const LancamentoCreateModal());
  }

  @override
  ConsumerState<LancamentoCreateModal> createState() => _LancamentoCreateModalState();
}

class _LancamentoCreateModalState extends ConsumerState<LancamentoCreateModal> {
  final _formKey = GlobalKey<FormState>();
  final dto = LancamentoDto();
  final validator = LancamentoValidator();

  // Controla os valores em andamento no formulário
  double _valor = 0;
  String _categoriaId = '';
  String _centroCustoId = '';

  // Controle de modo
  ModoLancamento _modo = ModoLancamento.simples;
  int _numParcelas = 3;
  int _parcelaInicial = 2;
  int _parcelaFinal = 3;

  late final LancamentoCreateViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(lancamentoCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
    viewModel.load();
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Lançamento(s) cadastrado(s) com sucesso');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  DateTime _addMonths(DateTime date, int months) {
    var year = date.year;
    var month = date.month + months;
    while (month > 12) {
      year += 1;
      month -= 12;
    }
    final targetDays = DateTime(year, month + 1, 0).day;
    final day = date.day > targetDays ? targetDays : date.day;
    return DateTime(year, month, day, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

  List<double> _calculateParcelas(double totalValor, int parcelasCount) {
    if (parcelasCount <= 0) return [];
    final totalCentavos = (totalValor * 100).round();
    final baseCentavos = totalCentavos ~/ parcelasCount;
    final restoCentavos = totalCentavos % parcelasCount;

    return List<double>.generate(parcelasCount, (i) {
      final centavos = baseCentavos + (i == 0 ? restoCentavos : 0);
      return centavos / 100.0;
    });
  }

  List<double> get _previewValores => _calculateParcelas(_valor, _numParcelas);

  List<LancamentoDto> _buildDtos() {
    switch (_modo) {
      case ModoLancamento.simples:
        final item = LancamentoItem(numero: 1, categoriaId: _categoriaId, centroCustoId: _centroCustoId, valor: _valor);
        return [
          dto.copyWith(itens: [item]),
        ];

      case ModoLancamento.parcelado:
        final preview = _previewValores;
        return List.generate(_numParcelas, (index) {
          final i = index + 1;
          final item = LancamentoItem(
            numero: 1,
            categoriaId: _categoriaId,
            centroCustoId: _centroCustoId,
            valor: preview[index],
          );
          return dto.copyWith(
            id: const Uuid().v4(),
            descricao: '${dto.descricao} ($i/$_numParcelas)',
            data: _addMonths(dto.data, index),
            itens: [item],
          );
        });

      case ModoLancamento.replicado:
        final count = _parcelaFinal - _parcelaInicial + 1;
        return List.generate(count, (index) {
          final i = _parcelaInicial + index;
          final item = LancamentoItem(
            numero: 1,
            categoriaId: _categoriaId,
            centroCustoId: _centroCustoId,
            valor: _valor,
          );
          return dto.copyWith(
            id: const Uuid().v4(),
            descricao: '${dto.descricao} ($i/$_parcelaFinal)',
            data: _addMonths(dto.data, index),
            itens: [item],
          );
        });
    }
  }

  void _handleSubmit() {
    // Sincroniza o item para fins de validação no formulário
    dto.setItens([LancamentoItem(numero: 1, categoriaId: _categoriaId, centroCustoId: _centroCustoId, valor: _valor)]);

    if (_formKey.currentState?.validate() ?? false) {
      if (_modo == ModoLancamento.parcelado) {
        if (_numParcelas < 2) {
          AppSnackBar.showError(context, 'Informe pelo menos 2 parcelas.');
          return;
        }
      } else if (_modo == ModoLancamento.replicado) {
        if (_parcelaFinal < _parcelaInicial) {
          AppSnackBar.showError(context, 'A parcela final não pode ser menor que a inicial.');
          return;
        }
        if ((_parcelaFinal - _parcelaInicial + 1) < 2) {
          AppSnackBar.showError(context, 'A replicação deve gerar pelo menos 2 lançamentos.');
          return;
        }
      }
      final dtos = _buildDtos();
      viewModel.createCommand.execute(dtos);
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
          title: 'Novo Lançamento',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ListenableBuilder(
              listenable: viewModel.createCommand,
              builder: (_, _) {
                return ButtonSave(onPressed: viewModel.createCommand.value.isRunning ? null : _handleSubmit);
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
                  initialValue: _formatDate(dto.data),
                  validator: validator.byField(dto, 'data'),
                  onDateSelected: (date) => setState(() => dto.setData(date)),
                ),
                right: AppTextFormField(
                  label: 'Descrição',
                  icon: Icons.description_outlined,
                  validator: validator.byField(dto, 'descricao'),
                  onChanged: (value) {
                    dto.setDescricao(value);
                    setState(() {});
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 2. Tipo (50%) + Origem (50%)
              _FormRow(
                isDesktop: isDesktop,
                left: LancamentoTipoField(
                  value: dto.tipo,
                  onChanged: (tipo) {
                    if (tipo != null) setState(() => dto.setTipo(tipo));
                  },
                ),
                right: LancamentoOrigemField(
                  origens: viewModel.origens,
                  value: dto.origem,
                  validator: (_) => validator.byField(dto, 'origem')(null),
                  onChanged: (origem) {
                    if (origem != null) setState(() => dto.setOrigem(origem));
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 3. Categoria (50%) + Centro de Custo (50%)
              _FormRow(
                isDesktop: isDesktop,
                left: CategoriaField(
                  categorias: viewModel.categorias,
                  value: _categoriaId.isNotEmpty ? _categoriaId : null,
                  validator: validator.byField(dto, 'itensCategorias'),
                  onChanged: (categoriaId) {
                    setState(() => _categoriaId = categoriaId ?? '');
                  },
                ),
                right: CentroCustoField(
                  centros: viewModel.centros,
                  value: _centroCustoId.isNotEmpty ? _centroCustoId : null,
                  validator: validator.byField(dto, 'itensCentrosCusto'),
                  onChanged: (centroCustoId) {
                    setState(() => _centroCustoId = centroCustoId ?? '');
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 4. Valor (25%) + Observação (75%)
              _FormRow(
                isDesktop: isDesktop,
                leftFlex: 2,
                rightFlex: 5,
                left: AppCurrencyFormField(
                  label: 'Valor',
                  validator: validator.byField(dto, 'itensValores'),
                  onChanged: (raw) {
                    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                    setState(() {
                      _valor = clean.isEmpty ? 0 : double.parse(clean) / 100;
                    });
                  },
                ),
                right: AppTextAreaFormField(
                  label: 'Observação',
                  onChanged: (value) => dto.setObservacao(
                    value.isEmpty ? null : value,
                  ),
                ),
              ),

              const AppSpacing(size: AppSpacingSize.lg),

              ModoSelector(selected: _modo, onChanged: (modo) => setState(() => _modo = modo)),

              if (_modo != ModoLancamento.simples) ...[
                const AppSpacing(size: AppSpacingSize.md),
                if (_modo == ModoLancamento.parcelado)
                  ParceladoPanel(
                    numParcelas: _numParcelas,
                    onNumParcelasChanged: (val) => setState(() => _numParcelas = val),
                    totalValor: _valor,
                    previewValores: _previewValores,
                  )
                else if (_modo == ModoLancamento.replicado)
                  ReplicadoPanel(
                    parcelaInicial: _parcelaInicial,
                    parcelaFinal: _parcelaFinal,
                    onParcelaInicialChanged: (val) => setState(() => _parcelaInicial = val),
                    onParcelaFinalChanged: (val) => setState(() => _parcelaFinal = val),
                    valorUnitario: _valor,
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d/$m/$y';
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
        children: [
          left,
          const SizedBox(height: 16),
          right,
        ],
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
