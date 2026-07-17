import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class CreateReceitaButton extends StatelessWidget {
  const CreateReceitaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add, size: 20),
      color: AppColors.primary,
      tooltip: 'Adicionar Entrada',
      onPressed: () => LancamentoCreateModal.show(
        context,
        initialTipo: LancamentoTipo.receita,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
