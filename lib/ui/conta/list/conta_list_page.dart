import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_filter_bar.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_list_view.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class ContaListPage extends ConsumerStatefulWidget {
  const ContaListPage({super.key});

  @override
  ConsumerState<ContaListPage> createState() => _ContaListPageState();
}

class _ContaListPageState extends ConsumerState<ContaListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contaListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Gerenciamento de Contas',
          variant: AppTextVariant.title,
          color: AppColors.slate800, //
        ),
      ),
      body: const Column(
        children: [
          AppDivider(),
          AppCard(
            variant: AppCardVariant.filter,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            child: ContaFilterBar(),
          ),
          AppDivider(),
          Expanded(
            child: AppCard(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
              child: ContaListView(), //
            ),
          ),
        ],
      ),
    );
  }
}
