import 'package:flutter/material.dart';

enum AppCardVariant { flat, standard, emphasized, filter }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final double? minHeight;
  final double? height;
  final double margin;
  final double padding;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.standard,
    this.minHeight,
    this.height,
    this.margin = 8,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.all(margin),
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      child: Card(
        elevation: _elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(padding: EdgeInsets.all(padding), child: child),
      ),
    );
  }

  double get _elevation {
    switch (variant) {
      case AppCardVariant.flat:
        return 0;
      case AppCardVariant.standard:
        return 2;
      case AppCardVariant.filter:
        return 4;
      case AppCardVariant.emphasized:
        return 8;
    }
  }
}
