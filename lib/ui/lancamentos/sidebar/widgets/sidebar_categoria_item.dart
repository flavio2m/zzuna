import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_menu_text.dart';

class SidebarCategoryItem extends StatelessWidget {
  const SidebarCategoryItem({
    super.key,
    required this.descricao,
    required this.checked,
    required this.onTap,
    required this.level,
    this.expanded = false,
    this.hasChildren = false,
    this.onExpand,
    this.bottomPadding = 0,
  });

  final String descricao;
  final bool checked;
  final int level;

  final bool expanded;
  final bool hasChildren;

  final VoidCallback onTap;
  final VoidCallback? onExpand;

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          height: 32,
          child: Row(
            children: [
              SizedBox(width: 4 + (level * 16)),

              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: hasChildren ? onExpand : null,
                child: Icon(
                  hasChildren //
                      ? (expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right)
                      : Icons.remove,
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

              const SizedBox(width: 7),

              Expanded(
                child: AppMenuText(
                  descricao,
                  variant: level == 0 ? AppMenuTextVariant.item : AppMenuTextVariant.subitem,
                  selected: checked,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
