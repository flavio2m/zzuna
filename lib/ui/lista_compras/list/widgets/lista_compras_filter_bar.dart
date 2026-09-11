import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/create/item_compra/widgets/item_compra_modal.dart';
import 'package:zzuna/ui/lista_compras/create/lista_compra/widgets/clonar_lista_anterior_button.dart';
import 'package:zzuna/ui/lista_compras/create/lista_compra/widgets/duplicar_lista_compra_modal.dart';
import 'package:zzuna/ui/lista_compras/delete/lista_compra/widgets/excluir_lista_button.dart';
import 'package:zzuna/ui/lista_compras/list/viewmodels/lista_compras_list_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/list/widgets/lista_compras_actions_bar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_year_stepper.dart';

class ListaComprasFilterBar extends ConsumerWidget {
  const ListaComprasFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listVm = ref.watch(listaComprasListViewModelProvider);
    final createVm = ref.watch(listaComprasCreateViewModelProvider);
    final filterState = ref.watch(listaComprasFilterProvider);
    final maxYear = DateTime.now().year + 2;
    final temLista = listVm.listaAtual != null;
    final isCreating = createVm.criarListaVaziaCommand.value.isRunning;

    return AppFilterCard(
      initiallyExpanded: false,
      collapsedHeaderAction: const ListaComprasActionsBar(),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildPeriodNavigator(ref, filterState, maxYear),
          _buildSituacaoDropdown(ref, filterState),
          _buildSupermercadoDropdown(ref, filterState, listVm),
          if (temLista) ...[
            ButtonAdd(
              label: 'Adicionar Produto',
              icon: Icons.add_shopping_cart,
              onPressed: () => ItemCompraModal.show(context),
            ),
            if (listVm.listaAtual?.itens.isNotEmpty ?? false)
              ButtonAdd(
                label: 'Clonar esta Lista',
                icon: Icons.copy_rounded,
                color: AppColors.indigo600,
                onPressed: () =>
                    DuplicarListaCompraModal.show(context, listVm.listaAtual!),
              ),
            ExcluirListaButton(lista: listVm.listaAtual!),
          ] else ...[
            ButtonAdd(
              label: 'Criar Lista',
              icon: Icons.note_add_outlined,
              loading: isCreating,
              onPressed: () {
                createVm.criarListaVaziaCommand.execute(filterState);
              },
            ),
            const ClonarListaAnteriorButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodNavigator(
    WidgetRef ref,
    dynamic filterState,
    int maxYear,
  ) {
    final notifier = ref.read(listaComprasFilterProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: (filterState.mes == Mes.janeiro && filterState.ano == 2025)
              ? null
              : () => notifier.mesAnterior(),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 140,
          child: AppDropdownFormField<Mes>(
            label: 'Mês',
            value: filterState.mes,
            items: Mes.values
                .map(
                  (mes) =>
                      AppDropdownMenuItem(value: mes, label: mes.descricao),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) notifier.setMes(value);
            },
          ),
        ),
        const SizedBox(width: 8),
        AppYearStepper(
          value: filterState.ano,
          min: 2025,
          max: maxYear,
          onChanged: (value) {
            notifier.setAno(value);
          },
        ),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed:
              (filterState.mes == Mes.dezembro && filterState.ano == maxYear)
              ? null
              : () => notifier.proximoMes(),
        ),
      ],
    );
  }

  Widget _buildSituacaoDropdown(WidgetRef ref, dynamic filterState) {
    final notifier = ref.read(listaComprasFilterProvider.notifier);

    return SizedBox(
      width: 140,
      child: AppDropdownFormField<ItemCompraSituacao?>(
        label: 'Situação',
        value: filterState.situacao,
        items: [
          AppDropdownMenuItem<ItemCompraSituacao?>(value: null, label: 'Todas'),
          ...ItemCompraSituacao.values.map(
            (s) => AppDropdownMenuItem<ItemCompraSituacao?>(
              value: s,
              label: s.descricao,
            ),
          ),
        ],
        onChanged: (value) {
          notifier.setSituacao(value);
        },
      ),
    );
  }

  Widget _buildSupermercadoDropdown(
    WidgetRef ref,
    dynamic filterState,
    ListaComprasListViewModel listVm,
  ) {
    final notifier = ref.read(listaComprasFilterProvider.notifier);
    final supermercados = listVm.supermercadosDisponiveis;

    return SizedBox(
      width: 180,
      child: AppDropdownFormField<String?>(
        label: 'Supermercado',
        value: filterState.supermercado,
        items: [
          AppDropdownMenuItem<String?>(value: null, label: 'Todos'),
          ...supermercados.map(
            (s) => AppDropdownMenuItem<String?>(value: s, label: s),
          ),
        ],
        onChanged: supermercados.isEmpty
            ? null
            : (value) {
                notifier.setSupermercado(value);
              },
      ),
    );
  }
}
