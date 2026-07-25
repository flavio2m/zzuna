import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/create_despesa_button.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/create_receita_button.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/create_transferencia_button.dart';
import 'package:zzuna/ui/lancamentos/reconcile/widgets/lancamentos_reconcile_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_data/widgets/lancamentos_update_data_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_data/widgets/lancamentos_update_data_modal.dart';
import 'package:zzuna/ui/lancamentos/shared/widgets/lancamentos_update_origem_button.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_origem/widgets/lancamentos_update_origem_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_selecionar_todos_button.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';

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
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    // Listener para feedback visual caso a conciliação por menu falhe
    ref.listen(
      lancamentoReconcileViewModelProvider.select(
        (vm) => vm.reconcileCommand.value,
      ),
      (previous, next) {
        if (!isDesktop && next.isFailure) {
          final errorMessage =
              next.getExceptionOrNull()?.toString() ??
              'Erro ao conciliar lançamentos';
          AppSnackBar.showError(context, errorMessage);
        } else if (!isDesktop && next.isSuccess) {
          onClearSelection();
        }
      },
    );

    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconSelecionarTodosButton(
              allSelected: listViewModel.allSelected,
              onPressed: () => listViewModel.toggleSelectAll(),
            ),
            _buildDivider(isDesktop),
            const AppText('|'),
            _buildDivider(isDesktop),

            _buildMonthNavigation(ref, isDesktop, listViewModel),

            _buildDivider(isDesktop),
            const AppText('|'),
            _buildDivider(isDesktop),

            const CreateReceitaButton(),
            _buildDivider(isDesktop, smallSpace: true),
            const CreateDespesaButton(),
            _buildDivider(isDesktop, smallSpace: true),
            const CreateTransferenciaButton(),
            if (hasSelection && !listViewModel.isMesFechado) ...[
              _buildDivider(isDesktop),
              const AppText('|'),
              _buildDivider(isDesktop),
              ..._buildDesktopActions(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDesktop, {bool smallSpace = false}) {
    if (smallSpace) {
      return SizedBox(width: isDesktop ? 8 : 2);
    }

    return SizedBox(width: isDesktop ? 12 : 2);
  }

  Widget _buildMonthNavigation(
    WidgetRef ref,
    bool isDesktop,
    dynamic listViewModel,
  ) {
    return Consumer(
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
              onPressed:
                  (filterState.mes == Mes.janeiro && filterState.ano == 2025)
                  ? null
                  : () {
                      ref.read(lancamentoFilterProvider.notifier).mesAnterior();
                      listViewModel.pesquisar();
                    },
            ),
            SizedBox(width: isDesktop ? 8 : 4),
            Text(
              '${filterState.mes.descricao} / ${filterState.ano}',
              style: TextStyle(
                color: AppColors.slate700,
                fontWeight: FontWeight.w700,
                fontSize: isDesktop ? 13 : 11,
              ),
            ),
            SizedBox(width: isDesktop ? 8 : 4),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
              onPressed:
                  (filterState.mes == Mes.dezembro &&
                      filterState.ano == maxYear)
                  ? null
                  : () {
                      ref.read(lancamentoFilterProvider.notifier).proximoMes();
                      listViewModel.pesquisar();
                    },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildDesktopActions(BuildContext context) {
    return [
      LancamentosReconcileButton(
        conciliado: true,
        selectedIds: selectedIds,
        onSuccess: onClearSelection,
      ),
      const SizedBox(width: 8),
      LancamentosReconcileButton(
        conciliado: false,
        selectedIds: selectedIds,
        onSuccess: onClearSelection,
      ),
      const SizedBox(width: 8),
      LancamentosUpdateDataButton(
        onPressed: () {
          LancamentosUpdateDataModal.show(
            context: context,
            selectedIds: selectedIds,
            onSuccess: onClearSelection,
          );
        },
      ),
      const SizedBox(width: 8),
      LancamentosUpdateOrigemButton(
        onPressed: () {
          LancamentosUpdateOrigemModal.show(
            context: context,
            selectedIds: selectedIds,
            onSuccess: onClearSelection,
          );
        },
      ),
    ];
  }
}
