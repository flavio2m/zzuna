import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/centro_custo/create/widgets/centro_custo_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';

class CentroCustoFilterBar extends ConsumerWidget {
  const CentroCustoFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(centroCustoListViewModelProvider);
    final ativo = viewModel.ativoSelecionado;

    return AppFilterCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 300,
            child: AppTextFormField(
              initialValue: viewModel.descricaoQuery ?? '',
              label: 'Descrição',
              onChanged: viewModel.setDescricao,
            ),
          ),
          SizedBox(
            width: 160,
            child: AppStatusDropdown(value: ativo, onChanged: viewModel.setAtivo),
          ),
          ButtonFind(onPressed: viewModel.pesquisar),
          ButtonAdd(onPressed: () => CentroCustoCreateModal.show(context)),
        ],
      ),
    );
  }
}
