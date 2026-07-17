import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/centro_custo/create/widgets/centro_custo_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';

class CentroCustoFilterBar extends ConsumerStatefulWidget {
  const CentroCustoFilterBar({super.key});

  @override
  ConsumerState<CentroCustoFilterBar> createState() =>
      _CentroCustoFilterBarState();
}

class _CentroCustoFilterBarState extends ConsumerState<CentroCustoFilterBar> {
  final _descFocus = FocusNode();

  @override
  void dispose() {
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(centroCustoListViewModelProvider);

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
              focusNode: _descFocus,
              onChanged: viewModel.setDescricao,
              onFieldSubmitted: (_) {
                viewModel.pesquisar();
                _descFocus.requestFocus();
              },
            ),
          ),
          SizedBox(
            width: 160,
            child: ListenableBuilder(
              listenable: viewModel.loadCommand,
              builder: (context, _) => AppStatusDropdown(
                value: viewModel.ativoSelecionado,
                onChanged: viewModel.setAtivo,
              ),
            ),
          ),
          ButtonFind(onPressed: viewModel.pesquisar),
          ButtonAdd(onPressed: () => CentroCustoCreateModal.show(context)),
        ],
      ),
    );
  }
}
