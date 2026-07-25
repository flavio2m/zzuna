import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class CategoriaField extends StatelessWidget {
  final List<CategoriaDetails> categorias;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  final bool showAllOption;
  final String allOptionLabel;

  const CategoriaField({
    super.key,
    required this.categorias,
    this.value,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.onEnterPressed,
    this.showAllOption = false,
    this.allOptionLabel = 'Todas',
  });

  /// Flattens the category tree into a sorted list with full path labels.
  List<_FlatCategoria> _flatten(List<CategoriaDetails> nodes, String prefix) {
    final result = <_FlatCategoria>[];
    for (final node in nodes) {
      final label = prefix.isEmpty
          ? node.descricao
          : '$prefix > ${node.descricao}';
      result.add(_FlatCategoria(id: node.id, label: label));
      if (node.subcategorias.isNotEmpty) {
        result.addAll(_flatten(node.subcategorias, label));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final flat = _flatten(categorias, '');

    return AppDropdownFormField<String?>(
      label: 'Categoria',
      value: value,
      validator: validator,
      focusNode: focusNode,
      onEnterPressed: onEnterPressed,
      items: [
        if (showAllOption)
          AppDropdownMenuItem<String?>(value: null, label: allOptionLabel),
        ...flat.map(
          (cat) =>
              AppDropdownMenuItem<String?>(value: cat.id, label: cat.label),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class _FlatCategoria {
  final String id;
  final String label;
  const _FlatCategoria({required this.id, required this.label});
}
