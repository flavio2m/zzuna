import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/update/viewmodels/lista_compras_duplicar_viewmodel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_year_stepper.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class DuplicarListaModal extends ConsumerStatefulWidget {
  final ListaCompras listaOrigem;

  const DuplicarListaModal({
    super.key,
    required this.listaOrigem,
  });

  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    ListaCompras listaOrigem,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DuplicarListaModal(listaOrigem: listaOrigem),
    );
  }

  @override
  ConsumerState<DuplicarListaModal> createState() => _DuplicarListaModalState();
}

class _DuplicarListaModalState extends ConsumerState<DuplicarListaModal> {
  late Mes _mesDestino;
  late int _anoDestino;
  late ListaComprasDuplicarViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(listaComprasFilterProvider);
    _mesDestino = currentFilter.mes.proximo;
    _anoDestino = currentFilter.mes == Mes.dezembro
        ? currentFilter.ano + 1
        : currentFilter.ano;

    _viewModel = ref.read(listaComprasDuplicarViewModelProvider);
    _viewModel.duplicarListaCommand.addListener(_onCommandStateChanged);
  }

  @override
  void dispose() {
    _viewModel.duplicarListaCommand.removeListener(_onCommandStateChanged);
    super.dispose();
  }

  void _onCommandStateChanged() {
    final commandValue = _viewModel.duplicarListaCommand.value;
    commandValue.onSuccess((_) {
      if (mounted) {
        Navigator.pop(context);
        final notifier = ref.read(listaComprasFilterProvider.notifier);
        notifier.setAno(_anoDestino);
        notifier.setMes(_mesDestino);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nova lista gerada com sucesso para ${_mesDestino.descricao}/$_anoDestino!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception?.toString() ?? 'Erro ao duplicar lista'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final maxYear = DateTime.now().year + 2;
    final duplicarVm = ref.watch(listaComprasDuplicarViewModelProvider);
    final isRunning = duplicarVm.duplicarListaCommand.value.isRunning;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gerar Nova Lista de Compras',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: isRunning ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Copiar os itens da lista atual para um novo mês. Itens comprados serão resetados para pendente com quantidade 0, mantendo os itens cancelados como cancelados.',
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppDropdownFormField<Mes>(
                  label: 'Mês de Destino',
                  value: _mesDestino,
                  items: Mes.values
                      .map(
                        (m) => AppDropdownMenuItem(
                          value: m,
                          label: m.descricao,
                        ),
                      )
                      .toList(),
                  onChanged: isRunning
                      ? null
                      : (val) {
                          if (val != null) {
                            setState(() {
                              _mesDestino = val;
                            });
                          }
                        },
                ),
              ),
              const SizedBox(width: 12),
              AppYearStepper(
                value: _anoDestino,
                min: 2025,
                max: maxYear,
                onChanged: (val) {
                  if (!isRunning) {
                    setState(() {
                      _anoDestino = val;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: isRunning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.copy),
              label: Text('Gerar Lista para ${_mesDestino.descricao}/$_anoDestino'),
              onPressed: isRunning
                  ? null
                  : () {
                      _viewModel.duplicarListaCommand.execute((
                        listaOrigem: widget.listaOrigem,
                        anoDestino: _anoDestino,
                        mesDestino: _mesDestino,
                      ));
                    },
            ),
          ),
        ],
      ),
    );
  }
}
