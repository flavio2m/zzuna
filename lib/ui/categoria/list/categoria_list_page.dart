import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/categoria/list/widgets/categoria_filter_bar.dart';
import 'package:zzuna/ui/categoria/list/widgets/categoria_list_view.dart';
import 'package:zzuna/ui/categoria/orcamento/widgets/controle_orcamento_card.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class CategoriaListPage extends ConsumerStatefulWidget {
  const CategoriaListPage({super.key});

  @override
  ConsumerState<CategoriaListPage> createState() => _CategoriaListPageState();
}

class _CategoriaListPageState extends ConsumerState<CategoriaListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriaListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Gerenciamento de Categorias',
          variant: AppTextVariant.title,
        ),
      ),
      body: isWide ? _buildWideLayout() : _buildNarrowLayout(),
    );
  }

  Widget _buildWideLayout() {
    return const Column(
      children: [
        AppDivider(),
        AppCard(
          variant: AppCardVariant.filter,
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
          child: CategoriaFilterBar(),
        ),
        AppDivider(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lado Esquerdo: Lista de Categorias
              Expanded(
                child: AppCard(
                  margin: EdgeInsets.only(left: 8, right: 4, top: 2, bottom: 8),
                  child: CategoriaListView(),
                ),
              ),

              // Lado Direito: Orçamento (altura total com scroll próprio)
              SizedBox(
                width: 440,
                child: ControleOrcamentoCard(
                  isExpanded: true,
                  margin: EdgeInsets.only(left: 4, right: 8, top: 2, bottom: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Opções (Barra de Filtro)
          const AppCard(
            variant: AppCardVariant.filter,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            child: CategoriaFilterBar(),
          ),
          const AppDivider(),

          // 2. Lista de Categorias (exibida primeiro)
          const AppCard(
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
            child: CategoriaListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          const AppDivider(),

          // 3. Orçamento (exibido depois da lista)
          const ControleOrcamentoCard(
            isExpanded: false,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
          ),
        ],
      ),
    );
  }
}
