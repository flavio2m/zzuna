import 'package:flutter/material.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_create_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class CreateTransferenciaButton extends StatelessWidget {
  const CreateTransferenciaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.swap_horiz_rounded, size: 20),
      color: AppColors.indigo600,
      tooltip: 'Adicionar transferência',
      onPressed: () => TransferenciaCreateModal.show(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
