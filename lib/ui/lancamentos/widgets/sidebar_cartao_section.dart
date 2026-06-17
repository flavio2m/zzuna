import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_origin_section.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_item.dart';

class SidebarCartaoSection extends ConsumerWidget {
  final List<CartaoDetails> items;

  const SidebarCartaoSection({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lancamentosSidebarStateProvider);

    return SidebarOriginSection(
      title: 'CARTOES DE CREDITO',
      expanded: state.cartoesExpandidos || state.filtro.isNotEmpty,
      active: state.cartoesSelecionados.isNotEmpty,
      onTap: () =>
          ref //
              .read(lancamentosSidebarStateProvider.notifier)
              .toggleCartoesSection(),
      onFilterTap: () {
        final notifier = ref //
            .read(lancamentosSidebarStateProvider.notifier);
        if (state.cartoesSelecionados.isNotEmpty) {
          notifier.clearCartoes();
        } else {
          notifier.selectAllCartoes(
            items.map((e) => e.id).toList(), //
          );
        }
      },
      child: Column(
        children: items.map((item) {
          final checked = state.cartoesSelecionados.contains(item.id);

          return SidebarItem(
            descricao: item.descricao,
            checked: checked,
            icon: Icons.credit_card,
            onTap: () =>
                ref //
                    .read(lancamentosSidebarStateProvider.notifier)
                    .toggleCartao(item.id),
          );
        }).toList(),
      ),
    );
  }
}
