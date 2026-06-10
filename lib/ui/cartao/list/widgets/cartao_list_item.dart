import 'package:flutter/material.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/ui/cartao/delete/widgets/cartao_delete_button.dart';
import 'package:zzuna/ui/cartao/update/widgets/cartao_update_modal.dart';
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_editar_button.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class CartaoListItem extends StatelessWidget {
  final CartaoDetails cartaoDetails;

  const CartaoListItem({super.key, required this.cartaoDetails});

  void _editarCartao(BuildContext context) {
    final dto = CartaoDto(
      id: cartaoDetails.id,
      descricao: cartaoDetails.descricao,
      limite: cartaoDetails.limite,
      bancoSigla: cartaoDetails.banco.sigla,
      ativo: cartaoDetails.ativo,
      diaFechamento: cartaoDetails.diaFechamento, //
    );

    CartaoUpdateModal.show(context, dto);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),

          Icon(
            cartaoDetails.ativo ? Icons.credit_card : Icons.credit_card_off,
            size: 18,
            color:
                cartaoDetails
                    .ativo //
                ? AppColors.primary
                : AppColors.slate400,
          ),

          const AppSpacing(size: AppSpacingSize.xs, axis: Axis.horizontal),

          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: AppText(
                    cartaoDetails.descricao,
                    overflow: TextOverflow.ellipsis, //
                  ),
                ),

                const AppSpacing(
                  size: AppSpacingSize.xs,
                  axis: Axis.horizontal, //
                ),

                AppTag(cartaoDetails.banco.descricao),

                const AppSpacing(
                  size: AppSpacingSize.xs,
                  axis: Axis.horizontal, //
                ),

                AppTag('Limite: R\$ ${cartaoDetails.limite.toStringAsFixed(2)}'),

                const AppSpacing(
                  size: AppSpacingSize.xs,
                  axis: Axis.horizontal, //
                ),

                AppTag('Fecha dia ${cartaoDetails.diaFechamento}'),
              ],
            ),
          ),

          IconEditarButton(onPressed: () => _editarCartao(context)),

          CartaoDeleteButton(
            cartaoId: cartaoDetails.id,
            cartaoDescricao: cartaoDetails.descricao, //
          ),

          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
        ],
      ),
    );
  }
}
