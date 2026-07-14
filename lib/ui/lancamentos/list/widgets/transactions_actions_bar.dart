import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_create_modal.dart';
import 'package:zzuna/ui/lancamentos/reconcile/widgets/lancamentos_reconcile_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_data/widgets/lancamentos_update_data_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_data/widgets/lancamentos_update_data_modal.dart';
import 'package:zzuna/ui/lancamentos/shared/widgets/lancamentos_update_origem_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_origem/widgets/lancamentos_update_origem_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_selecionar_todos_button.dart';

class TransactionsActionsBar extends ConsumerWidget {
  final List<String> selectedIds;
  final VoidCallback onClearSelection;

  const TransactionsActionsBar({
    super.key,
    required this.selectedIds,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listViewModel = ref.watch(lancamentosListViewModelProvider);
    final hasSelection = selectedIds.isNotEmpty;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.slate50,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconSelecionarTodosButton(
            allSelected: listViewModel.allSelected,
            onPressed: () => listViewModel.toggleSelectAll(),
          ),
          const SizedBox(width: 24),
          
          // Fast Month Navigation
          Consumer(
            builder: (context, ref, _) {
              final filterState = ref.watch(lancamentoFilterProvider);
              final maxYear = DateTime.now().year + 2;

              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    onPressed: (filterState.mes == Mes.janeiro && filterState.ano == 2025)
                        ? null
                        : () {
                            ref.read(lancamentoFilterProvider.notifier).mesAnterior();
                            listViewModel.pesquisar();
                          },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${filterState.mes.descricao} / ${filterState.ano}',
                    style: const TextStyle(
                      color: AppColors.slate700,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    onPressed: (filterState.mes == Mes.dezembro && filterState.ano == maxYear)
                        ? null
                        : () {
                            ref.read(lancamentoFilterProvider.notifier).proximoMes();
                            listViewModel.pesquisar();
                          },
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(width: 24),
          
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            color: AppColors.primary,
            tooltip: 'Adicionar Entrada',
            onPressed: () => LancamentoCreateModal.show(
              context,
              initialTipo: LancamentoTipo.receita,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 20),
            color: Theme.of(context).colorScheme.error,
            tooltip: 'Adicionar Despesa',
            onPressed: () => LancamentoCreateModal.show(
              context,
              initialTipo: LancamentoTipo.despesa,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            color: AppColors.indigo600,
            tooltip: 'Adicionar transferência',
            onPressed: () => TransferenciaCreateModal.show(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          if (hasSelection && !listViewModel.isMesFechado) ...[
            const SizedBox(width: 16),
            LancamentosReconcileButton(
              conciliado: true,
              selectedIds: selectedIds,
              onSuccess: onClearSelection,
            ),
            const SizedBox(width: 16),
            LancamentosReconcileButton(
              conciliado: false,
              selectedIds: selectedIds,
              onSuccess: onClearSelection,
            ),
            const SizedBox(width: 16),
            LancamentosUpdateDataButton(
              onPressed: () {
                LancamentosUpdateDataModal.show(
                  context: context,
                  selectedIds: selectedIds,
                  onSuccess: onClearSelection,
                );
              },
            ),
            const SizedBox(width: 16),
            LancamentosUpdateOrigemButton(
              onPressed: () {
                LancamentosUpdateOrigemModal.show(
                  context: context,
                  selectedIds: selectedIds,
                  onSuccess: onClearSelection,
                );
              },
            ),
          ],
          const Spacer(),
          Icon(
            listViewModel.isMesFechado ? Icons.lock : Icons.lock_open,
            color: listViewModel.isMesFechado
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
