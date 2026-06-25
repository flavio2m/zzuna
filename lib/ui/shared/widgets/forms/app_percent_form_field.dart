import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_text_form_field.dart';

class AppPercentFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double min;
  final double max;

  const AppPercentFormField({
    super.key,
    required this.label,
    this.icon,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.min = 0.0,
    this.max = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      label: label,
      icon: icon,
      onChanged: onChanged,
      validator: (val) {
        if (validator != null) {
          final res = validator!(val);
          if (res != null) return res;
        }
        if (val != null && val.isNotEmpty) {
          final cleanVal = val.replaceAll(',', '.');
          final parsed = double.tryParse(cleanVal);
          if (parsed == null) {
            return 'Percentual inválido';
          }
          if (parsed < min) {
            return 'Mínimo de $min%';
          }
          if (parsed > max) {
            return 'Máximo de $max%';
          }
          // Validar limite de 3 casas decimais
          final parts = cleanVal.split('.');
          if (parts.length > 1 && parts[1].length > 3) {
            return 'Máximo de 3 casas decimais';
          }
        }
        return null;
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      suffixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        child: Text(
          '%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
