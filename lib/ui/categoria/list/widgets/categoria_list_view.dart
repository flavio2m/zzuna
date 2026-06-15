import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/categoria/list/widgets/categoria_list_item.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CategoriaListView extends ConsumerStatefulWidget {
  const CategoriaListView({super.key});

  @override
  ConsumerState<CategoriaListView> createState() => _CategoriaListViewState();
}

class _CategoriaListViewState extends ConsumerState<CategoriaListView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(categoriaListViewModelProvider);

    return ListenableBuilder(
      listenable: viewModel.loadCommand,
      builder: (context, _) {
        final state = viewModel.loadCommand.value;

        if (state.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure) {
          return Center(
            child: AppText(
              'Erro ao carregar categorias: ${state.getExceptionOrNull()}',
              color: AppColors.danger,
            ),
          );
        }

        final categorias = viewModel.categorias;

        if (categorias.isEmpty) {
          return const Center(child: AppText('Nenhuma categoria encontrada.'));
        }

        // Monta a lista visível com suporte a múltiplos níveis de hierarquia
        final visiveis = _buildVisiveis(categorias, viewModel.collapsedIds);

        return Stack(
          children: [
            ListView.separated(
              itemCount: visiveis.length,
              separatorBuilder: (_, _) => const AppDivider(),
              itemBuilder: (context, index) {
                final item = visiveis[index];
                final temSubs = item.categoria.subcategorias.isNotEmpty;

                return CategoriaListItem(
                  categoria: item.categoria,
                  nomePai: item.nomePai,
                  isColapsada: viewModel.collapsedIds.contains(item.categoria.id),
                  onToggle: temSubs ? () => viewModel.toggleCollapsed(item.categoria.id) : null,
                  profundidade: item.profundidade,
                );
              },
            ),
            if (state.isRunning)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  List<_VisibleItem> _buildVisiveis(List<CategoriaDetails> rootNodes, Set<String> collapsedIds) {
    final resultado = <_VisibleItem>[];

    void adicionarNode(CategoriaDetails node, int profundidade, String? nomePai) {
      resultado.add(_VisibleItem(
        categoria: node,
        profundidade: profundidade,
        nomePai: nomePai,
      ));

      if (!collapsedIds.contains(node.id)) {
        for (final child in node.subcategorias) {
          adicionarNode(child, profundidade + 1, node.descricao);
        }
      }
    }

    for (final root in rootNodes) {
      final nomePai = root.categoriaPai?.descricao;
      adicionarNode(root, 0, nomePai);
    }

    return resultado;
  }
}

class _VisibleItem {
  final CategoriaDetails categoria;
  final int profundidade;
  final String? nomePai;

  _VisibleItem({
    required this.categoria,
    required this.profundidade,
    required this.nomePai,
  });
}
