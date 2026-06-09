import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/cartao/list/widgets/cartao_filter_bar.dart';
import 'package:zzuna/ui/cartao/list/widgets/cartao_list_view.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

class CartaoListPage extends ConsumerStatefulWidget {
  const CartaoListPage({super.key});

  @override
  ConsumerState<CartaoListPage> createState() => _CartaoListPageState();
}

class _CartaoListPageState extends ConsumerState<CartaoListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartaoListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText('Gerenciamento de Cartões', variant: AppTextVariant.title),
      ),
      body: const Column(
        children: [
          CartaoFilterBar(),
          AppDivider(),
          Expanded(
            child: CartaoListView(),
          ),
        ],
      ),
    );
  }
}
