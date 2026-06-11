import 'package:flutter/material.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class AppBancoDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String label;
  final String? Function(String?)? validator;
  final bool showAllOption;

  const AppBancoDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.label = 'Banco',
    this.validator,
    this.showAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownFormField<String>(
      label: label,
      value: value,
      onChanged: onChanged,
      validator: validator,
      items: [
        if (showAllOption) AppDropdownMenuItem<String>(value: '', label: 'Todos os Bancos'),
        ...Bancos.items.map(
          (b) => AppDropdownMenuItem<String>(value: b.sigla, label: b.descricao),
        ),
      ],
    );
  }
}
