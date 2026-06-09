import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconFiltrarButton extends AppIconButton {
  const IconFiltrarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.filter_alt_outlined, tooltip: 'Filtrar');
}
