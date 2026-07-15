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

class CategoriaFilterBar extends ConsumerStatefulWidget {
  const CategoriaFilterBar({super.key});

  @override
  ConsumerState<CategoriaFilterBar> createState() => _CategoriaFilterBarState();
}

class _CategoriaFilterBarState extends ConsumerState<CategoriaFilterBar> {
  final _descricaoController = TextEditingController();
  final _descricaoFocusNode = FocusNode();

  @override
  void dispose() {
    _descricaoController.dispose();
    _descricaoFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(categoriaListViewModelProvider);
    _descricaoController.text = viewModel.descricaoQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(categoriaListViewModelProvider);

    return AppFilterCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: AppTextFormField(
              controller: _descricaoController,
              focusNode: _descricaoFocusNode,
              textInputAction: TextInputAction.search,
              label: 'Descrição',
              onChanged: (value) {
                viewModel.setDescricao(value);
              },
              onFieldSubmitted: (_) {
                viewModel.pesquisar();
                _descricaoFocusNode.requestFocus();
              },
            ),
          ),

          SizedBox(
            width: 160,
            child: ListenableBuilder(
              listenable: viewModel.loadCommand,
              builder: (context, _) => AppStatusDropdown(
                value: viewModel.statusSelecionado,
                onChanged: (value) {
                  viewModel.setStatus(value);
                },
              ),
            ),
          ),

          ButtonFind(
            onPressed: () {
              viewModel.pesquisar();
            },
          ),

          ButtonAdd(onPressed: () => CategoriaCreateModal.show(context)),

          IconButton(
            tooltip: viewModel.isAllCollapsed
                ? 'Expandir todas'
                : 'Colapsar todas',
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
