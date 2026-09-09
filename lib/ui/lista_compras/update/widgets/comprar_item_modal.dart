import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/ui/lista_compras/update/viewmodels/lista_compras_comprar_viewmodel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ComprarItemModal extends ConsumerStatefulWidget {
  final ItemCompra item;
  final ListaCompras lista;

  const ComprarItemModal({
    super.key,
    required this.item,
    required this.lista,
  });

  static Future<void> show(
    BuildContext context, {
    required ItemCompra item,
    required ListaCompras lista,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ComprarItemModal(item: item, lista: lista),
    );
  }

  @override
  ConsumerState<ComprarItemModal> createState() => _ComprarItemModalState();
}

class _ComprarItemModalState extends ConsumerState<ComprarItemModal> {
  late TextEditingController _qtdController;
  late TextEditingController _supermercadoController;
  String? _supermercadoSelecionado;
  late ListaComprasComprarViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final initialQtd = widget.item.quantidadeComprada > 0
        ? widget.item.quantidadeComprada
        : widget.item.quantidadePlanejada;
    _qtdController = TextEditingController(text: initialQtd.toString());

    final ultimo = widget.item.supermercados
        .where((s) => s.ultimoUtilizado)
        .firstOrNull;

    _supermercadoSelecionado = ultimo?.nome;
    _supermercadoController = TextEditingController();

    _viewModel = ref.read(listaComprasComprarViewModelProvider);
    _viewModel.comprarItemCommand.addListener(_onCommandStateChanged);
  }

  @override
  void dispose() {
    _viewModel.comprarItemCommand.removeListener(_onCommandStateChanged);
    _qtdController.dispose();
    _supermercadoController.dispose();
    super.dispose();
  }

  void _onCommandStateChanged() {
    final commandValue = _viewModel.comprarItemCommand.value;
    commandValue.onSuccess((_) {
      if (mounted) Navigator.pop(context);
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception?.toString() ?? 'Erro ao registrar compra'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final comprarVm = ref.watch(listaComprasComprarViewModelProvider);
    final isLoading = comprarVm.comprarItemCommand.value.isRunning;

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
                Expanded(
                  child: Text(
                    'Comprar: ${widget.item.produto}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Planejado: ${widget.item.quantidadePlanejada} | Estimado: ${UtilBrasilFields.obterReal(widget.item.precoEstimado, moeda: true)}',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: _qtdController,
              label: 'Quantidade Comprada',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              readOnly: isLoading,
            ),
            const SizedBox(height: 16),
            Text(
              'Supermercado:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (widget.item.supermercados.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.item.supermercados.map((s) {
                  final selected = _supermercadoSelecionado == s.nome;
                  return ChoiceChip(
                    label: Text(s.nome),
                    selected: selected,
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
              const SizedBox(height: 8),
            ],
            AppTextFormField(
              controller: _supermercadoController,
              label: widget.item.supermercados.isEmpty
                  ? 'Nome do Supermercado'
                  : 'Ou digite outro supermercado',
              readOnly: isLoading,
              onChanged: (val) {
                if (val.trim().isNotEmpty) {
                  setState(() {
                    _supermercadoSelecionado = val.trim();
                  });
                }
              },
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
                    : const Icon(Icons.check_circle),
                label: Text(isLoading ? 'Salvando...' : 'Confirmar Compra'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        final qtd =
                            double.tryParse(
                              _qtdController.text.replaceAll(',', '.'),
                            ) ??
                            0;
                        final supermercado =
                            _supermercadoController.text.trim().isNotEmpty
                                ? _supermercadoController.text.trim()
                                : _supermercadoSelecionado;

                        _viewModel.comprarItemCommand.execute((
                          lista: widget.lista,
                          itemId: widget.item.id,
                          quantidadeComprada: qtd,
                          supermercadoNome: supermercado,
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
