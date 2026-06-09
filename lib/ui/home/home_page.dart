import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/cartao/list/cartao_list_page.dart';
import 'package:zzuna/ui/conta/list/conta_list_page.dart';
import 'package:zzuna/ui/home/widgets/home_top_bar.dart';
import 'package:zzuna/ui/lancamentos/lancamentos_page.dart';
import 'package:zzuna/ui/relatorios/relatorios_page.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerStatefulWidget {
  const MyWidget({super.key});

  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  HomePageTab _selectedTab = HomePageTab.lancamentos;

  void _selectTab(HomePageTab tab) {
    setState(() => _selectedTab = tab);
  }

  void _logout() {
    ref.read(logoutViewModelProvider).logoutCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HomeTopBar(selectedTab: _selectedTab, onTabSelected: _selectTab, onLogout: _logout),
            Expanded(
              child: switch (_selectedTab) {
                HomePageTab.lancamentos => const LancamentosPage(),
                HomePageTab.relatorios => const RelatoriosPage(),
                HomePageTab.contas => const ContaListPage(),
                HomePageTab.cartoes => const CartaoListPage(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
