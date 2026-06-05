import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonDelete extends StatelessWidget {
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  const ButtonDelete({super.key, this.onPressed, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      label: 'Excluir',
      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}
