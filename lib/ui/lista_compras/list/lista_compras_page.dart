import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lista_compras/list/widgets/item_compra_card.dart';
import 'package:zzuna/ui/lista_compras/list/widgets/lista_compras_filter_bar.dart';
import 'package:zzuna/ui/lista_compras/list/widgets/lista_compras_summary_card.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

class ListaComprasPage extends ConsumerStatefulWidget {
  const ListaComprasPage({super.key});

  @override
  ConsumerState<ListaComprasPage> createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends ConsumerState<ListaComprasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listaComprasListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isDesktop = MediaQuery.of(context).size.width >= 800;
    final listVm = ref.watch(listaComprasListViewModelProvider);
    final lista = listVm.listaAtual;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const AppCard(
                  variant: AppCardVariant.filter,
                  margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  child: ListaComprasFilterBar(),
                ),
                const AppDivider(),
                Expanded(
                  child: AppCard(
                    margin: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 2,
                      bottom: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: _buildBody(listVm, lista),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(dynamic listVm, dynamic lista) {
    if (listVm.loadCommand.value.isRunning) {
      return const Center(child: CircularProgressIndicator());
    }

    if (lista == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.slate500,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma lista de compras para '
              '${listVm.filter.mes.descricao}/${listVm.filter.ano}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.slate500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final itens = listVm.itensFiltrados;

    return Column(
      children: [
        ListaComprasSummaryCard(lista: lista),
        const SizedBox(height: 12),
        Expanded(
          child: itens.isEmpty
              ? Center(
                  child: Text(
                    lista.itens.isEmpty
                        ? 'A lista deste mês está vazia. Clique em "Adicionar Produto" '
                              'acima para começar.'
                        : 'Nenhum produto encontrado para os filtros selecionados.',
                    style: const TextStyle(
                      color: AppColors.slate500,
                      fontSize: 14,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: itens.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    return ItemCompraCard(item: item, lista: lista);
                  },
                ),
        ),
      ],
    );
  }
}
