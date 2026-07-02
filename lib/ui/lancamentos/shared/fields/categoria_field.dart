import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class CategoriaField extends StatelessWidget {
  final List<CategoriaDetails> categorias;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const CategoriaField({
    super.key,
    required this.categorias,
    this.value,
    this.onChanged,
    this.validator,
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

    return AppDropdownFormField<String>(
      label: 'Categoria',
      value: value,
      validator: validator,
      items: flat
          .map(
            (cat) =>
                AppDropdownMenuItem<String>(value: cat.id, label: cat.label),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _FlatCategoria {
  final String id;
  final String label;
  const _FlatCategoria({required this.id, required this.label});
}
