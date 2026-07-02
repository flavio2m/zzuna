import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_menu_text.dart';

class SidebarOriginSection extends StatelessWidget {
  const SidebarOriginSection({
    super.key,
    required this.title,
    required this.expanded,
    required this.active,
    required this.onTap,
    required this.onFilterTap,
    required this.child,
  });

  final String title;
  final bool expanded;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onFilterTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Row(
              children: [
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 16,
                  color: AppColors.slate400,
                ),
                Expanded(
                  child: AppMenuText(
                    title,
                    variant: AppMenuTextVariant.section, //
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: onFilterTap,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      active ? Icons.filter_alt : Icons.layers_outlined,
                      size: 15,
                      color: active ? AppColors.primary : AppColors.slate400,
                    ),
                  ),
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
