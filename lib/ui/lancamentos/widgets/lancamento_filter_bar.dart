import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_find.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_year_stepper.dart';
import 'package:zzuna/ui/lancamentos/viewmodels/lancamentos_list_viewmodel.dart';

class LancamentoFilterBar extends ConsumerStatefulWidget {
  const LancamentoFilterBar({super.key});

  @override
  ConsumerState<LancamentoFilterBar> createState() => _LancamentoFilterBarState();
}

class _LancamentoFilterBarState extends ConsumerState<LancamentoFilterBar> {
  late final TextEditingController _descricaoController;
  late final FocusNode _descricaoFocusNode;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(lancamentosListViewModelProvider);
    _descricaoController = TextEditingController(text: viewModel.descricaoQuery);
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
    final viewModel = ref.watch(lancamentosListViewModelProvider);
    final maxYear = DateTime.now().year + 2;

    return ListenableBuilder(
      listenable: viewModel.loadCommand,
      builder: (context, _) {
        return AppFilterCard(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildPeriodNavigator(viewModel, maxYear),
              // 3. Descrição
              SizedBox(
                width: 250,
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
                  },
                ),
              ),
              // 4. Tipo
              SizedBox(
                width: 128,
                child: AppDropdownFormField<LancamentoTipo?>(
                  label: 'Tipo',
                  value: viewModel.tipoSelecionado,
                  items: [
                    AppDropdownMenuItem<LancamentoTipo?>(
                      value: null,
                      label: 'Todos', //
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
                    AppDropdownMenuItem<LancamentoTipo?>(
                      value: LancamentoTipo.investimento,
                      label: LancamentoTipo.investimento.descricao,
                    ),
                  ],
                  onChanged: (value) {
                    viewModel.setTipo(value);
                  },
                ),
              ),
              // 5. Conciliado (AppDropdownFormField)
              SizedBox(
                width: 160,
                child: AppDropdownFormField<bool?>(
                  label: 'Conciliado',
                  value: viewModel.conciliadoSelecionado,
                  items: [
                    AppDropdownMenuItem<bool?>(value: null, label: 'Todos'),
                    AppDropdownMenuItem<bool?>(value: true, label: 'Conciliado'),
                    AppDropdownMenuItem<bool?>(value: false, label: 'Não conciliado'),
                  ],
                  onChanged: (value) {
                    viewModel.setConciliado(value);
                  },
                ),
              ),
              // 6. Pesquisar
              ButtonFind(
                onPressed: () {
                  viewModel.pesquisar();
                },
              ),
              // 7. Adicionar
              ButtonAdd(onPressed: () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodNavigator(LancamentosListViewModel viewModel, int maxYear) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: (viewModel.mesSelecionado == Mes.janeiro && viewModel.anoSelecionado == 2025)
              ? null
              : () => viewModel.mesAnterior(),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 108,
          child: AppDropdownFormField<Mes>(
            label: 'Mês',
            value: viewModel.mesSelecionado,
            items: Mes.values.map((mes) => AppDropdownMenuItem(value: mes, label: mes.descricao)).toList(),
            onChanged: (value) {
              viewModel.setMes(value);
            },
          ),
        ),
        const SizedBox(width: 8),
        AppYearStepper(
          value: viewModel.anoSelecionado,
          min: 2025,
          max: maxYear,
          onChanged: (value) {
            viewModel.setAno(value);
          },
        ),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: (viewModel.mesSelecionado == Mes.dezembro && viewModel.anoSelecionado == maxYear)
              ? null
              : () => viewModel.proximoMes(),
        ),
      ],
    );
  }
}
