import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/centro_custo/list/widgets/centro_custo_filter_bar.dart';
import 'package:zzuna/ui/centro_custo/list/widgets/centro_custo_list_view.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

class CentroCustoListPage extends ConsumerStatefulWidget {
  const CentroCustoListPage({super.key});

  @override
  ConsumerState<CentroCustoListPage> createState() => _CentroCustoListPageState();
}

class _CentroCustoListPageState extends ConsumerState<CentroCustoListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(centroCustoListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Gerenciamento de Centros de Custo',
          variant: AppTextVariant.title,
        ),
      ),
      body: const Column(
        children: [
          AppDivider(),
          AppCard(
            variant: AppCardVariant.filter,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            child: CentroCustoFilterBar(),
          ),
          AppDivider(),
          Expanded(
            child: AppCard(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
              child: CentroCustoListView(),
            ),
          ),
        ],
      ),
    );
  }
}
