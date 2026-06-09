import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconExportarButton extends AppIconButton {
  const IconExportarButton({
    super.key,
    required super.onPressed, //
  }) : super(icon: Icons.download_outlined, tooltip: 'Exportar');
}
