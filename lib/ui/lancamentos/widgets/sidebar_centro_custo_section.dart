import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_origin_section.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_item.dart';

class SidebarCentroCustoSection extends ConsumerWidget {
  final List<CentroCusto> items;

  const SidebarCentroCustoSection({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lancamentosSidebarStateProvider);

    return SidebarOriginSection(
      title: 'CENTROS DE CUSTO',
      expanded: state.centrosExpandidos || state.filtro.isNotEmpty,
      active: state.centrosSelecionados.isNotEmpty,
      onTap: () =>
          ref //
              .read(lancamentosSidebarStateProvider.notifier)
              .toggleCentrosSection(),
      onFilterTap: () {
        final notifier = ref //
            .read(lancamentosSidebarStateProvider.notifier);
        if (state.centrosSelecionados.isNotEmpty) {
          notifier.clearCentros();
        } else {
          notifier.selectAllCentros(
            items.map((e) => e.id).toList(), //
          );
        }
      },
      child: Column(
        children: items.map((item) {
          final checked = state.centrosSelecionados.contains(item.id);

          return SidebarItem(
            descricao: item.descricao,
            checked: checked,
            icon: Icons.account_balance,
            onTap: () =>
                ref //
                    .read(lancamentosSidebarStateProvider.notifier)
                    .toggleCentroCusto(item.id),
          );
        }).toList(),
      ),
    );
  }
}
