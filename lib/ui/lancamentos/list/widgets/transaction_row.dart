import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum TransactionKind { income, expense, transfer }

class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.description,
    required this.category,
    required this.account,
    required this.value,
    this.kind = TransactionKind.expense,
    this.status = 'Pendente',
    this.costCenter = 'CC: Geral',
    this.badge,
    this.selected = false,
    this.onTap,
  });

  final String description;
  final String category;
  final String account;
  final String value;
  final TransactionKind kind;
  final String status;
  final String costCenter;
  final String? badge;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = kind == TransactionKind.income;
    final isTransfer = kind == TransactionKind.transfer;
    final iconColor = isIncome
        ? AppColors.primary
        : (isTransfer ? AppColors.indigo600 : AppColors.danger);
    final iconBackground = isIncome
        ? AppColors.emerald50
        : (isTransfer ? AppColors.indigo50 : AppColors.rose50);
    final icon = isIncome
        ? Icons.arrow_upward_rounded
        : (isTransfer ? Icons.layers_outlined : Icons.arrow_downward_rounded);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: selected
            ? AppColors.emerald50.withValues(alpha: 0.35)
            : AppColors.surface,
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 17,
              color: selected ? AppColors.primary : AppColors.slate300,
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.slate800,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        _Badge(label: badge!),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 5,
                    children: [
                      _MetaChip(
                        icon: isTransfer || account.contains('Nubank')
                            ? Icons.credit_card
                            : Icons.account_balance_wallet_outlined,
                        label: account,
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.slate300,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        category,
                        style: const TextStyle(
                          color: AppColors.slate600,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.slate300,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        costCenter,
                        style: const TextStyle(
                          color: AppColors.slate500,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _StatusBadge(status: status),
            const SizedBox(width: 12),
            SizedBox(
              width: 104,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isIncome
                      ? AppColors.primary
                      : (isTransfer ? AppColors.slate600 : AppColors.danger),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.slate300,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.slate500),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.slate600,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.indigo50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.indigo100),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.indigo600,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final consolidated = status == 'Ativo';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: consolidated ? AppColors.emerald100 : AppColors.orange100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: consolidated ? AppColors.emerald200 : AppColors.orange200,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: consolidated ? AppColors.emerald800 : AppColors.orange800,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
