import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_update_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_delete.dart';

class ContaListItem extends ConsumerWidget {
  final Conta conta;

  const ContaListItem({super.key, required this.conta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(contaListViewModelProvider);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: conta.ativo ? Colors.green : Colors.grey,
        child: Icon(
          conta.ativo ? Icons.check : Icons.close,
          color: Colors.white,
        ),
      ),
      title: Text(conta.descricao),
      subtitle: Text(conta.bancoSigla),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final dto = LoadedContaDto(
                id: conta.id,
                descricao: conta.descricao,
                bancoSigla: conta.bancoSigla,
                ativo: conta.ativo,
              );
              ContaUpdateModal.show(context, dto);
            },
          ),
          ButtonDelete(
            onPressed: () async {
              final confirm = await AppConfirmationDialog.show(
                context,
                title: 'Excluir Conta',
                message: 'Deseja realmente excluir a conta "${conta.descricao}"?',
              );

              if (confirm == 'confirm') {
                viewModel.deleteCommand.execute(conta.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
