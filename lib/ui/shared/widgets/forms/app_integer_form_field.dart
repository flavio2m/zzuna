import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_text_form_field.dart';

class AppIntegerFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppIntegerFormField({
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
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
