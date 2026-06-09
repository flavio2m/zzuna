import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/ui/conta/delete/viewModel/widgets/conta_delete_button.dart';
import 'package:zzuna/ui/conta/update/widgets/conta_update_modal.dart';

class ContaListItem extends ConsumerWidget {
  final Conta conta;

  const ContaListItem({super.key, required this.conta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: conta.ativo ? Colors.green : Colors.grey,
        child: Icon(
          conta.ativo ? Icons.check : Icons.close,
          color: Colors.white, //
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
          ContaDeleteButton(contaId: conta.id, descricao: conta.descricao),
        ],
      ),
    );
  }
}
