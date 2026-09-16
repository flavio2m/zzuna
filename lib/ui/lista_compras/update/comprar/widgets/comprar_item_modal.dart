import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/viewmodels/lista_compras_comprar_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_area_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ComprarItemModal extends ConsumerStatefulWidget {
  final ItemCompra item;
  final ListaCompras lista;

  const ComprarItemModal({super.key, required this.item, required this.lista});

  static void show(
    BuildContext context, {
    required ItemCompra item,
    required ListaCompras lista,
  }) {
    AppDialog.show(
      context: context,
      child: ComprarItemModal(item: item, lista: lista),
    );
  }

  @override
  ConsumerState<ComprarItemModal> createState() => _ComprarItemModalState();
}

class _ComprarItemModalState extends ConsumerState<ComprarItemModal> {
  late final TextEditingController _qtdController;
  late final TextEditingController _supermercadoController;
  String? _supermercadoSelecionado;
  late String _observacao;
  late double _precoEstimado;
  late final ListaComprasComprarViewModel _viewModel;

  final _qtdFocus = FocusNode();
  final _precoFocus = FocusNode();
  final _supermercadoFocus = FocusNode();
  final _observacaoFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final initialQtd = widget.item.quantidadeComprada > 0
        ? widget.item.quantidadeComprada
        : widget.item.quantidadePlanejada;
    final formattedQtd = initialQtd % 1 == 0
        ? initialQtd.toInt().toString()
        : initialQtd.round().toString();
    _qtdController = TextEditingController(text: formattedQtd);

    final ultimo = widget.item.supermercados
        .where((s) => s.ultimoUtilizado)
        .firstOrNull;

    _supermercadoSelecionado = ultimo?.nome;
    _supermercadoController = TextEditingController();
    _observacao = widget.item.observacao;
    _precoEstimado = widget.item.precoEstimado;

    _viewModel = ref.read(listaComprasComprarViewModelProvider);
    _viewModel.comprarItemCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    _viewModel.comprarItemCommand.removeListener(_commandListener);
    _qtdController.dispose();
    _supermercadoController.dispose();

    _qtdFocus.dispose();
    _precoFocus.dispose();
    _supermercadoFocus.dispose();
    _observacaoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.comprarItemCommand.value;
    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(
        context,
        widget.item.situacao == ItemCompraSituacao.comprado
            ? 'Compra atualizada com sucesso.'
            : 'Compra registrada com sucesso.',
      );
      if (mounted) Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro ao registrar compra.',
        );
      }
    });
  }

  bool get _canSubmit {
    final text = _qtdController.text.trim();
    if (text.isEmpty) return false;
    final val = int.tryParse(text);
    return val != null && val >= 0;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      final qtd = double.tryParse(_qtdController.text.trim()) ?? 0;
      final supermercado = _supermercadoController.text.trim().isNotEmpty
          ? _supermercadoController.text.trim()
          : _supermercadoSelecionado;

      _viewModel.comprarItemCommand.execute((
        lista: widget.lista,
        itemId: widget.item.id,
        quantidadeComprada: qtd,
        supermercadoNome: supermercado,
        observacao: _observacao,
        precoEstimado: _precoEstimado,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final comprarVm = ref.watch(listaComprasComprarViewModelProvider);
    final isLoading = comprarVm.comprarItemCommand.value.isRunning;
    final isComprado = widget.item.situacao == ItemCompraSituacao.comprado;

    return AppForm(
      title: isComprado ? 'Editar Compra' : 'Comprar Item',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: comprarVm.comprarItemCommand,
          builder: (_, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              label: isComprado ? 'Atualizar' : 'Comprar',
              loading: isLoading,
              onPressed: isLoading || !_canSubmit ? null : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  widget.item.produto,
                  variant: AppTextVariant.subtitle,
                  fontWeight: FontWeight.bold,
                ),
                const AppSpacing(size: AppSpacingSize.xs),
                AppText(
                  'Planejado: ${widget.item.quantidadePlanejada % 1 == 0 ? widget.item.quantidadePlanejada.toInt() : widget.item.quantidadePlanejada}',
                  variant: AppTextVariant.caption,
                  color: AppColors.slate600,
                ),
              ],
            ),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            children: [
              Expanded(
                child: AppIntegerFormField(
                  label: 'Quantidade Comprada',
                  controller: _qtdController,
                  focusNode: _qtdFocus,
                  autofocus: true,
                  min: 0,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _precoFocus.requestFocus(),
                  onChanged: (_) => setState(() {}),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'A quantidade comprada é obrigatória';
                    }
                    final parsed = int.tryParse(val);
                    if (parsed == null || parsed < 0) {
                      return 'Quantidade inválida';
                    }
                    return null;
                  },
                ),
              ),
              const AppSpacing(size: AppSpacingSize.md, axis: Axis.horizontal),
              Expanded(
                child: AppCurrencyFormField(
                  label: 'Preço',
                  focusNode: _precoFocus,
                  readOnly: isLoading,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _supermercadoFocus.requestFocus(),
                  initialValue: _precoEstimado > 0
                      ? UtilBrasilFields.obterReal(_precoEstimado, moeda: true)
                      : '',
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _precoEstimado =
                          UtilBrasilFields.converterMoedaParaDouble(value);
                    } else {
                      _precoEstimado = 0.0;
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.md),
          const AppText(
            'Supermercado onde comprou:',
            variant: AppTextVariant.subtitle,
          ),
          const AppSpacing(size: AppSpacingSize.xs),
          if (widget.item.supermercados.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: widget.item.supermercados.map((s) {
                final isSelected = _supermercadoSelecionado == s.nome;
                return FilterChip(
                  selected: isSelected,
                  showCheckmark: false,
                  avatar: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.indigo600,
                        )
                      : null,
                  label: AppText(
                    s.nome,
                    variant: AppTextVariant.body,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? AppColors.indigo600 : null,
                  ),
                  selectedColor: AppColors.indigo600.withValues(alpha: 0.15),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.indigo600
                        : Theme.of(context).dividerColor,
                  ),
                  onSelected: isLoading
                      ? null
                      : (val) {
                          setState(() {
                            _supermercadoSelecionado = val ? s.nome : null;
                            if (val) _supermercadoController.clear();
                          });
                        },
                );
              }).toList(),
            ),
            const AppSpacing(size: AppSpacingSize.xs),
          ],
          AppTextFormField(
            controller: _supermercadoController,
            focusNode: _supermercadoFocus,
            label: widget.item.supermercados.isEmpty
                ? 'Nome do Supermercado'
                : 'Ou digite outro supermercado',
            readOnly: isLoading,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _observacaoFocus.requestFocus(),
            onChanged: (val) {
              setState(() {
                if (val.trim().isNotEmpty) {
                  _supermercadoSelecionado = val.trim();
                } else {
                  _supermercadoSelecionado = null;
                }
              });
            },
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppTextAreaFormField(
            label: 'Observação',
            focusNode: _observacaoFocus,
            minLines: 1,
            maxLines: 2,
            initialValue: _observacao,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _saveFocus.requestFocus(),
            onChanged: (value) {
              _observacao = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
