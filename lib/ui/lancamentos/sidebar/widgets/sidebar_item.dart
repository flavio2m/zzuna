import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_menu_text.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.descricao,
    required this.checked,
    required this.onTap,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.showBackground = true,
    this.bottomPadding = 4.0,
  });

  final String descricao;
  final bool checked;
  final VoidCallback onTap;

  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final bool showBackground;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 32,
          padding: padding,
          decoration: showBackground
              ? BoxDecoration(
                  color: checked ? AppColors.emerald50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Row(
            children: [
              Icon(
                checked ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16,
                color: checked ? AppColors.primary : AppColors.slate400,
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 15, color: AppColors.slate400), //
              ],
              const SizedBox(width: 7),
              Expanded(
                child: AppMenuText(
                  descricao,
                  variant: AppMenuTextVariant.item,
                  selected: checked, //
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
