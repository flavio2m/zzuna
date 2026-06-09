import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconFecharButton extends AppIconButton {
  const IconFecharButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.close, tooltip: 'Fechar');
}
