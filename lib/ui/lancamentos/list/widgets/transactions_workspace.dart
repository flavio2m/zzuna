import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_conciliado_button.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_day_card.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class TransactionsWorkspace extends ConsumerWidget {
  const TransactionsWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(lancamentosListViewModelProvider);

    return Container(
      color: AppColors.background,
      child: ListenableBuilder(
        listenable: Listenable.merge([viewModel.loadCommand, viewModel]),
        builder: (context, _) {
          final state = viewModel.loadCommand.value;
          final resumoMensal = viewModel.resumoMensal;

          if (state.isRunning && resumoMensal == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Text(
                'Erro ao carregar lançamentos: ${state.getExceptionOrNull()}',
                style: const TextStyle(color: AppColors.danger),
              ),
            );
          }

          final hasSelection = viewModel.selectedLancamentoIds.isNotEmpty;

          final actionsBar = Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.slate50,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  color: AppColors.primary,
                  tooltip: 'Adicionar lançamento',
                  onPressed: () => LancamentoCreateModal.show(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
                if (hasSelection) ...[
                  const SizedBox(width: 16),
                  IconConciliadoButton(
                    conciliado: true,
                    size: 20,
                    tooltip: 'Conciliar selecionados',
                    onPressed: () {
                      final ids = viewModel.selectedLancamentoIds.toList();
                      ref.read(lancamentoReconcileViewModelProvider).reconcileCommand.execute((
                        ids: ids,
                        conciliado: true,
                      ));
                      viewModel.clearSelection();
                    },
                  ),
                  const SizedBox(width: 16),
                  IconConciliadoButton(
                    conciliado: false,
                    size: 20,
                    tooltip: 'Desconciliar selecionados',
                    onPressed: () {
                      final ids = viewModel.selectedLancamentoIds.toList();
                      ref.read(lancamentoReconcileViewModelProvider).reconcileCommand.execute((
                        ids: ids,
                        conciliado: false,
                      ));
                      viewModel.clearSelection();
                    },
                  ),
                ],
              ],
            ),
          );

          if (resumoMensal == null || resumoMensal.dias.isEmpty) {
            return Column(
              children: [
                actionsBar,
                const Expanded(
                  child: Center(
                    child: Text(
                      'Nenhum lançamento encontrado.',
                      style: TextStyle(
                        color: AppColors.slate500, //
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final dias = resumoMensal.dias;

          return Column(
            children: [
              actionsBar,
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: dias.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final dia = dias[index];
                    return TransactionDayCard(dia: dia);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
