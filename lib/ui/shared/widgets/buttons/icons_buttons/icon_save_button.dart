import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconSalvarButton extends AppIconButton {
  const IconSalvarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.save_outlined, tooltip: 'Salvar');
}
