import 'package:flutter/material.dart';

class AppTextAreaFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AppTextAreaFormField({
    super.key,
    required this.label,
    this.icon,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 5,
    this.maxLength,
    this.showCounter = false,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: textInputAction ?? TextInputAction.newline,
      style: const TextStyle(fontSize: 14),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      initialValue: controller == null ? initialValue : null,
      buildCounter: showCounter
          ? null
          : (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) => null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: icon != null ? Icon(icon) : null,
        alignLabelWithHint: true,
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
