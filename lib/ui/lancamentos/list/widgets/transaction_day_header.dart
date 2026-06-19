import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionDayHeader extends StatelessWidget {
  const TransactionDayHeader({
    super.key,
    required this.date,
    required this.balance,
    this.positive = false,
  });

  final String date;
  final String balance;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.slate50,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_box_outline_blank,
            size: 16,
            color: AppColors.slate300,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              date,
              style: const TextStyle(
                color: AppColors.slate800,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Text(
            'SALDO DO DIA:',
            style: TextStyle(
              color: AppColors.slate400,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            balance,
            style: TextStyle(
              color: positive ? AppColors.primary : AppColors.danger,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
