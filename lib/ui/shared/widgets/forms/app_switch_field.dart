import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppSwitchField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppSwitchField({
    super.key,
    required this.label,
    required this.value,
    this.onChanged, //
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: AppText(label),
      value: value,
      onChanged: onChanged, //
    );
  }
}
