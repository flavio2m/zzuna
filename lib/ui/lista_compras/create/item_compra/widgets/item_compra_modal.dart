import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lista_compras/item_compra_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/validators/item_compra_validator.dart';
import 'package:zzuna/ui/lista_compras/create/item_compra/viewmodels/item_compras_create_viewmodel.dart';
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

class ItemCompraModal extends ConsumerStatefulWidget {
  final ItemCompra? item;
  final ItemCompra? cloneItem;

  const ItemCompraModal({super.key, this.item, this.cloneItem});

  static void show(
    BuildContext context, {
    ItemCompra? item,
    ItemCompra? cloneItem,
  }) {
    AppDialog.show(
      context: context,
      child: ItemCompraModal(item: item, cloneItem: cloneItem),
    );
  }

  @override
  ConsumerState<ItemCompraModal> createState() => _ItemCompraModalState();
}

class _ItemCompraModalState extends ConsumerState<ItemCompraModal> {
  late final ItemCompraDto dto;
  final validator = ItemCompraValidator<ItemCompraDto>();
  late final ItemComprasCreateViewModel viewModel;

  late TextEditingController _novoSupermercadoController;

  final _produtoFocus = FocusNode();
  final _qtdFocus = FocusNode();
  final _precoFocus = FocusNode();
  final _supermercadoFocus = FocusNode();
  final _observacaoFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(listaComprasCreateViewModelProvider);
    viewModel.salvarItemCommand.addListener(_commandListener);

    if (widget.item != null) {
      dto = ItemCompraDto(
        id: widget.item!.id,
        produto: widget.item!.produto,
        quantidadePlanejada: widget.item!.quantidadePlanejada,
        quantidadeComprada: widget.item!.quantidadeComprada,
        precoEstimado: widget.item!.precoEstimado,
        supermercados: List<SupermercadoItem>.from(widget.item!.supermercados),
        situacao: widget.item!.situacao,
        observacao: widget.item!.observacao,
      );
    } else if (widget.cloneItem != null) {
      dto = ItemCompraDto(
        produto: widget.cloneItem!.produto,
        quantidadePlanejada: widget.cloneItem!.quantidadePlanejada,
        quantidadeComprada: 0.0,
        precoEstimado: widget.cloneItem!.precoEstimado,
        supermercados: List<SupermercadoItem>.from(
          widget.cloneItem!.supermercados,
        ),
        situacao: ItemCompraSituacao.pendente,
        observacao: widget.cloneItem!.observacao,
      );
    } else {
      final listVm = ref.read(listaComprasListViewModelProvider);
      final disponiveis = listVm.supermercadosDisponiveis;
      final supers = <SupermercadoItem>[];

      for (int i = 0; i < disponiveis.length; i++) {
        supers.add(
          SupermercadoItem(nome: disponiveis[i], ultimoUtilizado: i == 0),
        );
      }

      dto = ItemCompraDto(supermercados: supers);
    }

    dto.supermercados.sort(
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
    );

    _novoSupermercadoController = TextEditingController();
  }

  @override
  void dispose() {
    viewModel.salvarItemCommand.removeListener(_commandListener);

    _novoSupermercadoController.dispose();

    _produtoFocus.dispose();
    _qtdFocus.dispose();
    _precoFocus.dispose();
    _supermercadoFocus.dispose();
    _observacaoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.salvarItemCommand.value;
    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(
        context,
        widget.item != null
            ? 'Produto atualizado com sucesso.'
            : 'Produto criado com sucesso.',
      );
      if (mounted) Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro ao salvar produto.',
        );
      }
    });
  }

  bool get _canSubmit {
    return validator.validate(dto).isValid;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      final listVm = ref.read(listaComprasListViewModelProvider);
      viewModel.salvarItemCommand.execute((
        dto: dto,
        filter: listVm.filter,
        listaAtual: listVm.listaAtual,
      ));
    }
  }

  void _adicionarSupermercado() {
    final nome = _novoSupermercadoController.text.trim();
    if (nome.isNotEmpty &&
        !dto.supermercados.any(
          (s) => s.nome.toLowerCase() == nome.toLowerCase(),
        )) {
      final isPrimeiro =
          dto.supermercados.isEmpty ||
          !dto.supermercados.any((s) => s.ultimoUtilizado);

      final updated = List<SupermercadoItem>.from(dto.supermercados)
        ..add(SupermercadoItem(nome: nome, ultimoUtilizado: isPrimeiro))
        ..sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));

      dto.setSupermercados(updated);
      _novoSupermercadoController.clear();
      setState(() {});
      _supermercadoFocus.requestFocus();
    }
  }

  void _adicionarTodosSupermercados() {
    final listVm = ref.read(listaComprasListViewModelProvider);
    final disponiveis = listVm.supermercadosDisponiveis;

    if (disponiveis.isEmpty) return;

    final updated = List<SupermercadoItem>.from(dto.supermercados);
    final temPadrao = updated.any((s) => s.ultimoUtilizado);

    for (final nome in disponiveis) {
      final jaExiste = updated.any(
        (s) => s.nome.toLowerCase() == nome.trim().toLowerCase(),
      );
      if (!jaExiste) {
        final isPrimeiro = updated.isEmpty && !temPadrao;
        updated.add(
          SupermercadoItem(nome: nome.trim(), ultimoUtilizado: isPrimeiro),
        );
      }
    }

    updated.sort(
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
    );

    dto.setSupermercados(updated);
    setState(() {});
  }

  void _removerSupermercado(String nome) {
    final updated = List<SupermercadoItem>.from(dto.supermercados);
    updated.removeWhere((s) => s.nome == nome);
    if (updated.isNotEmpty && !updated.any((s) => s.ultimoUtilizado)) {
      updated[0] = updated[0].copyWith(ultimoUtilizado: true);
    }
    dto.setSupermercados(updated);
    setState(() {});
  }

  void _definirSupermercadoPadrao(String nome) {
    final updated = dto.supermercados.map((s) {
      return s.copyWith(ultimoUtilizado: s.nome == nome);
    }).toList();
    dto.setSupermercados(updated);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    final createVm = ref.watch(listaComprasCreateViewModelProvider);

    return AppForm(
      title: isEditing ? 'Editar Produto' : 'Novo Produto',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: createVm.salvarItemCommand,
          builder: (_, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              loading: createVm.salvarItemCommand.value.isRunning,
              onPressed:
                  createVm.salvarItemCommand.value.isRunning || !_canSubmit
                  ? null
                  : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextFormField(
            label: 'Nome do Produto',
            autofocus: true,
            focusNode: _produtoFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _qtdFocus.requestFocus(),
            initialValue: dto.produto,
            onChanged: (value) {
              dto.setProduto(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'produto'),
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            children: [
              Expanded(
                child: AppIntegerFormField(
                  label: 'Qtd. Planejada',
                  focusNode: _qtdFocus,
                  min: 1,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _precoFocus.requestFocus(),
                  initialValue: dto.quantidadePlanejada.toInt().toString(),
                  onChanged: (value) {
                    dto.setQuantidadePlanejada(double.tryParse(value) ?? 1.0);
                    setState(() {});
                  },
                  validator: validator.byField(dto, 'quantidadePlanejada'),
                ),
              ),
              const AppSpacing(size: AppSpacingSize.md, axis: Axis.horizontal),
              Expanded(
                child: AppCurrencyFormField(
                  label: 'Preço Estimado',
                  focusNode: _precoFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _supermercadoFocus.requestFocus(),
                  initialValue: dto.precoEstimado > 0
                      ? UtilBrasilFields.obterReal(
                          dto.precoEstimado,
                          moeda: true,
                        )
                      : '',
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      dto.setPrecoEstimado(
                        UtilBrasilFields.converterMoedaParaDouble(value),
                      );
                    } else {
                      dto.setPrecoEstimado(0.0);
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.md),
          const AppText(
            'Supermercados onde encontrar (clique para definir o padrão):',
            variant: AppTextVariant.subtitle,
          ),
          const AppSpacing(size: AppSpacingSize.xs),
          if (dto.supermercados.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: dto.supermercados.map((s) {
                final isPadrao = s.ultimoUtilizado;
                return FilterChip(
                  selected: isPadrao,
                  showCheckmark: false,
                  avatar: isPadrao
                      ? const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.indigo600,
                        )
                      : null,
                  label: AppText(
                    s.nome,
                    variant: AppTextVariant.body,
                    fontWeight: isPadrao ? FontWeight.bold : FontWeight.normal,
                    color: isPadrao ? AppColors.indigo600 : null,
                  ),
                  selectedColor: AppColors.indigo600.withValues(alpha: 0.15),
                  side: BorderSide(
                    color: isPadrao
                        ? AppColors.indigo600
                        : Theme.of(context).dividerColor,
                  ),
                  deleteIcon: createVm.salvarItemCommand.value.isRunning
                      ? null
                      : const Icon(Icons.close, size: 16),
                  onDeleted: createVm.salvarItemCommand.value.isRunning
                      ? null
                      : () => _removerSupermercado(s.nome),
                  onSelected: createVm.salvarItemCommand.value.isRunning
                      ? null
                      : (_) => _definirSupermercadoPadrao(s.nome),
                );
              }).toList(),
            ),
            const AppSpacing(size: AppSpacingSize.xs),
          ],
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: _novoSupermercadoController,
                  focusNode: _supermercadoFocus,
                  label: 'Adicionar Supermercado',
                  readOnly: createVm.salvarItemCommand.value.isRunning,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    if (_novoSupermercadoController.text.trim().isNotEmpty) {
                      _adicionarSupermercado();
                    } else {
                      _observacaoFocus.requestFocus();
                    }
                  },
                ),
              ),
              const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
              IconButton(
                tooltip: 'Adicionar',
                icon: const Icon(Icons.add_circle_outline),
                color: Theme.of(context).colorScheme.primary,
                onPressed: createVm.salvarItemCommand.value.isRunning
                    ? null
                    : _adicionarSupermercado,
              ),
              IconButton(
                tooltip: 'Adicionar todos os supermercados',
                icon: const Icon(Icons.playlist_add),
                color: Theme.of(context).colorScheme.primary,
                onPressed: createVm.salvarItemCommand.value.isRunning
                    ? null
                    : _adicionarTodosSupermercados,
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppTextAreaFormField(
            label: 'Observação',
            focusNode: _observacaoFocus,
            minLines: 1,
            maxLines: 2,
            initialValue: dto.observacao,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _saveFocus.requestFocus(),
            onChanged: (value) {
              dto.setObservacao(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
