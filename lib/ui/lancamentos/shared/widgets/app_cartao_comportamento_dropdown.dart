import 'package:flutter/material.dart';
import 'package:zzuna/domain/enums/cartao_comportamento_fechamento.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/app_icon_button.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppCartaoComportamentoDropdown extends StatelessWidget {
  final CartaoComportamentoFechamento initialValue;
  final ValueChanged<CartaoComportamentoFechamento?> onChanged;

  const AppCartaoComportamentoDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<CartaoComportamentoFechamento>(
            initialValue: initialValue,
            decoration: const InputDecoration(
              labelText: 'Comportamento da Fatura',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: CartaoComportamentoFechamento.values.map((comp) {
              return DropdownMenuItem(
                value: comp,
                child: Text(
                  comp.descricao,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        AppIconButton(
          icon: Icons.help_outline,
          tooltip: 'Entenda como a fatura se comporta',
          onPressed: () {
            AppDialog.show(
              context: context,
              child: AppForm(
                title: 'Comportamento de Fechamento',
                type: AppFormType.modal,
                actions: [
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(),
                    label: 'Entendi',
                    icon: const Icon(Icons.check),
                  ),
                ],
                child: const AppText(
                  '1) Anteriores ao fechamento vão para o mês anterior:\n'
                  'Ideal para faturas que fecham no início do mês (ex: dia '
                  '10). Lançamento do dia 05 vai para a fatura do mês anterior.\n\n'
                  '2) A partir do fechamento vão para o mês seguinte:\n'
                  'Ideal para faturas que fecham no final do mês (ex: dia '
                  '25). Lançamento do dia 25 vai para a fatura do mês seguinte.\n\n'
                  '3) Manter no mês do lançamento:\n'
                  'A fatura será sempre do mesmo mês do lançamento, ignorando '
                  'o dia do fechamento.',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
