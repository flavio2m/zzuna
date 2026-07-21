import 'package:flutter/material.dart';

class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    double maxWidth = 600,
    double maxHeightFactor = 0.85,
  }) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800;

    final actualMaxHeight = isDesktop
        ? size.height * maxHeightFactor
        : size.height;
    final actualMaxWidth = isDesktop ? maxWidth : size.width;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return Dialog(
          elevation: 8,
          backgroundColor: Theme.of(context).cardColor,
          insetPadding: isDesktop
              ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0)
              : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: actualMaxWidth,
              maxHeight: actualMaxHeight,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child, //
            ),
          ),
        );
      },
    );
  }
}
