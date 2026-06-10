import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/ui/conta/create/widgets/conta_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';

class ContaFilterBar extends ConsumerWidget {
  const ContaFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(contaListViewModelProvider);
    TextEditingController? descricaoController = TextEditingController();
    final descricaoFocusNode = FocusNode();

    return AppFilterCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 300,
            child: AppTextFormField(
              controller: descricaoController,
              focusNode: descricaoFocusNode,
              textInputAction: TextInputAction.search,
              label: 'Descrição',
              onChanged: (value) {
                viewModel.setDescricao(value);
              },
              onFieldSubmitted: (_) {
                viewModel.pesquisar();
              },
            ),
          ),
          SizedBox(
            width: 220,
            child: AppDropdownFormField<String>(
              label: 'Banco',
              value: viewModel.bancoSelecionado,
              items: [
                AppDropdownMenuItem(value: '', label: 'Todos'),
                ...Bancos.items.map(
                  (banco) => AppDropdownMenuItem(
                    value: banco.sigla,
                    label: banco.descricao, //
                  ),
                ),
              ],
              onChanged: (value) {
                viewModel.setBanco(value);
              },
            ),
          ),

          SizedBox(
            width: 160,
            child: AppStatusDropdown(
              value: viewModel.statusSelecionado,
              onChanged: (value) {
                viewModel.setStatus(value);
              },
            ),
          ),

          ButtonFind(
            onPressed: () {
              viewModel.pesquisar();
            },
          ),

          ButtonAdd(onPressed: () => ContaCreateModal.show(context)),
        ],
      ),
    );
  }
}
