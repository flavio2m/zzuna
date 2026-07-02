import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosUpdateMetadataButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LancamentosUpdateMetadataButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.description_outlined, size: 20),
      color: AppColors.primary,
      tooltip: 'Alterar descrição',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
