import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/create/item_compra/widgets/item_compra_modal.dart';
import 'package:zzuna/ui/lista_compras/create/lista_compra/widgets/clonar_lista_anterior_button.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class ListaComprasActionsBar extends ConsumerWidget {
  const ListaComprasActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listVm = ref.watch(listaComprasListViewModelProvider);
    final createVm = ref.watch(listaComprasCreateViewModelProvider);
    final filterState = ref.watch(listaComprasFilterProvider);

    final temLista = listVm.listaAtual != null;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildMonthNavigation(ref, isDesktop, filterState),
            _buildDivider(isDesktop),
            const AppText('|', color: AppColors.slate300),
            _buildDivider(isDesktop),

            if (temLista) ...[
              IconButton(
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                color: AppColors.emerald600,
                tooltip: 'Adicionar Produto',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
                onPressed: () => ItemCompraModal.show(context),
              ),
            ] else ...[
              IconButton(
                icon: createVm.criarListaVaziaCommand.value.isRunning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.note_add_outlined, size: 20),
                color: AppColors.emerald600,
                tooltip: 'Criar Lista',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
                onPressed: createVm.criarListaVaziaCommand.value.isRunning
                    ? null
                    : () =>
                          createVm.criarListaVaziaCommand.execute(filterState),
              ),
              _buildDivider(isDesktop, smallSpace: true),
              const ClonarListaAnteriorButton(iconOnly: true),
            ],

            _buildDivider(isDesktop),
            const AppText('|', color: AppColors.slate300),
            _buildDivider(isDesktop),

            _buildSituacaoFilterGroup(context, ref, filterState),
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
    dynamic filterState,
  ) {
    final notifier = ref.read(listaComprasFilterProvider.notifier);
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
              : () => notifier.mesAnterior(),
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
              (filterState.mes == Mes.dezembro && filterState.ano == maxYear)
              ? null
              : () => notifier.proximoMes(),
        ),
      ],
    );
  }

  Widget _buildSituacaoFilterGroup(
    BuildContext context,
    WidgetRef ref,
    dynamic filterState,
  ) {
    final notifier = ref.read(listaComprasFilterProvider.notifier);
    final situacao = filterState.situacao;

    final isTodos = situacao == null;
    final isPendentes = situacao == ItemCompraSituacao.pendente;
    final isComprados = situacao == ItemCompraSituacao.comprado;
    final isCancelados = situacao == ItemCompraSituacao.cancelado;

    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterButton(
            context: context,
            isSelected: isTodos,
            icon: Icons.format_list_bulleted,
            tooltip: 'Todos os itens',
            selectedColor: AppColors.indigo600,
            onPressed: isTodos ? null : () => notifier.setSituacao(null),
          ),
          Container(width: 1, height: 28, color: AppColors.border),
          _buildFilterButton(
            context: context,
            isSelected: isPendentes,
            icon: Icons.pending_actions,
            tooltip: 'Itens Pendentes',
            selectedColor: Colors.blue.shade700,
            onPressed: isPendentes
                ? null
                : () => notifier.setSituacao(ItemCompraSituacao.pendente),
          ),
          Container(width: 1, height: 28, color: AppColors.border),
          _buildFilterButton(
            context: context,
            isSelected: isComprados,
            icon: Icons.check_circle_outline,
            tooltip: 'Itens Comprados',
            selectedColor: AppColors.emerald800,
            onPressed: isComprados
                ? null
                : () => notifier.setSituacao(ItemCompraSituacao.comprado),
          ),
          Container(width: 1, height: 28, color: AppColors.border),
          _buildFilterButton(
            context: context,
            isSelected: isCancelados,
            icon: Icons.block_outlined,
            tooltip: 'Itens Cancelados',
            selectedColor: AppColors.rose600,
            onPressed: isCancelados
                ? null
                : () => notifier.setSituacao(ItemCompraSituacao.cancelado),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required bool isSelected,
    required IconData icon,
    required String tooltip,
    required Color selectedColor,
    required VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 32,
          height: 28,
          color: isSelected
              ? selectedColor.withValues(alpha: 0.15)
              : Colors.transparent,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: isSelected ? selectedColor : AppColors.slate500,
          ),
        ),
      ),
    );
  }
}
