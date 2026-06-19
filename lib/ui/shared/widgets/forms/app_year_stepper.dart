import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class AppYearStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const AppYearStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged, //
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 38),
            icon: const Icon(Icons.remove, color: AppColors.slate600),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Container(width: 1, height: 20, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: AppColors.slate800,
                fontSize: 13,
                fontWeight: FontWeight.w700, //
              ),
            ),
          ),
          Container(width: 1, height: 20, color: AppColors.border),
          IconButton(
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 38),
            icon: const Icon(Icons.add, color: AppColors.slate600),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
