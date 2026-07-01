import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonSave extends StatelessWidget {
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool small;
  final String label;
  final bool loading;

  const ButtonSave({
    super.key,
    this.onPressed,
    this.focusNode,
    this.small = false,
    this.label = 'Salvar',
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      label: label,
      loading: loading,
      icon: Icon(Icons.save, color: Theme.of(context).colorScheme.primary),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
