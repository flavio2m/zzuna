import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/ui/home/pages/sobre_page.dart';

enum HomePageTab {
  lancamentos,
  lancamentosPendentes,
  relatorios,
  contas,
  cartoes,
  centroCustos,
  categorias,
}
// enum _HomeMenuAction { logout }

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onLogout,
  });

  final HomePageTab selectedTab;
  final ValueChanged<HomePageTab> onTabSelected;
  final VoidCallback onLogout;

  String _getLabelForTab(HomePageTab tab) {
    switch (tab) {
      case HomePageTab.lancamentos:
        return 'Lançamentos';
      case HomePageTab.lancamentosPendentes:
        return 'Lançamentos Pendentes';
      case HomePageTab.relatorios:
        return 'Relatórios';
      case HomePageTab.contas:
        return 'Contas';
      case HomePageTab.cartoes:
        return 'Cartões';
      case HomePageTab.centroCustos:
        return 'Centro de Custos';
      case HomePageTab.categorias:
        return 'Categorias';
    }
  }

  void _showSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: SobrePage(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Material(
      color: AppColors.slate900,
      child: Container(
        height: 38,
        padding: const EdgeInsets.only(left: 4, right: 24),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.slate950)),
        ),
        child: Row(
          children: [
            if (!isDesktop && selectedTab == HomePageTab.lancamentos)
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.slate200),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: 'Filtros e Contas',
              ),
            InkWell(
              onTap: () => _showSobre(context),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: OverflowBox(
                        minWidth: 78,
                        maxWidth: 78,
                        minHeight: 78,
                        maxHeight: 78,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/icons/zzuna_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ZZuna',
                      style: TextStyle(
                        color: AppColors.emerald400,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: isDesktop ? 12 : 8),
            if (!isDesktop) ...[
              PopupMenuButton<int>(
                icon: const Icon(
                  Icons.apps,
                  color: AppColors.slate200,
                  size: 24,
                ),
                offset: const Offset(0, 40),
                color: AppColors.surface,
                onSelected: (value) {
                  if (value == 99) {
                    _showSobre(context);
                  } else {
                    onTabSelected(HomePageTab.values[value]);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: HomePageTab.lancamentos.index,
                    child: const Text('Lançamentos'),
                  ),
                  PopupMenuItem(
                    value: HomePageTab.lancamentosPendentes.index,
                    child: const Text('Lançamentos Pendentes'),
                  ),
                  PopupMenuItem(
                    value: HomePageTab.contas.index,
                    child: const Text('Contas'),
                  ),
                  PopupMenuItem(
                    value: HomePageTab.cartoes.index,
                    child: const Text('Cartões'),
                  ),
                  PopupMenuItem(
                    value: HomePageTab.centroCustos.index,
                    child: const Text('Centro de Custos'),
                  ),
                  PopupMenuItem(
                    value: HomePageTab.categorias.index,
                    child: const Text('Categorias'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 99, child: Text('Sobre')),
                ],
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getLabelForTab(selectedTab),
                  style: const TextStyle(
                    color: AppColors.surface,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
            if (isDesktop)
              Container(
                height: 48,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.slate950,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.slate800),
                ),
                child: Row(
                  children: [
                    _TopTabButton(
                      icon: Icons.dashboard_outlined,
                      label: 'Lançamentos',
                      selected: selectedTab == HomePageTab.lancamentos,
                      onPressed: () => onTabSelected(HomePageTab.lancamentos),
                    ),
                    _TopTabButton(
                      icon: Icons.warning_amber_outlined,
                      label: 'Pendentes',
                      selected: selectedTab == HomePageTab.lancamentosPendentes,
                      onPressed: () =>
                          onTabSelected(HomePageTab.lancamentosPendentes),
                    ),
                    _TopTabButton(
                      icon: Icons.bar_chart_outlined,
                      label: 'Contas',
                      selected: selectedTab == HomePageTab.contas,
                      onPressed: () => onTabSelected(HomePageTab.contas),
                    ),
                    _TopTabButton(
                      icon: Icons.credit_card_outlined,
                      label: 'Cartões',
                      selected: selectedTab == HomePageTab.cartoes,
                      onPressed: () => onTabSelected(HomePageTab.cartoes),
                    ),
                    _TopTabButton(
                      icon: Icons.account_balance_outlined,
                      label: 'Centro de Custos',
                      selected: selectedTab == HomePageTab.centroCustos,
                      onPressed: () => onTabSelected(HomePageTab.centroCustos),
                    ),
                    _TopTabButton(
                      icon: Icons.account_tree,
                      label: 'Categorias',
                      selected: selectedTab == HomePageTab.categorias,
                      onPressed: () => onTabSelected(HomePageTab.categorias),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            if (isDesktop)
              TextButton.icon(
                onPressed: () => _showSobre(context),
                icon: const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.slate400,
                ),
                label: const Text(
                  'Sobre',
                  style: TextStyle(color: AppColors.slate400, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
            if (isDesktop) const SizedBox(width: 8),
            if (isDesktop)
              TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(
                  Icons.logout,
                  size: 16,
                  color: AppColors.slate200,
                ),
                label: const Text(
                  'Sair',
                  style: TextStyle(color: AppColors.slate200, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: AppColors.slate800,
                ),
              )
            else
              IconButton(
                onPressed: onLogout,
                icon: const Icon(
                  Icons.logout,
                  size: 18,
                  color: AppColors.slate200,
                ),
                tooltip: 'Sair',
              ),
          ],
        ),
      ),
    );
  }
}

class _TopTabButton extends StatelessWidget {
  const _TopTabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label),
        style: TextButton.styleFrom(
          backgroundColor: selected ? AppColors.primary : Colors.transparent,
          foregroundColor: selected ? AppColors.surface : AppColors.slate400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
