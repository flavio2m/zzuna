import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter/material.dart';

class TransactionDayHeader extends StatelessWidget {
  const TransactionDayHeader({
    super.key,
    required this.date,
    required this.shortDate,
    required this.balance,
    required this.extractBalance,
    this.positive = false,
    this.positiveExtract = false,
    this.selected = false,
    this.onSelectAll,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  final String date;
  final String shortDate;
  final String balance;
  final String extractBalance;
  final bool positive;
  final bool positiveExtract;
  final bool selected;
  final VoidCallback? onSelectAll;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        border: isCollapsed
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
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
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: onToggleCollapse,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        isDesktop ? date : shortDate,
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
                            AppText(
                              isDesktop ? 'Saldo do dia: ' : 'S. Dia: ',
                              variant: AppTextVariant.caption,
                              color: AppColors.slate400,
                              fontWeight: FontWeight.w900,
                            ),
                            AppText(
                              balance,
                              variant: AppTextVariant.caption,
                              color: positive
                                  ? AppColors.primary
                                  : AppColors.danger,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              isDesktop ? 'Saldo Extrato: ' : 'S. Extrato: ',
                              variant: AppTextVariant.caption,
                              color: AppColors.slate400,
                              fontWeight: FontWeight.w900,
                            ),
                            AppText(
                              extractBalance,
                              variant: AppTextVariant.caption,
                              color: positiveExtract
                                  ? AppColors.primary
                                  : AppColors.danger,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          isCollapsed
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_down,
                          size: 18,
                          color: AppColors.slate400,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
