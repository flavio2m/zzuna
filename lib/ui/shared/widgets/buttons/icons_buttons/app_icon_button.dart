import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip = '',
    this.color,
    this.focusNode,
    this.onEnterPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (onEnterPressed != null && focusNode != null) {
      focusNode!.onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          onEnterPressed!();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }

    return IconButton(
      focusNode: focusNode,
      icon: Icon(icon, color: color ?? AppColors.primary),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
