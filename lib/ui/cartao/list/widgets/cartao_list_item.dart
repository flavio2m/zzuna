import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/domain/dtos/cartao_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/ui/cartao/delete/widgets/cartao_delete_button.dart';
import 'package:zzuna/ui/cartao/update/widgets/cartao_update_modal.dart';

class CartaoListItem extends StatelessWidget {
  final Cartao cartao;

  const CartaoListItem({super.key, required this.cartao});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cartao.ativo ? Colors.blue : Colors.grey,
        child: const Icon(Icons.credit_card, color: Colors.white),
      ),
      title: AppText(cartao.descricao, variant: AppTextVariant.subtitle),
      subtitle: AppText(
        '${cartao.bancoSigla} - Limite: R$ ${cartao.limite.toStringAsFixed(2)} - Fecha dia: ${cartao.diaFechamento}',
        variant: AppTextVariant.caption,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final dto = CartaoDto(
                id: cartao.id,
                descricao: cartao.descricao,
                limite: cartao.limite,
                bancoSigla: cartao.bancoSigla,
                ativo: cartao.ativo,
                diaFechamento: cartao.diaFechamento,
              );
              CartaoUpdateModal.show(context, dto);
            },
          ),
          CartaoDeleteButton(
            cartaoId: cartao.id,
            cartaoDescricao: cartao.descricao,
          ),
        ],
      ),
    );
  }
}
