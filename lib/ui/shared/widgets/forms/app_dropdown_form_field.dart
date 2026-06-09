import 'package:flutter/material.dart';

class AppDropdownFormField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const AppDropdownFormField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      isExpanded: true,
    );
  }
}
