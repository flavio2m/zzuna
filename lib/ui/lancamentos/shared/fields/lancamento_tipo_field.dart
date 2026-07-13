import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class LancamentoTipoField extends StatelessWidget {
  final LancamentoTipo? value;
  final ValueChanged<LancamentoTipo?>? onChanged;
  final String? Function(LancamentoTipo?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  const LancamentoTipoField({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.onEnterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownFormField<LancamentoTipo>(
      label: 'Tipo',
      value: value,
      validator: validator != null ? (v) => validator!(v) : null,
      focusNode: focusNode,
      onEnterPressed: onEnterPressed,
      items: LancamentoTipo.values
          .where((tipo) => tipo != LancamentoTipo.transferencia)
          .map(
            (tipo) => AppDropdownMenuItem<LancamentoTipo>(
              value: tipo,
              label: tipo.descricao,
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
