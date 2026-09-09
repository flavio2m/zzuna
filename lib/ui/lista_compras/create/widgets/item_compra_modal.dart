import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lista_compras/item_compra_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/ui/lista_compras/create/viewmodels/lista_compras_create_viewmodel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ItemCompraModal extends ConsumerStatefulWidget {
  final ItemCompra? item;

  const ItemCompraModal({super.key, this.item});

  static Future<void> show(BuildContext context, [ItemCompra? item]) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ItemCompraModal(item: item),
    );
  }

  @override
  ConsumerState<ItemCompraModal> createState() => _ItemCompraModalState();
}

class _ItemCompraModalState extends ConsumerState<ItemCompraModal> {
  late TextEditingController _produtoController;
  late TextEditingController _qtdPlanejadaController;
  late TextEditingController _precoEstimadoController;
  late TextEditingController _novoSupermercadoController;

  late List<SupermercadoItem> _supermercados;
  late ListaComprasCreateViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _produtoController = TextEditingController(
      text: widget.item?.produto ?? '',
    );
    _qtdPlanejadaController = TextEditingController(
      text: (widget.item?.quantidadePlanejada ?? 1.0).toString(),
    );
    _precoEstimadoController = TextEditingController(
      text: (widget.item?.precoEstimado ?? 0.0).toString(),
    );
    _novoSupermercadoController = TextEditingController();

    _supermercados = List<SupermercadoItem>.from(
      widget.item?.supermercados ?? [],
    );

    _viewModel = ref.read(listaComprasCreateViewModelProvider);
    _viewModel.salvarItemCommand.addListener(_onCommandStateChanged);
  }

  @override
  void dispose() {
    _viewModel.salvarItemCommand.removeListener(_onCommandStateChanged);
    _produtoController.dispose();
    _qtdPlanejadaController.dispose();
    _precoEstimadoController.dispose();
    _novoSupermercadoController.dispose();
    super.dispose();
  }

  void _onCommandStateChanged() {
    final commandValue = _viewModel.salvarItemCommand.value;
    commandValue.onSuccess((_) {
      if (mounted) Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception?.toString() ?? 'Erro ao salvar item'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  void _adicionarSupermercado() {
    final nome = _novoSupermercadoController.text.trim();
    if (nome.isNotEmpty &&
        !_supermercados.any(
          (s) => s.nome.toLowerCase() == nome.toLowerCase(),
        )) {
      setState(() {
        _supermercados.add(SupermercadoItem(nome: nome));
        _novoSupermercadoController.clear();
      });
    }
  }

  void _removerSupermercado(String nome) {
    setState(() {
      _supermercados.removeWhere((s) => s.nome == nome);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final createVm = ref.watch(listaComprasCreateViewModelProvider);
    final isLoading = createVm.salvarItemCommand.value.isRunning;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Editar Produto' : 'Novo Produto',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: _produtoController,
              label: 'Nome do Produto',
              autofocus: true,
              readOnly: isLoading,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _qtdPlanejadaController,
                    label: 'Qtd. Planejada',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    readOnly: isLoading,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextFormField(
                    controller: _precoEstimadoController,
                    label: 'Preço Estimado',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    readOnly: isLoading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Supermercados onde encontrar:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (_supermercados.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _supermercados.map((s) {
                  return Chip(
                    label: Text(s.nome),
                    deleteIcon: isLoading
                        ? null
                        : const Icon(Icons.close, size: 16),
                    onDeleted: isLoading
                        ? null
                        : () => _removerSupermercado(s.nome),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _novoSupermercadoController,
                    label: 'Adicionar Supermercado',
                    readOnly: isLoading,
                    onFieldSubmitted: (_) => _adicionarSupermercado(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: isLoading ? null : _adicionarSupermercado,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isLoading
                      ? 'Salvando...'
                      : (isEditing ? 'Salvar Alterações' : 'Adicionar à Lista'),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        final produto = _produtoController.text.trim();
                        final qtd =
                            double.tryParse(
                              _qtdPlanejadaController.text.replaceAll(',', '.'),
                            ) ??
                            1.0;
                        final preco =
                            double.tryParse(
                              _precoEstimadoController.text.replaceAll(
                                ',',
                                '.',
                              ),
                            ) ??
                            0.0;

                        final dto = ItemCompraDto(
                          id: widget.item?.id,
                          produto: produto,
                          quantidadePlanejada: qtd,
                          quantidadeComprada:
                              widget.item?.quantidadeComprada ?? 0.0,
                          precoEstimado: preco,
                          supermercados: _supermercados,
                          situacao:
                              widget.item?.situacao ??
                              ItemCompraSituacao.pendente,
                        );

                        final listVm = ref.read(
                          listaComprasListViewModelProvider,
                        );
                        _viewModel.salvarItemCommand.execute((
                          dto: dto,
                          filter: listVm.filter,
                          listaAtual: listVm.listaAtual,
                        ));
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
