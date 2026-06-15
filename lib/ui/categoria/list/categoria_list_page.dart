import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/categoria/list/widgets/categoria_filter_bar.dart';
import 'package:zzuna/ui/categoria/list/widgets/categoria_list_view.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Gerenciamento de Categorias',
          variant: AppTextVariant.title,
        ),
      ),
      body: const Column(
        children: [
          AppDivider(),
          AppCard(
            variant: AppCardVariant.filter,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            child: CategoriaFilterBar(),
          ),
          AppDivider(),
          Expanded(
            child: AppCard(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
              child: CategoriaListView(),
            ),
          ),
        ],
      ),
    );
  }
}
