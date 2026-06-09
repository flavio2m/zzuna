import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_filter_bar.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_list_view.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

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
        title: const Text('Gerenciamento de Contas'),
      ),
      body: const Column(
        children: [
          ContaFilterBar(),
          AppDivider(),
          Expanded(
            child: ContaListView(),
          ),
        ],
      ),
    );
  }
}
