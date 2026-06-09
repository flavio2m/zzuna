import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum HomePageTab { lancamentos, relatorios, contas, cartoes }
// enum _HomeMenuAction { logout }

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, required this.selectedTab, required this.onTabSelected, required this.onLogout});

  final HomePageTab selectedTab;
  final ValueChanged<HomePageTab> onTabSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.slate900,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.slate950)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
              ),
              child: const Text(
                'ZZuna',
                style: TextStyle(color: AppColors.emerald400, fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 12),
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
                    icon: Icons.bar_chart_outlined,
                    label: 'Relatorios',
                    selected: selectedTab == HomePageTab.relatorios,
                    onPressed: () => onTabSelected(HomePageTab.relatorios),
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
                ],
              ),
            ),
            const Spacer(),
            const Text(
              'Simulacao: 05/Mar/2026',
              style: TextStyle(color: AppColors.slate500, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            //Refatorar futuramente: utilizar menu para telas pequenas
            // PopupMenuButton<_HomeMenuAction>(
            //   tooltip: 'Opcoes',
            //   icon: const Icon(Icons.more_vert, color: AppColors.slate200),
            //   color: AppColors.surface,
            //   onSelected: (action) {
            //     switch (action) {
            //       case _HomeMenuAction.logout:
            //         onLogout();
            //     }
            //   },
            //   itemBuilder: (context) => const [
            //     PopupMenuItem(
            //       value: _HomeMenuAction.logout,
            //       child: Row(children: [Icon(Icons.logout, size: 18), SizedBox(width: 8), Text('Sair')]),
            //     ),
            //   ],
            // ),
            // Inicialmente será apresentado apenas o botão de logout
            TextButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, size: 16, color: AppColors.slate200),
              label: const Text('Sair', style: TextStyle(color: AppColors.slate200, fontSize: 12)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: AppColors.slate800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopTabButton extends StatelessWidget {
  const _TopTabButton({required this.icon, required this.label, required this.selected, required this.onPressed});

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
