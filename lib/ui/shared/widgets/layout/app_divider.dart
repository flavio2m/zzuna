import 'package:flutter/material.dart';

enum AppDividerVariant { subtle, normal, section }

class AppDivider extends StatelessWidget {
  final AppDividerVariant variant;

  const AppDivider({super.key, this.variant = AppDividerVariant.normal});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: switch (variant) {
        AppDividerVariant.subtle => 0.5,
        AppDividerVariant.normal => 1,
        AppDividerVariant.section => 2,
      },
    );
  }
}
