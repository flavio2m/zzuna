import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonSave extends StatelessWidget {
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool small;
  final String label;

  const ButtonSave({
    super.key,
    this.onPressed,
    this.focusNode,
    this.small = false,
    this.label = 'Salvar', //
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      label: label,
      icon: Icon(Icons.save, color: Theme.of(context).colorScheme.primary),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold, //
      ),
    );
  }
}
