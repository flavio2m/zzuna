import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosUpdateDataButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LancamentosUpdateDataButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_month, size: 20),
      color: AppColors.primary,
      tooltip: 'Alterar data',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
