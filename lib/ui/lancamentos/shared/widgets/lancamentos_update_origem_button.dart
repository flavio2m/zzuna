import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class LancamentosUpdateOrigemButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LancamentosUpdateOrigemButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
      color: AppColors.primary,
      tooltip: 'Alterar conta/cartão',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
