import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/ui/cartao/create/widgets/cartao_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';

class CartaoFilterBar extends ConsumerStatefulWidget {
  const CartaoFilterBar({super.key});

  @override
  ConsumerState<CartaoFilterBar> createState() => _CartaoFilterBarState();
}

class _CartaoFilterBarState extends ConsumerState<CartaoFilterBar> {
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
    final viewModel = ref.read(cartaoListViewModelProvider);
    _descricaoController.text = viewModel.descricaoQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(cartaoListViewModelProvider);

    return AppFilterCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
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
            width: 220,
            child: ListenableBuilder(
              listenable: viewModel.loadCommand,
              builder: (context, _) => AppDropdownFormField<String>(
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

          ButtonAdd(onPressed: () => CartaoCreateModal.show(context)),
        ],
      ),
    );
  }
}
