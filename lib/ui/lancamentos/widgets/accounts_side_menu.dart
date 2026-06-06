import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AccountsSideMenu extends StatefulWidget {
  const AccountsSideMenu({super.key});

  @override
  State<AccountsSideMenu> createState() => _AccountsSideMenuState();
}

class _AccountsSideMenuState extends State<AccountsSideMenu> {
  static const _accounts = [
    _OriginItem('BC BB', 'R\$ 6,19', Icons.account_balance_wallet_outlined),
    _OriginItem('BC Bradesco', '-R\$ 5.509,18', Icons.account_balance_wallet_outlined, negative: true),
    _OriginItem('BC C6', '-R\$ 7.771,57', Icons.account_balance_wallet_outlined, negative: true),
    _OriginItem('BC MP', 'R\$ 8.558,26', Icons.account_balance_wallet_outlined),
    _OriginItem('BC Nubank', 'R\$ 1,32', Icons.account_balance_wallet_outlined),
    _OriginItem('Caixa Geral', 'R\$ 221,40', Icons.account_balance_wallet_outlined),
  ];

  static const _cards = [
    _OriginItem('Nubank Ultravioleta', 'Dia 12', Icons.credit_card),
    _OriginItem('C6 Carbon', 'Dia 18', Icons.credit_card),
    _OriginItem('Mercado Pago', 'Dia 22', Icons.credit_card),
  ];

  static const _categories = [
    _CategoryNode('Alimentacao', [
      _CategoryNode('Supermercado', [_CategoryNode('Goncalves'), _CategoryNode('HiperIdeal')]),
      _CategoryNode('Restaurantes'),
    ]),
    _CategoryNode('Moradia', [_CategoryNode('Condominio'), _CategoryNode('Financiamento'), _CategoryNode('Energia')]),
    _CategoryNode('Vestuario', [_CategoryNode('Roupas'), _CategoryNode('Calcados')]),
    _CategoryNode('Receitas', [_CategoryNode('Salario'), _CategoryNode('Terceiros')]),
  ];

  String _filter = '';
  bool _accountsExpanded = true;
  bool _cardsExpanded = true;
  bool _categoriesExpanded = true;
  final Set<String> _checkedOrigins = {'BC MP'};
  final Set<String> _checkedCategories = {'Supermercado'};
  final Set<String> _expandedCategories = {'Alimentacao', 'Supermercado', 'Moradia', 'Vestuario', 'Receitas'};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // _buildBrandHeader(),
          _buildSearch(),
          _buildOriginSections(),
          Expanded(child: _buildCategorySection()),
        ],
      ),
    );
  }

  // LOGO não utilizado
  // Widget _buildBrandHeader() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(colors: [AppColors.brandGradientStart, AppColors.brandGradientEnd]),
  //       border: Border(bottom: BorderSide(color: AppColors.slate100)),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 36,
  //           height: 36,
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: AppColors.primary,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 6)),
  //             ],
  //           ),
  //           child: const Text(
  //             'Z',
  //             style: TextStyle(color: AppColors.surface, fontSize: 18, fontWeight: FontWeight.w900),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         const Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'ZZuna',
  //               style: TextStyle(color: AppColors.slate800, fontSize: 20, height: 1, fontWeight: FontWeight.w900),
  //             ),
  //             SizedBox(height: 3),
  //             Text(
  //               'PERSONAL FINANCE',
  //               style: TextStyle(
  //                 color: AppColors.primary,
  //                 fontSize: 10,
  //                 fontWeight: FontWeight.w800,
  //                 letterSpacing: 1.1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FILTRAR OPCOES',
            style: TextStyle(color: AppColors.slate400, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 36,
            child: TextField(
              onChanged: (value) => setState(() => _filter = value),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.slate50,
                hintText: 'Filtrar contas e categorias...',
                hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 17, color: AppColors.slate400),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginSections() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.slate100)),
      ),
      child: Column(
        children: [
          _OriginSection(
            title: 'CONTAS CORRENTES',
            expanded: _accountsExpanded || _filter.isNotEmpty,
            active: _checkedOrigins.any((item) => _accounts.any((account) => account.label == item)),
            onTap: () => setState(() => _accountsExpanded = !_accountsExpanded),
            child: _buildOriginList(_accounts),
          ),
          const Divider(height: 18, color: AppColors.slate100),
          _OriginSection(
            title: 'CARTOES DE CREDITO',
            expanded: _cardsExpanded || _filter.isNotEmpty,
            active: _checkedOrigins.any((item) => _cards.any((card) => card.label == item)),
            onTap: () => setState(() => _cardsExpanded = !_cardsExpanded),
            child: _buildOriginList(_cards),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginList(List<_OriginItem> items) {
    final visibleItems = items.where((item) => item.label.toLowerCase().contains(_filter.toLowerCase())).toList();

    return Column(
      children: visibleItems.map((item) {
        final checked = _checkedOrigins.contains(item.label);

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() {
              checked ? _checkedOrigins.remove(item.label) : _checkedOrigins.add(item.label);
            }),
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: checked ? AppColors.emerald50 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    checked ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 16,
                    color: checked ? AppColors.primary : AppColors.slate400,
                  ),
                  const SizedBox(width: 8),
                  Icon(item.icon, size: 15, color: AppColors.slate400),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: checked ? AppColors.slate800 : AppColors.slate700,
                        fontSize: 12,
                        fontWeight: checked ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.meta,
                    style: TextStyle(
                      color: item.negative ? AppColors.danger : AppColors.slate700,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection() {
    final visibleCategories = _categories.where((category) => _matchesCategoryFilter(category, _filter)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _OriginSection(
        title: 'CATEGORIAS',
        expanded: _categoriesExpanded || _filter.isNotEmpty,
        active: _checkedCategories.isNotEmpty,
        onTap: () => setState(() => _categoriesExpanded = !_categoriesExpanded),
        child: Column(children: visibleCategories.map((category) => _buildCategoryNode(category, 0)).toList()),
      ),
    );
  }

  Widget _buildCategoryNode(_CategoryNode category, int level) {
    final children = category.children.where((child) => _matchesCategoryFilter(child, _filter)).toList();
    final hasChildren = children.isNotEmpty;
    final expanded = _expandedCategories.contains(category.label) || _filter.isNotEmpty;
    final checked = _checkedCategories.contains(category.label);

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() {
            checked ? _checkedCategories.remove(category.label) : _checkedCategories.add(category.label);
          }),
          child: Container(
            height: 32,
            padding: EdgeInsets.only(left: 4 + (level * 16), right: 8),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: hasChildren
                      ? () => setState(() {
                          expanded
                              ? _expandedCategories.remove(category.label)
                              : _expandedCategories.add(category.label);
                        })
                      : null,
                  child: Icon(
                    hasChildren ? (expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right) : Icons.remove,
                    size: 17,
                    color: hasChildren ? AppColors.slate500 : Colors.transparent,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  checked ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 16,
                  color: checked ? AppColors.primary : AppColors.slate400,
                ),
                const SizedBox(width: 8),
                Icon(Icons.folder_outlined, size: 15, color: level == 0 ? AppColors.slate500 : AppColors.slate400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: checked ? AppColors.slate800 : AppColors.slate700,
                      fontSize: 12,
                      fontWeight: checked ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasChildren && expanded)
          Container(
            margin: const EdgeInsets.only(left: 18),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.slate100)),
            ),
            child: Column(children: children.map((child) => _buildCategoryNode(child, level + 1)).toList()),
          ),
      ],
    );
  }

  bool _matchesCategoryFilter(_CategoryNode category, String filter) {
    if (filter.isEmpty) return true;

    final query = filter.toLowerCase();
    return category.label.toLowerCase().contains(query) ||
        category.children.any((child) => _matchesCategoryFilter(child, filter));
  }
}

class _OriginSection extends StatelessWidget {
  const _OriginSection({
    required this.title,
    required this.expanded,
    required this.active,
    required this.onTap,
    required this.child,
  });

  final String title;
  final bool expanded;
  final bool active;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            child: Row(
              children: [
                Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  size: 16,
                  color: AppColors.slate400,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.slate400,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Icon(
                  active ? Icons.filter_alt : Icons.layers_outlined,
                  size: 15,
                  color: active ? AppColors.primary : AppColors.slate400,
                ),
              ],
            ),
          ),
        ),
        if (expanded) child,
      ],
    );
  }
}

class _OriginItem {
  const _OriginItem(this.label, this.meta, this.icon, {this.negative = false});

  final String label;
  final String meta;
  final IconData icon;
  final bool negative;
}

class _CategoryNode {
  const _CategoryNode(this.label, [this.children = const []]);

  final String label;
  final List<_CategoryNode> children;
}
