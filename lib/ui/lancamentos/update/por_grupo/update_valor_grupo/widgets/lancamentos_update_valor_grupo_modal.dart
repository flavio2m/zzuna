import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_item_distribution_usecase.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_valor_grupo/viewmodels/lancamentos_update_valor_grupo_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_itens_panel.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/centro_custo_field.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosUpdateValorGrupoModal extends ConsumerStatefulWidget {
  final String lancamentoId;
  final List<LancamentoItem> initialItens;
  final VoidCallback? onSuccess;

  const LancamentosUpdateValorGrupoModal({
    super.key,
    required this.lancamentoId,
    required this.initialItens,
    this.onSuccess,
  });

  static void show({
    required BuildContext context,
    required String lancamentoId,
    required List<LancamentoItem> initialItens,
    VoidCallback? onSuccess,
  }) {
    AppDialog.show(
      context: context,
      child: LancamentosUpdateValorGrupoModal(
        lancamentoId: lancamentoId,
        initialItens: initialItens,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<LancamentosUpdateValorGrupoModal> createState() =>
      _LancamentosUpdateValorGrupoModalState();
}

class _LancamentosUpdateValorGrupoModalState
    extends ConsumerState<LancamentosUpdateValorGrupoModal> {
  final _formKey = GlobalKey<FormState>();

  String _categoriaId = '';
  String _centroCustoId = '';
  double _valor = 0;

  List<LancamentoItem> _itens = [];
  final _distributionUseCase = LancamentoItemDistributionUseCase();
  final _valorController = TextEditingController();

  late final LancamentosUpdateValorGrupoViewModel _viewModel;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(lancamentosUpdateValorGrupoViewModelProvider);
    _viewModel.updateValorGrupoCommand.addListener(_commandListener);
    _viewModel.load();

    // Carregar itens originais
    _itens = List.from(widget.initialItens);
    if (_itens.isNotEmpty) {
      _categoriaId = _itens.first.categoriaId;
      _centroCustoId = _itens.first.centroCustoId;
    }
    _valor = _itens.fold<double>(0.0, (sum, item) => sum + item.valor);
    _updateTotalValor();
  }

  @override
  void dispose() {
    _viewModel.updateValorGrupoCommand.removeListener(_commandListener);
    _valorController.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.updateValorGrupoCommand.value;

    commandValue.onSuccess((_) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showSuccess(
          context,
          'Valor e itens dos lançamentos do grupo alterados com sucesso',
        );
        widget.onSuccess?.call();
        Navigator.pop(context);
      }
    });

    commandValue.onFailure((exception) {
      if (_isExecuting) {
        _isExecuting = false;
        AppSnackBar.showError(context, exception.toString());
      }
    });
  }

  void _updateTotalValor() {
    final total = _itens.fold<double>(0.0, (sum, item) => sum + item.valor);
    _valor = total;
    _valorController.text = UtilBrasilFields.obterReal(total);
  }

  void _syncItem1() {
    final outrosItens = _itens.where((item) => item.numero != 1).toList();
    final somaOutros = outrosItens.fold<double>(
      0.0,
      (sum, item) => sum + item.valor,
    );
    final valorItem1 = double.parse((_valor - somaOutros).toStringAsFixed(2));

    final item1Idx = _itens.indexWhere((item) => item.numero == 1);
    final updatedItem1 = LancamentoItem(
      numero: 1,
      categoriaId: _categoriaId,
      centroCustoId: _centroCustoId,
      valor: valorItem1,
    );

    setState(() {
      if (item1Idx == -1) {
        _itens.insert(0, updatedItem1);
      } else {
        _itens[item1Idx] = updatedItem1;
      }
    });
  }

  void _handleSubmit() {
    _syncItem1();

    final total = _itens.fold<double>(0.0, (sum, item) => sum + item.valor);
    final valRes = _distributionUseCase.validateDistribution(_itens, total);
    if (valRes.isError()) {
      AppSnackBar.showError(
        context,
        (valRes.exceptionOrNull() as DomainException).message,
      );
      return;
    }

    if (_itens.any((item) => item.categoriaId.isEmpty)) {
      AppSnackBar.showError(context, 'Selecione uma categoria para cada item.');
      return;
    }

    if (_itens.any((item) => item.centroCustoId.isEmpty)) {
      AppSnackBar.showError(
        context,
        'Selecione um centro de custo para cada item.',
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isExecuting = true;
      });
      _viewModel.updateValorGrupoCommand.execute((
        lancamentoId: widget.lancamentoId,
        novosItens: _itens,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isRunning = _viewModel.updateValorGrupoCommand.value.isRunning;
        final isLoading = isRunning && _isExecuting;

        return AppForm(
          formKey: _formKey,
          title: 'Alterar Valor/Itens em Lote',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ButtonSave(loading: isLoading, onPressed: isLoading ? null : _handleSubmit),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Escolha o novo valor, categoria e centro de custo para os '
                'lançamentos do grupo a partir deste mês:',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const AppSpacing(size: AppSpacingSize.md),

              // Categoria (Item 1) + Centro de Custo (Item 1)
              _FormRow(
                isDesktop: isDesktop,
                left: CategoriaField(
                  categorias: _viewModel.categorias,
                  value: _categoriaId.isNotEmpty ? _categoriaId : null,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Selecione a categoria'
                      : null,
                  onChanged: (categoriaId) {
                    setState(() {
                      _categoriaId = categoriaId ?? '';
                      _syncItem1();
                    });
                  },
                ),
                right: CentroCustoField(
                  centros: _viewModel.centros,
                  value: _centroCustoId.isNotEmpty ? _centroCustoId : null,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Selecione o centro de custo'
                      : null,
                  onChanged: (centroCustoId) {
                    setState(() {
                      _centroCustoId = centroCustoId ?? '';
                      _syncItem1();
                    });
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // Valor Master
              Row(
                children: [
                  Expanded(
                    flex: isDesktop ? 2 : 1,
                    child: AppCurrencyFormField(
                      label: 'Valor Total',
                      controller: _valorController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Informe o valor';
                        }
                        final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                        final v = clean.isEmpty ? 0 : double.parse(clean) / 100;
                        if (v <= 0) {
                          return 'O valor deve ser maior que zero';
                        }
                        return null;
                      },
                      onChanged: (raw) {
                        final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                        setState(() {
                          _valor = clean.isEmpty
                              ? 0
                              : double.parse(clean) / 100;
                          _syncItem1();
                        });
                      },
                    ),
                  ),
                  if (isDesktop) const Spacer(flex: 2),
                ],
              ),

              const AppSpacing(size: AppSpacingSize.lg),

              Text(
                'Detalhamento do Valor:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              // Painel de itens de distribuição
              LancamentoItensPanel(
                items: _itens,
                totalValor: _valor,
                categorias: _viewModel.categorias,
                centros: _viewModel.centros,
                allowEditItem1: false,
                onSaveNewItem: (ccId, catId, val) {
                  final res = _distributionUseCase.addItem(
                    currentItems: _itens,
                    totalValor: _valor,
                    centroCustoId: ccId,
                    categoriaId: catId,
                    itemValor: val,
                  );
                  res.fold(
                    (updatedList) {
                      setState(() {
                        _itens = updatedList;
                        _updateTotalValor();
                      });
                    },
                    (exception) {
                      final msg = exception is DomainException
                          ? exception.message
                          : exception.toString();
                      AppSnackBar.showError(context, msg);
                    },
                  );
                },
                onSaveEditItem: (numero, ccId, catId, val) {
                  final res = _distributionUseCase.editItem(
                    currentItems: _itens,
                    totalValor: _valor,
                    numero: numero,
                    centroCustoId: ccId,
                    categoriaId: catId,
                    itemValor: val,
                  );
                  res.fold(
                    (updatedList) {
                      setState(() {
                        _itens = updatedList;
                        if (numero == 1) {
                          _categoriaId = catId;
                          _centroCustoId = ccId;
                        }
                        _updateTotalValor();
                      });
                    },
                    (exception) {
                      final msg = exception is DomainException
                          ? exception.message
                          : exception.toString();
                      AppSnackBar.showError(context, msg);
                    },
                  );
                },
                onDeleteItem: (numero) {
                  final res = _distributionUseCase.removeItem(
                    currentItems: _itens,
                    totalValor: _valor,
                    numero: numero,
                  );
                  res.fold(
                    (updatedList) {
                      setState(() {
                        _itens = updatedList;
                        _updateTotalValor();
                      });
                    },
                    (exception) {
                      final msg = exception is DomainException
                          ? exception.message
                          : exception.toString();
                      AppSnackBar.showError(context, msg);
                    },
                  );
                },
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

  const _FormRow({
    required this.left,
    required this.right,
    required this.isDesktop,
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
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}
