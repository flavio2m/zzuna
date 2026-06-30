import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final bool small;
  final IconData? icon;
  final String? label;

  const ButtonAdd({
    super.key,
    required this.onPressed,
    this.focusNode,
    this.small = false,
    this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      label: label ?? 'Adicionar',
      icon: icon != null
          ? Icon(icon, color: Theme.of(context).colorScheme.primary)
          : Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
    );
  }
}
