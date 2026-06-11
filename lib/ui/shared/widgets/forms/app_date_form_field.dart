import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'app_text_form_field.dart';

class AppDateFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<DateTime>? onDateSelected;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppDateFormField({
    super.key,
    required this.label,
    this.icon,
    this.onDateSelected,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.autofocus = false,
  });

  Future<void> _showPicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      label: label,
      icon: icon,
      validator: validator,
      keyboardType: TextInputType.datetime,
      inputFormatters: [DataInputFormatter()],
      onTap: () => _showPicker(context),
      readOnly: true,
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
