import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/centro_custo_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_origem_field.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';

class LancamentoPendenteFilterBar extends ConsumerStatefulWidget {
  const LancamentoPendenteFilterBar({super.key});

  @override
  ConsumerState<LancamentoPendenteFilterBar> createState() =>
      _LancamentoPendenteFilterBarState();
}

class _LancamentoPendenteFilterBarState
    extends ConsumerState<LancamentoPendenteFilterBar> {
  late final TextEditingController _descricaoController;
  late final FocusNode _descricaoFocusNode;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController();
    _descricaoFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _descricaoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(lancamentoPendenteViewModelProvider);

    return AppFilterCard(
      title: 'Filtrar',
      initiallyExpanded: true,
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // 1. Descrição (pesquisa ao pressionar Enter)
          SizedBox(
            width: 220,
            child: AppTextFormField(
              controller: _descricaoController,
              focusNode: _descricaoFocusNode,
              textInputAction: TextInputAction.search,
              label: 'Descrição',
              onFieldSubmitted: (value) {
                viewModel.updateFilter(descricao: value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _descricaoFocusNode.requestFocus();
                });
              },
            ),
          ),
          // 2. Tipo
          SizedBox(
            width: 128,
            child: AppDropdownFormField<LancamentoTipo?>(
              label: 'Tipo',
              value: viewModel.currentFilter.tipo,
              items: [
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: null,
                  label: 'Todos',
                ),
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: LancamentoTipo.receita,
                  label: LancamentoTipo.receita.descricao,
                ),
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: LancamentoTipo.despesa,
                  label: LancamentoTipo.despesa.descricao,
                ),
                AppDropdownMenuItem<LancamentoTipo?>(
                  value: LancamentoTipo.transferencia,
                  label: LancamentoTipo.transferencia.descricao,
                ),
              ],
              onChanged: (value) {
                viewModel.updateFilter(tipo: value, clearTipo: value == null);
              },
            ),
          ),
          // 3. Conta / Cartão
          SizedBox(
            width: 200,
            child: LancamentoOrigemField(
              origens: viewModel.origens,
              value: viewModel.selectedOrigem,
              showAllOption: true,
              allOptionLabel: 'Todas',
              onChanged: (value) {
                viewModel.setOrigem(value);
              },
            ),
          ),
          // 4. Categoria
          SizedBox(
            width: 200,
            child: CategoriaField(
              categorias: viewModel.categorias,
              value: viewModel.selectedCategoria,
              showAllOption: true,
              allOptionLabel: 'Todas',
              onChanged: (value) {
                viewModel.setCategoria(value);
              },
            ),
          ),
          // 5. Centro de Custo
          SizedBox(
            width: 180,
            child: CentroCustoField(
              centros: viewModel.centros,
              value: viewModel.selectedCentroCusto,
              showAllOption: true,
              allOptionLabel: 'Todos',
              onChanged: (value) {
                viewModel.setCentroCusto(value);
              },
            ),
          ),
          // Botão Pesquisar
          ButtonFind(
            onPressed: () {
              viewModel.updateFilter(descricao: _descricaoController.text);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _descricaoFocusNode.requestFocus();
              });
            },
          ),
        ],
      ),
    );
  }
}
