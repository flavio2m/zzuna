import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_day_card.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transactions_actions_bar.dart';
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

          final selectedIds = viewModel.selectedLancamentoIds.toList();

          final actionsBar = TransactionsActionsBar(
            selectedIds: selectedIds,
            onClearSelection: () => viewModel.clearSelection(),
          );

          Widget content;
          if (resumoMensal == null || resumoMensal.dias.isEmpty) {
            content = Column(
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
          } else {
            final dias = resumoMensal.dias;
            content = Column(
              children: [
                actionsBar,
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: dias.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final dia = dias[index];
                      return TransactionDayCard(dia: dia);
                    },
                  ),
                ),
              ],
            );
          }

          if (state.isRunning) {
            return Stack(
              children: [
                content,
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              ],
            );
          }

          return content;
        },
      ),
    );
  }
}
