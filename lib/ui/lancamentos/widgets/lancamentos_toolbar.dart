import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LancamentosToolbar extends StatelessWidget {
  const LancamentosToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          _SelectPill(
            icon: Icons.calendar_today_outlined,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MiniSelect(
                  value: 'Marco',
                  items: const ['Marco', 'Abril', 'Maio', 'Junho'],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text('/', style: TextStyle(color: AppColors.slate300)),
                ),
                _MiniSelect(
                  value: '2026',
                  items: const ['2025', '2026', '2027'],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const _SelectPill(
            icon: Icons.filter_alt_outlined,
            child: Text(
              'Todas as Transacoes',
              style: TextStyle(
                color: AppColors.slate700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: _SearchField()),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.download_outlined,
            label: 'Exportar dados',
            background: AppColors.slate50,
            foreground: AppColors.slate700,
            borderColor: AppColors.border,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.add,
            label: 'Adicionar lancamento',
            background: AppColors.primary,
            foreground: AppColors.surface,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MiniSelect extends StatelessWidget {
  const _MiniSelect({required this.value, required this.items});

  final String value;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        iconSize: 16,
        style: const TextStyle(
          color: AppColors.slate700,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (_) {},
      ),
    );
  }
}

class _SelectPill extends StatelessWidget {
  const _SelectPill({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.slate400),
          const SizedBox(width: 8),
          child,
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 290),
      child: SizedBox(
        height: 36,
        child: TextField(
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.slate50,
            hintText: 'Buscar lancamentos...',
            hintStyle: const TextStyle(
              color: AppColors.slate400,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 17,
              color: AppColors.slate400,
            ),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: borderColor == null ? null : BorderSide(color: borderColor!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }
}
