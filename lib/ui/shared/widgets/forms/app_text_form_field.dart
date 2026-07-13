import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppTextFormField({
    super.key,
    required this.label,
    this.icon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onTap: onTap,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 14),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      initialValue: controller == null ? initialValue : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: suffixIcon,
      ),
      onChanged: onChanged,
      onFieldSubmitted: (value) {
        if (onFieldSubmitted != null) {
          onFieldSubmitted!(value);
        } else if (textInputAction == TextInputAction.next) {
          FocusScope.of(context).nextFocus();
        }
      },
    );
  }
}
