import 'package:flutter/material.dart';

class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    double maxWidth = 600,
    double maxHeightFactor = 0.85,
  }) {
    final maxHeight = MediaQuery.of(context).size.height * maxHeightFactor;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return Dialog(
          elevation: 8,
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight, //
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
