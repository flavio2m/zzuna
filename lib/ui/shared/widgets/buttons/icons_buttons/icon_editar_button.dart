import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconEditarButton extends AppIconButton {
  const IconEditarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.edit_outlined, tooltip: 'Editar');
}
