import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';

class AppActionBar extends StatelessWidget {
  final List<Widget> children;

  const AppActionBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: children.expand((widget) {
          if (widget == children.last) return [widget];
          return [widget, const AppSpacing(size: AppSpacingSize.md, isHorizontal: true)];
        }).toList(),
      ),
    );
  }
}
