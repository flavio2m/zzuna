import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/lancamentos/sidebar/models/lancamentos_sidebar_state.dart';
import 'package:zzuna/ui/lancamentos/sidebar/widgets/sidebar_categoria_item.dart';
import 'package:zzuna/ui/lancamentos/sidebar/widgets/sidebar_origin_section.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class SidebarCategoriaSection extends ConsumerWidget {
  final List<CategoriaDetails> items;

  const SidebarCategoriaSection({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lancamentosSidebarStateProvider);
    final filterState = ref.watch(lancamentoFilterProvider);

    return SidebarOriginSection(
      title: 'CATEGORIAS',
      expanded: state.categoriasExpandidas || state.filtro.isNotEmpty,
      active: filterState.categoriasSelecionadas.isNotEmpty,
      onTap: () {
        ref //
            .read(lancamentosSidebarStateProvider.notifier)
            .toggleCategoriasSection();
      },
      onFilterTap: () {
        final notifier = ref.read(lancamentoFilterProvider.notifier);
        if (filterState.categoriasSelecionadas.isNotEmpty) {
          notifier.clearCategorias();
        } else {
          final allIds = <String>[];
          void collect(CategoriaDetails cat) {
            allIds.add(cat.id);
            for (final sub in cat.subcategorias) {
              collect(sub);
            }
          }

          for (final item in items) {
            collect(item);
          }
          notifier.selectAllCategorias(allIds);
        }
      },
      child: Column(
        children:
            items //
                .map(
                  (categoria) =>
                      _buildNode(ref, categoria, state, filterState, level: 0),
                )
                .toList(), //
      ),
    );
  }

  Widget _buildNode(
    WidgetRef ref,
    CategoriaDetails categoria,
    LancamentosSidebarState state,
    dynamic filterState, {
    required int level, //
  }) {
    final hasChildren = categoria.subcategorias.isNotEmpty;

    final expanded =
        state //
            .filtro
            .isNotEmpty ||
        state.categoriasExpandidasIds.contains(categoria.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SidebarCategoryItem(
          descricao: categoria.descricao,
          checked: filterState.categoriasSelecionadas.contains(categoria.id),
          level: level,
          hasChildren: hasChildren,
          expanded: expanded,
          onTap: () {
            final subIds = <String>[];
            void collect(CategoriaDetails cat) {
              for (final sub in cat.subcategorias) {
                subIds.add(sub.id);
                collect(sub);
              }
            }

            collect(categoria);
            ref //
                .read(lancamentoFilterProvider.notifier)
                .toggleCategoria(
                  categoria.id,
                  subcategoriesIds: subIds, //
                );
          },
          onExpand: hasChildren
              ? () {
                  ref //
                      .read(lancamentosSidebarStateProvider.notifier)
                      .toggleCategoriaExpandida(categoria.id);
                }
              : null,
        ),

        if (hasChildren && expanded)
          Container(
            margin: const EdgeInsets.only(left: 18),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.slate100)),
            ),
            child: Column(
              children: categoria.subcategorias
                  .map(
                    (child) => _buildNode(
                      ref,
                      child,
                      state,
                      filterState,
                      level: level + 1,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
