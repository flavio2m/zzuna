import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

enum AppTagVariant { neutral, info, success, warning, error }

class AppTag extends StatelessWidget {
  final String text;
  final AppTagVariant variant;

  const AppTag(this.text, {super.key, this.variant = AppTagVariant.neutral});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(6), //
      ),
      child: AppText(text, variant: AppTextVariant.caption, color: _textColor),
    );
  }

  Color get _backgroundColor {
    switch (variant) {
      case AppTagVariant.neutral:
        return AppColors.slate100;

      case AppTagVariant.info:
        return AppColors.indigo100;

      case AppTagVariant.success:
        return AppColors.emerald100;

      case AppTagVariant.warning:
        return AppColors.orange100;

      case AppTagVariant.error:
        return AppColors.rose50;
    }
  }

  Color get _textColor {
    switch (variant) {
      case AppTagVariant.neutral:
        return AppColors.slate700;

      case AppTagVariant.info:
        return AppColors.indigo600;

      case AppTagVariant.success:
        return AppColors.emerald800;

      case AppTagVariant.warning:
        return AppColors.orange800;

      case AppTagVariant.error:
        return AppColors.rose600;
    }
  }
}
