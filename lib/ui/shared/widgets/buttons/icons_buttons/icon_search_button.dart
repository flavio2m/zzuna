import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconPesquisarButton extends AppIconButton {
  const IconPesquisarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.search, tooltip: 'Pesquisar');
}
