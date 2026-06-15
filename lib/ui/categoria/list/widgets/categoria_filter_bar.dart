import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/categoria/create/widgets/categoria_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';

import 'package:zzuna/ui/shared/theme/app_colors.dart';

class CategoriaFilterBar extends ConsumerWidget {
  const CategoriaFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(categoriaListViewModelProvider);
    TextEditingController? descricaoController = TextEditingController();
    final descricaoFocusNode = FocusNode();

    return AppFilterCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
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

          ButtonAdd(onPressed: () => CategoriaCreateModal.show(context)),

          IconButton(
            tooltip: viewModel.isAllCollapsed ? 'Expandir todas' : 'Colapsar todas',
            icon: Icon(
              viewModel.isAllCollapsed ? Icons.unfold_more : Icons.unfold_less,
              color: AppColors.primary, //
            ),
            onPressed: () {
              viewModel.toggleAllCollapsed();
            },
          ),
        ],
      ),
    );
  }
}
