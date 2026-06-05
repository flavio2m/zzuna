import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ButtonFind extends StatelessWidget {
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final bool small;
  final String label;
  final String? tooltip;

  const ButtonFind({
    super.key,
    required this.onPressed,
    this.focusNode,
    this.small = false,
    this.label = 'Pesquisar',
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      focusNode: focusNode,
      small: small,
      tooltip: tooltip,
      label: label,
      icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
    );
  }
}
