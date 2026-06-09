import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/ui/cartao/delete/widgets/cartao_delete_button.dart';
import 'package:zzuna/ui/cartao/update/widgets/cartao_update_modal.dart';

class CartaoListItem extends StatelessWidget {
  final CartaoDetails cartaoDetails;

  const CartaoListItem({super.key, required this.cartaoDetails});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cartaoDetails.ativo ? Colors.blue : Colors.grey,
        child: const Icon(Icons.credit_card, color: Colors.white),
      ),
      title: AppText(cartaoDetails.descricao, variant: AppTextVariant.subtitle),
      subtitle: AppText(
        '${cartaoDetails.banco.sigla} - Limite: R\$ ${cartaoDetails.limite.toStringAsFixed(2)} - Fecha dia: ${cartaoDetails.diaFechamento}',
        variant: AppTextVariant.caption,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final dto = CartaoDto(
                id: cartaoDetails.id,
                descricao: cartaoDetails.descricao,
                limite: cartaoDetails.limite,
                bancoSigla: cartaoDetails.banco.sigla,
                ativo: cartaoDetails.ativo,
                diaFechamento: cartaoDetails.diaFechamento,
              );
              CartaoUpdateModal.show(context, dto);
            },
          ),
          CartaoDeleteButton(
            cartaoId: cartaoDetails.id,
            cartaoDescricao: cartaoDetails.descricao, //
          ),
        ],
      ),
    );
  }
}
