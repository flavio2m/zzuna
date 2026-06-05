import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final bool small;

  const ButtonAdd({super.key, required this.onPressed, this.focusNode, this.small = false});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      label: 'Adicionar',
      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
    );
  }
}
