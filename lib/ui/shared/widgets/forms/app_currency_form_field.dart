import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'app_text_form_field.dart';

class AppCurrencyFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AppCurrencyFormField({
    super.key,
    required this.label,
    this.icon,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      label: label,
      icon: icon,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(moeda: true),
      ],
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
