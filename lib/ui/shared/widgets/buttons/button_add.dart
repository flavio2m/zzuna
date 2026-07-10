import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final bool small;
  final IconData? icon;
  final String? label;
  final Color? color;

  const ButtonAdd({
    super.key,
    required this.onPressed,
    this.focusNode,
    this.small = false,
    this.icon,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).colorScheme.primary;

    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      label: label ?? 'Adicionar',
      icon: icon != null
          ? Icon(icon, color: defaultColor)
          : Icon(Icons.add, color: defaultColor),
      textStyle: TextStyle(color: defaultColor),
    );
  }
}
