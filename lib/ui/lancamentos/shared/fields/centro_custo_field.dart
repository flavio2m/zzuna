import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class CentroCustoField extends StatelessWidget {
  final List<CentroCusto> centros;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  final bool showAllOption;
  final String allOptionLabel;

  const CentroCustoField({
    super.key,
    required this.centros,
    this.value,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.onEnterPressed,
    this.showAllOption = false,
    this.allOptionLabel = 'Todos',
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownFormField<String?>(
      label: 'Centro de Custo',
      value: value,
      validator: validator,
      focusNode: focusNode,
      onEnterPressed: onEnterPressed,
      items: [
        if (showAllOption)
          AppDropdownMenuItem<String?>(value: null, label: allOptionLabel),
        ...centros.map(
          (cc) =>
              AppDropdownMenuItem<String?>(value: cc.id, label: cc.descricao),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
