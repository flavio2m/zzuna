import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class AppStatusDropdown extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String label;

  const AppStatusDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.label = 'Status', //
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownFormField<bool?>(
      label: label,
      value: value,
      onChanged: onChanged,
      items: [
        AppDropdownMenuItem<bool?>(value: null, label: 'Todos'),
        AppDropdownMenuItem<bool?>(value: true, label: 'Ativos'),
        AppDropdownMenuItem<bool?>(value: false, label: 'Inativos'),
      ],
    );
  }
}
