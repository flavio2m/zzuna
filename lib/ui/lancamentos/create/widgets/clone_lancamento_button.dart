import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class CloneLancamentoButton extends StatelessWidget {
  final LancamentoDetails lancamento;

  const CloneLancamentoButton({super.key, required this.lancamento});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 18, color: AppColors.slate600),
      tooltip: 'Clonar Lançamento',
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(4),
      onPressed: () {
        LancamentoCreateModal.show(context, cloneLancamento: lancamento);
      },
    );
  }
}
