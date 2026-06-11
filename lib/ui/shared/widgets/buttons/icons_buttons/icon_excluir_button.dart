import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';

class IconExcluirButton extends AppIconButton {
  const IconExcluirButton({
    super.key,
    required super.onPressed, //
  }) : super(
         icon: Icons.delete_outline,
         tooltip: 'Excluir', //
         color: AppColors.danger,
       );
}
