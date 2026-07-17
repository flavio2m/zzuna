import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_create_modal.dart';

class CreateDespesaButton extends StatelessWidget {
  const CreateDespesaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_downward, size: 20),
      color: Theme.of(context).colorScheme.error,
      tooltip: 'Adicionar Despesa',
      onPressed: () => LancamentoCreateModal.show(
        context,
        initialTipo: LancamentoTipo.despesa,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
