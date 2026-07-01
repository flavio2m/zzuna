import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class IconConciliadoButton extends StatelessWidget {
  final bool conciliado;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final bool loading;

  const IconConciliadoButton({
    super.key,
    required this.conciliado,
    this.onPressed,
    this.tooltip,
    this.size = 18,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: conciliado ? AppColors.primary : AppColors.slate400, //
        ),
      );
    }

    return IconButton(
      icon: Icon(
        Icons.check_circle_outline,
        color: conciliado ? AppColors.primary : AppColors.slate300,
        size: size, //
      ),
      tooltip: tooltip ?? (conciliado ? 'Desconciliar' : 'Conciliar'),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
