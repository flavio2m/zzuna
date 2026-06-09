import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconAtualizarButton extends AppIconButton {
  const IconAtualizarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.refresh, tooltip: 'Atualizar');
}
