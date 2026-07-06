// ignore_for_file: prefer_initializing_formals
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppSwitchField extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final ValueChanged<bool>? onChangedNormal;
  final bool tristate;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  const AppSwitchField({
    super.key,
    required this.label,
    required bool value,
    ValueChanged<bool>? onChanged,
    this.focusNode,
    this.onEnterPressed,
  }) : value = value,
       onChanged = null,
       onChangedNormal = onChanged,
       tristate = false;

  const AppSwitchField.tristate({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.onEnterPressed,
  }) : onChangedNormal = null,
       tristate = true;

  @override
  Widget build(BuildContext context) {
    if (tristate) {
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              color: AppColors.slate600,
              fontWeight: FontWeight.w600, //
            ),
            const SizedBox(width: 8),
            Checkbox(
              tristate: true,
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary, //
            ),
          ],
        ),
      );
    }

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          onEnterPressed?.call();
          return onEnterPressed != null
              ? KeyEventResult.handled
              : KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
      child: SwitchListTile(
        focusNode: focusNode,
        contentPadding: EdgeInsets.zero,
        title: AppText(label),
        value: value ?? false,
        onChanged: onChangedNormal,
      ),
    );
  }
}
