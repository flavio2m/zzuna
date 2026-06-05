import 'package:flutter/material.dart';

enum AppButtonType { elevated, filled }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon? icon;
  final String label;
  final TextStyle? textStyle;
  final bool full;
  final AppButtonType buttonType;
  final FocusNode? focusNode;
  final bool small;
  final String? tooltip;
  final bool loading;

  const AppButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.full = false,
    this.buttonType = AppButtonType.elevated,
    this.textStyle,
    this.focusNode,
    this.small = false,
    this.tooltip,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    final style = TextButton.styleFrom(
      backgroundColor: buttonType == AppButtonType.elevated ? Theme.of(context).colorScheme.onPrimary : null,
      minimumSize: full ? const Size(double.infinity, 48) : const Size(0, 48),
      side: BorderSide(color: isDisabled ? Colors.grey : Colors.transparent),
    );

    final button = switch (buttonType) {
      AppButtonType.elevated => ElevatedButton.icon(
        onPressed: onPressed,
        focusNode: focusNode,
        style: style,
        icon: _buildIcon(context, isDisabled),
        label: _buildLabel(isDisabled),
      ),
      AppButtonType.filled => FilledButton.icon(
        onPressed: onPressed,
        focusNode: focusNode,
        style: style,
        icon: _buildIcon(context, isDisabled),
        label: _buildLabel(isDisabled),
      ),
    };

    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }

  Widget _buildLabel(bool disabled) {
    if (small) return const SizedBox.shrink();

    return Text(label, style: disabled ? TextStyle(color: Colors.grey[700]) : textStyle);
  }

  Widget _buildIcon(BuildContext context, bool disabled) {
    if (loading) {
      return const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (!disabled) {
      return icon ?? const Icon(Icons.add);
    }

    return Icon(icon?.icon ?? Icons.add, color: Colors.grey[700]);
  }
}
