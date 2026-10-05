import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/viewmodels/lista_compras_comprar_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_integer_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:zzuna/utils/formatters/date_formatter.dart';

class EditarRegistroCompraModal extends ConsumerStatefulWidget {
  final ListaCompras lista;
  final ItemCompra item;
  final int registroIndex;
  final RegistroCompra registro;

  const EditarRegistroCompraModal({
    super.key,
    required this.lista,
    required this.item,
    required this.registroIndex,
    required this.registro,
  });

  static void show(
    BuildContext context, {
    required ListaCompras lista,
    required ItemCompra item,
    required int registroIndex,
    required RegistroCompra registro,
  }) {
    AppDialog.show(
      context: context,
      child: EditarRegistroCompraModal(
        lista: lista,
        item: item,
        registroIndex: registroIndex,
        registro: registro,
      ),
    );
  }

  @override
  ConsumerState<EditarRegistroCompraModal> createState() =>
      _EditarRegistroCompraModalState();
}

class _EditarRegistroCompraModalState
    extends ConsumerState<EditarRegistroCompraModal> {
  late final TextEditingController _qtdController;
  late final TextEditingController _supermercadoController;
  String? _supermercadoSelecionado;
  late double _precoReal;
  late DateTime _dataCompra;
  late final ListaComprasComprarViewModel _viewModel;

  final _dataFocus = FocusNode();
  final _qtdFocus = FocusNode();
  final _precoFocus = FocusNode();
  final _supermercadoFocus = FocusNode();
  final _saveFocus = FocusNode();

  String _formatNum(double num) {
    return num % 1 == 0 ? num.toInt().toString() : num.toString();
  }

  @override
  void initState() {
    super.initState();
    _dataCompra = widget.registro.data;

    final qtd = widget.registro.quantidade;
    final formattedQtd = qtd % 1 == 0
        ? qtd.toInt().toString()
        : qtd.round().toString();
    _qtdController = TextEditingController(text: formattedQtd);

    _precoReal = widget.registro.precoReal;

    _supermercadoSelecionado = widget.registro.supermercadoNome;
    _supermercadoController = TextEditingController();

    // Se o supermercado do registro não estiver nos supermercados pré-cadastrados, preenche o controller
    final existsInList = widget.item.supermercados.any(
      (s) =>
          s.nome.toLowerCase() ==
          (widget.registro.supermercadoNome ?? '').toLowerCase(),
    );
    if (!existsInList &&
        widget.registro.supermercadoNome != null &&
        widget.registro.supermercadoNome!.isNotEmpty) {
      _supermercadoController.text = widget.registro.supermercadoNome!;
    }

    _viewModel = ref.read(listaComprasComprarViewModelProvider);
    _viewModel.editarRegistroCompraCommand.addListener(_commandListener);
    _qtdFocus.addListener(_qtdFocusListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _dataFocus.requestFocus();
      }
    });
  }

  void _qtdFocusListener() {
    if (_qtdFocus.hasFocus && _qtdController.text.isNotEmpty) {
      _qtdController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _qtdController.text.length,
      );
    }
  }

  @override
  void dispose() {
    _viewModel.editarRegistroCompraCommand.removeListener(_commandListener);
    _qtdFocus.removeListener(_qtdFocusListener);
    _qtdController.dispose();
    _supermercadoController.dispose();

    _dataFocus.dispose();
    _qtdFocus.dispose();
    _precoFocus.dispose();
    _supermercadoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = _viewModel.editarRegistroCompraCommand.value;
    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Compra atualizada com sucesso.');
      if (mounted) Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro ao atualizar compra.',
        );
      }
    });
  }

  bool get _canSubmit {
    final text = _qtdController.text.trim();
    if (text.isEmpty) return false;
    final val = int.tryParse(text);
    return val != null && val > 0;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      final qtd = double.tryParse(_qtdController.text.trim()) ?? 0;
      final supermercado = _supermercadoController.text.trim().isNotEmpty
          ? _supermercadoController.text.trim()
          : _supermercadoSelecionado;

      _viewModel.editarRegistroCompraCommand.execute((
        lista: widget.lista,
        itemId: widget.item.id,
        registroIndex: widget.registroIndex,
        data: _dataCompra,
        quantidade: qtd,
        precoReal: _precoReal,
        supermercadoNome: supermercado,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final comprarVm = ref.watch(listaComprasComprarViewModelProvider);
    final isLoading = comprarVm.editarRegistroCompraCommand.value.isRunning;

    return AppForm(
      title: 'Editar Compra',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: comprarVm.editarRegistroCompraCommand,
          builder: (_, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              label: 'Salvar',
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
                  'Planejado: ${_formatNum(widget.item.quantidadePlanejada)}',
                  variant: AppTextVariant.caption,
                  color: AppColors.slate600,
                ),
              ],
            ),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppDateFormField(
            label: 'Data da Compra',
            focusNode: _dataFocus,
            autofocus: true,
            initialValue: DateFormatter.dma(_dataCompra),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _qtdFocus.requestFocus(),
            onDateSelected: (date) {
              setState(() {
                _dataCompra = date;
              });
            },
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            children: [
              Expanded(
                child: AppIntegerFormField(
                  label: 'Quantidade Comprada',
                  controller: _qtdController,
                  focusNode: _qtdFocus,
                  autofocus: false,
                  min: 1,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _precoFocus.requestFocus(),
                  onChanged: (_) => setState(() {}),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'A quantidade comprada é obrigatória';
                    }
                    final parsed = int.tryParse(val);
                    if (parsed == null || parsed <= 0) {
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
                  initialValue: _precoReal > 0
                      ? UtilBrasilFields.obterReal(_precoReal, moeda: true)
                      : '',
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _precoReal = UtilBrasilFields.converterMoedaParaDouble(
                        value,
                      );
                    } else {
                      _precoReal = 0.0;
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
            onFieldSubmitted: (_) => _saveFocus.requestFocus(),
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
        ],
      ),
    );
  }
}
