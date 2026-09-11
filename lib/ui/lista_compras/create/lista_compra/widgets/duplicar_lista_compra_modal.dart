import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/create/lista_compra/viewmodels/lista_compras_duplicar_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_year_stepper.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class DuplicarListaCompraModal extends ConsumerStatefulWidget {
  final ListaCompras listaOrigem;

  const DuplicarListaCompraModal({super.key, required this.listaOrigem});

  static void show(BuildContext context, ListaCompras listaOrigem) {
    AppDialog.show(
      context: context,
      child: DuplicarListaCompraModal(listaOrigem: listaOrigem),
    );
  }

  @override
  ConsumerState<DuplicarListaCompraModal> createState() =>
      _DuplicarListaCompraModalState();
}

class _DuplicarListaCompraModalState
    extends ConsumerState<DuplicarListaCompraModal> {
  late Mes _mesDestino;
  late int _anoDestino;
  late final ListaComprasDuplicarViewModel _viewModel;

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

        AppSnackBar.showSuccess(
          context,
          'Nova lista gerada com sucesso para ${_mesDestino.descricao}/$_anoDestino!',
        );
      }
    });
    commandValue.onFailure((exception) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro ao duplicar lista.',
        );
      }
    });
  }

  void _handleSubmit() {
    _viewModel.duplicarListaCommand.execute((
      listaOrigem: widget.listaOrigem,
      anoDestino: _anoDestino,
      mesDestino: _mesDestino,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final maxYear = DateTime.now().year + 2;
    final duplicarVm = ref.watch(listaComprasDuplicarViewModelProvider);
    final isRunning = duplicarVm.duplicarListaCommand.value.isRunning;

    return AppForm(
      title: 'Gerar Nova Lista de Compras',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: duplicarVm.duplicarListaCommand,
          builder: (_, _) {
            return ButtonSave(
              label: 'Gerar Lista',
              loading: isRunning,
              onPressed: isRunning ? null : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Copiar os itens da lista atual para um novo mês. Itens comprados '
            'serão resetados para pendente com quantidade 0, mantendo os itens '
            'cancelados como cancelados.',
            variant: AppTextVariant.body,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            children: [
              Expanded(
                child: AppDropdownFormField<Mes>(
                  label: 'Mês de Destino',
                  value: _mesDestino,
                  items: Mes.values
                      .map(
                        (m) =>
                            AppDropdownMenuItem(value: m, label: m.descricao),
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
              const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
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
        ],
      ),
    );
  }
}
