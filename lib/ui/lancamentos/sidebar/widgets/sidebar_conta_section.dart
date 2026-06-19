import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/ui/lancamentos/sidebar/widgets/sidebar_origin_section.dart';
import 'package:zzuna/ui/lancamentos/sidebar/widgets/sidebar_item.dart';

class SidebarContaSection extends ConsumerWidget {
  final List<ContaDetails> items;

  const SidebarContaSection({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lancamentosSidebarStateProvider);

    return SidebarOriginSection(
      title: 'CONTAS CORRENTES',
      expanded: state.contasExpandidas || state.filtro.isNotEmpty,
      active: state.contasSelecionadas.isNotEmpty,
      onTap: () =>
          ref //
              .read(lancamentosSidebarStateProvider.notifier)
              .toggleContasSection(),
      onFilterTap: () {
        final notifier = ref //
            .read(lancamentosSidebarStateProvider.notifier);
        if (state.contasSelecionadas.isNotEmpty) {
          notifier.clearContas();
        } else {
          notifier.selectAllContas(
            items.map((e) => e.id).toList(), //
          );
        }
      },
      child: Column(
        children: items.map((item) {
          final checked = state.contasSelecionadas.contains(item.id);

          return SidebarItem(
            descricao: item.descricao,
            checked: checked,
            icon: item.banco.getIcon(),
            onTap: () =>
                ref //
                    .read(lancamentosSidebarStateProvider.notifier)
                    .toggleConta(item.id),
          );
        }).toList(),
      ),
    );
  }
}
