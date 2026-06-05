import 'package:flutter/material.dart';

enum AppCardVariant { flat, outlined, elevated }

class AppCard extends StatelessWidget {
  final Widget child;

  final AppCardVariant variant;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final double? height;
  final double? minHeight;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.all(4),
    this.height,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: _containerDecoration(),
      constraints: height != null
          ? BoxConstraints.tightFor(height: height)
          : BoxConstraints(
              minHeight: minHeight ?? 0, //
            ),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: _elevation(),
        child: Padding(padding: padding, child: child),
      ),
    );
  }

  double _elevation() {
    switch (variant) {
      case AppCardVariant.flat:
        return 0;

      case AppCardVariant.outlined:
        return 0;

      case AppCardVariant.elevated:
        return 8;
    }
  }

  BoxDecoration? _containerDecoration() {
    switch (variant) {
      case AppCardVariant.outlined:
        return BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        );

      default:
        return null;
    }
  }
}
