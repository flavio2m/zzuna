import 'package:flutter/material.dart';

enum AppFloatingButtonVariant { add, search, custom }

class AppFloatingButton extends StatelessWidget {
  final String heroTag;
  final VoidCallback? onPressed;

  final AppFloatingButtonVariant variant;

  final Widget? icon;

  const AppFloatingButton({
    super.key,
    required this.heroTag,
    required this.onPressed,
    this.variant = AppFloatingButtonVariant.custom,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        child: icon ?? _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    return switch (variant) {
      AppFloatingButtonVariant.add => const Icon(Icons.add),

      AppFloatingButtonVariant.search => const Icon(Icons.find_in_page),

      AppFloatingButtonVariant.custom => const Icon(Icons.add),
    };
  }
}
