import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip = '',
    this.color, //
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color ?? AppColors.primary),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
