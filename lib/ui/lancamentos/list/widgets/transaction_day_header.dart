import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter/material.dart';

class TransactionDayHeader extends StatelessWidget {
  const TransactionDayHeader({
    super.key,
    required this.date,
    required this.balance,
    required this.extractBalance,
    this.positive = false,
    this.positiveExtract = false,
    this.selected = false,
    this.onSelectAll,
  });

  final String date;
  final String balance;
  final String extractBalance;
  final bool positive;
  final bool positiveExtract;
  final bool selected;
  final VoidCallback? onSelectAll;

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
          GestureDetector(
            onTap: onSelectAll,
            child: Container(
              color: Colors.transparent, // Amplia a área de toque
              padding: const EdgeInsets.all(4),
              child: Icon(
                selected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16,
                color: selected ? AppColors.primary : AppColors.slate300, //
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              date,
              variant: AppTextVariant.body,
              color: AppColors.slate800,
              fontWeight: FontWeight.w800, //
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(
                    'SALDO DO DIA: ',
                    variant: AppTextVariant.caption,
                    color: AppColors.slate400,
                    fontWeight: FontWeight.w900,
                  ),
                  AppText(
                    balance,
                    variant: AppTextVariant.caption,
                    color: positive ? AppColors.primary : AppColors.danger,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(
                    'SALDO EXTRATO: ',
                    variant: AppTextVariant.caption,
                    color: AppColors.slate400,
                    fontWeight: FontWeight.w900,
                  ),
                  AppText(
                    extractBalance,
                    variant: AppTextVariant.caption,
                    color: positiveExtract ? AppColors.primary : AppColors.danger,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
