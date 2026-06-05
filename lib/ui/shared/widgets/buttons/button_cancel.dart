import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonCancel extends StatelessWidget {
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final bool small;
  final String label;

  const ButtonCancel({super.key, required this.onPressed, this.focusNode, this.small = false, this.label = 'Cancelar'});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      label: label,
      icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}
