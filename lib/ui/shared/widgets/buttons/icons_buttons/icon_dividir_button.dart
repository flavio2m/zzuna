import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconDividirButton extends AppIconButton {
  const IconDividirButton({super.key, required super.onPressed})
    : super(icon: Icons.call_split, tooltip: 'Dividir Item');
}
