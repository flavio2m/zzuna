import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconAdicionarButton extends AppIconButton {
  const IconAdicionarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.add, tooltip: 'Adicionar');
}
