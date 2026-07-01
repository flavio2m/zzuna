import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class IconSelecionarTodosButton extends StatelessWidget {
  final bool allSelected;
  final VoidCallback? onPressed;

  const IconSelecionarTodosButton({
    super.key,
    required this.allSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        allSelected ? Icons.deselect : Icons.select_all,
        size: 20,
      ),
      color: AppColors.primary,
      tooltip: allSelected ? 'Limpar seleção' : 'Selecionar todos os lançamentos',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
