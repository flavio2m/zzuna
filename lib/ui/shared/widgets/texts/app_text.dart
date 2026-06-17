import 'package:flutter/material.dart';

enum AppTextVariant { caption, body, subtitle, title, headline }

class AppText extends StatelessWidget {
  final String text;

  final AppTextVariant variant;

  final Color? color;

  final FontWeight? fontWeight;

  final TextAlign? textAlign;

  final int? maxLines;

  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, maxLines: maxLines, overflow: overflow, style: _textStyle);
  }

  double get _fontSize {
    switch (variant) {
      case AppTextVariant.caption:
        return 11;

      case AppTextVariant.body:
        return 12;

      case AppTextVariant.subtitle:
        return 14;

      case AppTextVariant.title:
        return 20;

      case AppTextVariant.headline:
        return 24;
    }
  }

  FontWeight get _defaultWeight {
    switch (variant) {
      case AppTextVariant.title:
      case AppTextVariant.headline:
        return FontWeight.bold;

      default:
        return FontWeight.w700;
    }
  }

  TextStyle get _textStyle {
    return TextStyle(
      fontSize: _fontSize,
      fontWeight: fontWeight ?? _defaultWeight,
      color: color, //
    );
  }
}
