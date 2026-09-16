import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/create/item_compra/widgets/item_compra_modal.dart';
import 'package:zzuna/ui/lista_compras/create/lista_compra/widgets/clonar_lista_anterior_button.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ListaComprasActionsBar extends ConsumerWidget {
  const ListaComprasActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listVm = ref.watch(listaComprasListViewModelProvider);

    final temLista = listVm.listaAtual != null;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildMonthNavigation(ref, isDesktop),
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
              const ClonarListaAnteriorButton(iconOnly: true),
              _buildDivider(isDesktop, smallSpace: true),
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

  Widget _buildMonthNavigation(WidgetRef ref, bool isDesktop) {
    final filterState = ref.watch(listaComprasFilterProvider);
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
}
