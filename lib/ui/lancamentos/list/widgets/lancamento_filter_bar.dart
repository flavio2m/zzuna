import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';
import 'package:zzuna/ui/lancamentos/list/viewmodels/lancamentos_list_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_year_stepper.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transactions_actions_bar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentoFilterBar extends ConsumerStatefulWidget {
  const LancamentoFilterBar({super.key});

  @override
  ConsumerState<LancamentoFilterBar> createState() =>
      _LancamentoFilterBarState();
}

class _LancamentoFilterBarState extends ConsumerState<LancamentoFilterBar> {
  late final TextEditingController _descricaoController;
  late final FocusNode _descricaoFocusNode;

  bool _isLoadingFechamento = false;

  @override
  void initState() {
    super.initState();
    final filterState = ref.read(lancamentoFilterProvider);
    _descricaoController = TextEditingController(text: filterState.descricao);
    _descricaoFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _descricaoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(lancamentosListViewModelProvider);
    final filterState = ref.watch(lancamentoFilterProvider);
    final maxYear = DateTime.now().year + 2;

    return AppFilterCard(
      initiallyExpanded: false,
      collapsedHeaderAction: TransactionsActionsBar(
        selectedIds: viewModel.selectedLancamentoIds.toList(),
        onClearSelection: () => viewModel.clearSelection(),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildPeriodNavigator(filterState, maxYear),
          // 3. Descrição
          SizedBox(
            width: 250,
            child: AppTextFormField(
              controller: _descricaoController,
              focusNode: _descricaoFocusNode,
              textInputAction: TextInputAction.search,
              label: 'Descrição',
              onFieldSubmitted: (value) {
                ref.read(lancamentoFilterProvider.notifier).setDescricao(value);
                viewModel.pesquisar();
              },
            ),
          ),
          // 4. Tipo
          SizedBox(
            width: 128,
            child: AppDropdownFormField<LancamentoTipo?>(
              label: 'Tipo',
              value: filterState.tipo,
              items: [
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: null,
                  label: 'Todos', //
                ),
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: LancamentoTipo.receita,
                  label: LancamentoTipo.receita.descricao,
                ),
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: LancamentoTipo.despesa,
                  label: LancamentoTipo.despesa.descricao,
                ),
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: LancamentoTipo.transferencia,
                  label: LancamentoTipo.transferencia.descricao,
                ),
              ],
              onChanged: (value) {
                ref.read(lancamentoFilterProvider.notifier).setTipo(value);
              },
            ),
          ),
          // 5. Conciliado (AppDropdownFormField)
          SizedBox(
            width: 160,
            child: AppDropdownFormField<bool?>(
              label: 'Conciliado',
              value: filterState.conciliado,
              items: [
                AppDropdownMenuItem<bool?>(value: null, label: 'Todos'),
                AppDropdownMenuItem<bool?>(value: true, label: 'Conciliado'),
                AppDropdownMenuItem<bool?>(
                  value: false,
                  label: 'Não conciliado',
                ),
              ],
              onChanged: (value) {
                ref
                    .read(lancamentoFilterProvider.notifier)
                    .setConciliado(value);
              },
            ),
          ),
          // 6. Pesquisar
          ButtonFind(
            onPressed: () {
              ref //
                  .read(lancamentoFilterProvider.notifier)
                  .setDescricao(_descricaoController.text);
              viewModel.pesquisar();
            },
          ),
          // 7. Adicionar
          ButtonAdd(
            label: 'Entrada',
            onPressed: () => LancamentoCreateModal.show(
              context,
              initialTipo: LancamentoTipo.receita,
            ),
          ),
          ButtonAdd(
            label: 'Despesa',
            icon: Icons.arrow_downward,
            color: Theme.of(context).colorScheme.error,
            onPressed: () => LancamentoCreateModal.show(
              context,
              initialTipo: LancamentoTipo.despesa,
            ),
          ),
          ButtonAdd(
            icon: Icons.swap_horiz_rounded,
            label: 'Transferência',
            color: AppColors.indigo600,
            onPressed: () => TransferenciaCreateModal.show(context),
          ),
          _buildFechamentoButton(viewModel),
        ],
      ),
    );
  }

  Widget _buildFechamentoButton(LancamentosListViewModel viewModel) {
    final isFechado = viewModel.isMesFechado;

    return ButtonAdd(
      label: isFechado ? 'Reabrir Mês' : 'Fechar Mês',
      icon: isFechado ? Icons.lock : Icons.lock_open,
      color: isFechado ? Colors.green : Theme.of(context).colorScheme.primary,
      loading: _isLoadingFechamento,
      onPressed: () async {
        setState(() {
          _isLoadingFechamento = true;
        });

        if (isFechado) {
          final result = await viewModel.reabrirMes();
          if (mounted) {
            if (result.isError()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.exceptionOrNull()!.toString()),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mês reaberto com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else {
          final result = await viewModel.fecharMes();
          if (mounted) {
            if (result.isError()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.exceptionOrNull()!.toString()),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mês fechado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        }

        if (mounted) {
          setState(() {
            _isLoadingFechamento = false;
          });
        }
      },
    );
  }

  Widget _buildPeriodNavigator(dynamic filterState, int maxYear) {
    final notifier = ref.read(lancamentoFilterProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              (filterState.mes == Mes.janeiro && filterState.ano == 2025) //
              ? null
              : () => notifier.mesAnterior(),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 108,
          child: AppDropdownFormField<Mes>(
            label: 'Mês',
            value: filterState.mes,
            items: Mes.values
                .map(
                  (mes) =>
                      AppDropdownMenuItem(value: mes, label: mes.descricao), //
                )
                .toList(),
            onChanged: (value) {
              notifier.setMes(value);
            },
          ),
        ),
        const SizedBox(width: 8),
        AppYearStepper(
          value: filterState.ano,
          min: 2025,
          max: maxYear,
          onChanged: (value) {
            notifier.setAno(value);
          },
        ),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed:
              (filterState.mes == Mes.dezembro && filterState.ano == maxYear)
              ? null
              : () => notifier.proximoMes(),
        ),
      ],
    );
  }
}
