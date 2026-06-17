import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

enum AppMenuTextVariant { section, item, subitem }

class AppMenuText extends StatelessWidget {
  final String text;

  final AppMenuTextVariant variant;

  final bool selected;

  final Color? color;

  final FontWeight? fontWeight;

  final TextAlign? textAlign;

  final int? maxLines;

  final TextOverflow? overflow;

  const AppMenuText(
    this.text, {
    super.key,
    this.variant = AppMenuTextVariant.item,
    this.selected = false,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _textStyle, //
    );
  }

  double get _fontSize {
    switch (variant) {
      case AppMenuTextVariant.section:
        return 12;

      case AppMenuTextVariant.item:
        return 12;

      case AppMenuTextVariant.subitem:
        return 11;
    }
  }

  TextStyle get _textStyle {
    switch (variant) {
      case AppMenuTextVariant.section:
        return TextStyle(
          color: color ?? AppColors.slate400,
          fontSize: _fontSize,
          fontWeight: fontWeight ?? FontWeight.w800,
          letterSpacing: 1,
        );

      case AppMenuTextVariant.item:
        return TextStyle(
          color: color ?? (selected ? AppColors.slate800 : AppColors.slate700),
          fontSize: _fontSize,
          fontWeight: fontWeight ?? (selected ? FontWeight.w700 : FontWeight.w600),
        );

      case AppMenuTextVariant.subitem:
        return TextStyle(
          color: color ?? (selected ? AppColors.slate800 : AppColors.slate600),
          fontSize: _fontSize,
          fontWeight: fontWeight ?? (selected ? FontWeight.w700 : FontWeight.w600),
        );
    }
  }
}
