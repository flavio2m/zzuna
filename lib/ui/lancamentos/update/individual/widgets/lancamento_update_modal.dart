import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_item_distribution_usecase.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/ui/lancamentos/update/individual/viewmodels/lancamento_update_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_itens_panel.dart';
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
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentoUpdateModal extends ConsumerStatefulWidget {
  final LancamentoDetails lancamento;

  const LancamentoUpdateModal({super.key, required this.lancamento});

  static void show(BuildContext context, LancamentoDetails lancamento) {
    AppDialog.show(
      context: context,
      child: LancamentoUpdateModal(lancamento: lancamento),
    );
  }

  @override
  ConsumerState<LancamentoUpdateModal> createState() =>
      _LancamentoUpdateModalState();
}

class _LancamentoUpdateModalState extends ConsumerState<LancamentoUpdateModal> {
  final _formKey = GlobalKey<FormState>();
  final validator = LancamentoValidator();

  // Controla os valores em andamento no formulário para Item 1
  String _categoriaId = '';
  String _centroCustoId = '';
  double _valor = 0;

  // Itens de distribuição
  List<LancamentoItem> _itens = [];
  final _distributionUseCase = LancamentoItemDistributionUseCase();

  // Controller para o campo Valor que ficará desabilitado
  final _valorController = TextEditingController();

  late final LancamentoUpdateViewModel viewModel;
  late final LancamentoDto dto;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(lancamentoUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);
    viewModel.load();

    // Inicializar o DTO localmente a partir dos detalhes do lançamento
    dto = LancamentoDto.fromDetails(widget.lancamento);

    // Carregar dados iniciais dos itens
    _itens = List.from(dto.itens);
    if (_itens.isNotEmpty) {
      _categoriaId = _itens.first.categoriaId;
      _centroCustoId = _itens.first.centroCustoId;
    }
    _valor = _itens.fold<double>(0.0, (sum, item) => sum + item.valor);
    _updateTotalValor();
  }

  @override
  void dispose() {
    viewModel.updateCommand.removeListener(_commandListener);
    _valorController.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Lançamento atualizado com sucesso');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
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
    dto.setItens(_itens);

    final total = _itens.fold<double>(0.0, (sum, item) => sum + item.valor);
    final valRes = _distributionUseCase.validateDistribution(_itens, total);
    if (valRes.isError()) {
      AppSnackBar.showError(
        context,
        (valRes.exceptionOrNull() as DomainException).message, //
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      viewModel.updateCommand.execute(dto);
    }
  }

  String _getModeText() {
    final grupo = widget.lancamento.grupo;
    if (grupo == null) {
      // Fallback para dados de visualização/teste legados se grupo for nulo
      final relationRegExp = RegExp(r'\s\((\d+)/(\d+)\)$');
      final match = relationRegExp.firstMatch(widget.lancamento.descricao);
      if (match != null) {
        final current = match.group(1);
        final total = match.group(2);
        final isReplicado = widget.lancamento.descricao.toLowerCase().contains(
          'replicado',
        );
        final modeStr = isReplicado ? 'Replicado' : 'Parcelado';
        return '$modeStr ($current de $total)';
      }
      return 'Simples';
    }

    return switch (grupo) {
      LancamentoGrupoParcelamento(:final parcela, :final totalParcelas) =>
        'Parcelado ($parcela de $totalParcelas)',
      LancamentoGrupoReplicacao(:final parcela, :final totalParcelas) =>
        'Replicado ($parcela de $totalParcelas)',
      LancamentoGrupoTransferencia() => 'Transferência',
      LancamentoGrupoRecorrencia(:final ativo) =>
        ativo ? 'Recorrente (Ativo)' : 'Recorrência Inativa',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);
    final modeText = _getModeText();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return AppForm(
          formKey: _formKey,
          title: 'Editar Lançamento',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ListenableBuilder(
              listenable: viewModel.updateCommand,
              builder: (_, _) {
                return ButtonSave(
                  onPressed:
                      viewModel //
                          .updateCommand
                          .value
                          .isRunning
                      ? null
                      : _handleSubmit, //
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
                  initialValue: _formatDate(dto.data),
                  validator: validator.byField(dto, 'data'),
                  onDateSelected: (date) => setState(() => dto.setData(date)),
                ),
                right: AppTextFormField(
                  label: 'Descrição',
                  icon: Icons.description_outlined,
                  initialValue: dto.descricao,
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

              // 3. Categoria (50%) + Centro de Custo (50%) (Referente ao Item 1)
              _FormRow(
                isDesktop: isDesktop,
                left: CategoriaField(
                  categorias: viewModel.categorias,
                  value: _categoriaId.isNotEmpty ? _categoriaId : null,
                  validator: validator.byField(dto, 'itensCategorias'),
                  onChanged: (categoriaId) {
                    setState(() {
                      _categoriaId = categoriaId ?? '';
                      _syncItem1();
                    });
                  },
                ),
                right: CentroCustoField(
                  centros: viewModel.centros,
                  value: _centroCustoId.isNotEmpty ? _centroCustoId : null,
                  validator: validator.byField(dto, 'itensCentrosCusto'),
                  onChanged: (centroCustoId) {
                    setState(() {
                      _centroCustoId = centroCustoId ?? '';
                      _syncItem1();
                    });
                  },
                ),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 4. Valor (25% - Desabilitado) + Observação (75%)
              _FormRow(
                isDesktop: isDesktop,
                leftFlex: 2,
                rightFlex: 5,
                left: AppCurrencyFormField(
                  label: 'Valor',
                  controller: _valorController,
                  validator: validator.byField(dto, 'itensValores'),
                  onChanged: (raw) {
                    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                    setState(() {
                      _valor = clean.isEmpty ? 0 : double.parse(clean) / 100;
                      _syncItem1();
                    });
                  },
                ),
                right: AppTextAreaFormField(
                  label: 'Observação',
                  initialValue: dto.observacao,
                  onChanged: (value) => dto.setObservacao(
                    value.isEmpty ? null : value, //
                  ),
                ),
              ),

              const AppSpacing(size: AppSpacingSize.lg),

              // Seção informativa do Modo de Lançamento (Tag somente leitura) + Detalhamento
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8, //
                      ),
                      child: Row(
                        children: [
                          const AppText(
                            'Modo de Lançamento',
                            variant: AppTextVariant.body, //
                          ),
                          const Spacer(),
                          AppTag(modeText, variant: AppTagVariant.neutral),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2, //
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.05,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8, //
                      ),
                      child: Row(
                        children: [
                          AppText(
                            'Detalhamento do Valor',
                            variant: AppTextVariant.body,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.list_alt_outlined,
                            size: 20,
                            color: theme.colorScheme.primary, //
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Painel de itens de distribuição (sempre visível no Update)
              LancamentoItensPanel(
                items: _itens,
                totalValor: _valor,
                categorias: viewModel.categorias,
                centros: viewModel.centros,
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
                      final msg = //
                      exception is DomainException
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
                      final msg = //
                      exception is DomainException
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
                    numero: numero, //
                  );
                  res.fold(
                    (updatedList) {
                      setState(() {
                        _itens = updatedList;
                        _updateTotalValor();
                      });
                    },
                    (exception) {
                      final msg = //
                      exception is DomainException
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
