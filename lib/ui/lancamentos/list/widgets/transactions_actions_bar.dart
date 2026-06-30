import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_create_modal.dart';
import 'package:zzuna/ui/lancamentos/reconcile/widgets/lancamentos_reconcile_button.dart';
import 'package:zzuna/ui/lancamentos/update_data/widgets/lancamentos_update_data_button.dart';
import 'package:zzuna/ui/lancamentos/update_data/widgets/lancamentos_update_data_modal.dart';
import 'package:zzuna/ui/lancamentos/update_metadata/widgets/lancamentos_update_metadata_button.dart';
import 'package:zzuna/ui/lancamentos/update_metadata/widgets/lancamentos_update_metadata_modal.dart';
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
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            color: AppColors.primary,
            tooltip: 'Adicionar lançamento',
            onPressed: () => LancamentoCreateModal.show(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            color: AppColors.primary,
            tooltip: 'Transferência de valores',
            onPressed: () => TransferenciaCreateModal.show(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          if (hasSelection) ...[
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
            LancamentosUpdateMetadataButton(
              onPressed: () {
                LancamentosUpdateMetadataModal.show(
                  context: context,
                  selectedIds: selectedIds,
                  onSuccess: onClearSelection,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
