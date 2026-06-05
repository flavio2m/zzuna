import 'package:flutter/material.dart';

enum AppSpacingSize { xs, sm, md, lg, xl }

class AppSpacing extends StatelessWidget {
  final AppSpacingSize size;
  final Axis axis;

  const AppSpacing({
    super.key,
    this.size = AppSpacingSize.md,
    this.axis = Axis.vertical, //
  });

  double get value {
    switch (size) {
      case AppSpacingSize.xs:
        return 4;
      case AppSpacingSize.sm:
        return 8;
      case AppSpacingSize.md:
        return 12;
      case AppSpacingSize.lg:
        return 16;
      case AppSpacingSize.xl:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return //
    axis == Axis.vertical ? SizedBox(height: value) : SizedBox(width: value);
  }
}
