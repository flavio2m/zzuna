import 'package:flutter/material.dart';
import 'app_text_form_field.dart';

class AppEmailFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppEmailFormField({
    super.key,
    required this.label,
    this.icon,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      label: label,
      icon: icon,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: const [],
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
