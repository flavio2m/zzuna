import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/models/lancamento_resumo_dia.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_day_header.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_row.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/formatters/date_formatter.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/lancamento_details_modal.dart';
import 'package:zzuna/ui/lancamentos/update/individual/widgets/lancamento_update_modal.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_update_modal.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';

import 'package:zzuna/ui/lancamentos/reconcile/widgets/lancamento_reconcile_button.dart';

class TransactionDayCard extends ConsumerStatefulWidget {
  const TransactionDayCard({super.key, required this.dia});

  final LancamentoResumoDia dia;

  @override
  ConsumerState<TransactionDayCard> createState() => _TransactionDayCardState();
}

class _TransactionDayCardState extends ConsumerState<TransactionDayCard> {
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _isCollapsed = ref.read(lancamentoFilterProvider).ocultarLancamentos;
  }

  String _categoryPath(CategoriaDetails cat) {
    if (cat.categoriaPai != null) {
      return '${_categoryPath(cat.categoriaPai!)} > ${cat.descricao}';
    }
    return cat.descricao;
  }

  String _formatValue(double valor, LancamentoTipo tipo) {
    return UtilBrasilFields.obterReal(valor.abs(), moeda: false);
  }

  double _calcCalculatedValue(
    LancamentoDetails l,
    Set<String> categoriasSelecionadas,
    Set<String> centrosSelecionados,
  ) {
    if (categoriasSelecionadas.isEmpty && centrosSelecionados.isEmpty) {
      return l.valor;
    }

    double sum = 0;
    for (final item in l.itens) {
      if (item is LancamentoItemDetailsStandard) {
        final matchesCategory =
            categoriasSelecionadas.isEmpty ||
            categoriasSelecionadas.contains(item.categoria.id) ||
            (item.categoria.categoriaPai != null &&
                categoriasSelecionadas.contains(
                  item.categoria.categoriaPai!.id,
                ));

        final matchesCc =
            centrosSelecionados.isEmpty ||
            centrosSelecionados.contains(item.centroCusto.id);

        if (matchesCategory && matchesCc) {
          sum += item.valor;
        }
      } else {
        sum += item.valor;
      }
    }

    return sum;
  }

  Widget _buildTransactionRow(BuildContext context, LancamentoDetails l) {
    final filterState = ref.watch(lancamentoFilterProvider);
    final valorExibicao = _calcCalculatedValue(
      l,
      filterState.categoriasSelecionadas,
      filterState.centrosSelecionados,
    );
    final formattedValue = _formatValue(valorExibicao, l.tipo);
    const String? badge = null;

    final costCenter = //
    l.itens.isEmpty
        ? 'CC: Geral'
        : 'CC: ${l.itens.map((i) => switch (i) {
            LancamentoItemDetailsStandard(:final centroCusto) => centroCusto.descricao,
            LancamentoItemDetailsTransferencia() => 'Transferência',
          }).join(', ')}';

    final categoryPath = //
    l.itens.isNotEmpty
        ? (switch (l.itens.first) {
            LancamentoItemDetailsStandard(:final categoria) => _categoryPath(
              categoria,
            ),
            LancamentoItemDetailsTransferencia() => 'Transferência',
          })
        : 'Sem categoria';

    final selected = ref.watch(
      lancamentosListViewModelProvider.select(
        (vm) => vm.selectedLancamentoIds.contains(l.id), //
      ),
    );

    final desconsiderado = ref.watch(
      lancamentoFilterProvider.select(
        (s) => s.lancamentosDesconsiderados.contains(l.id),
      ),
    );

    return TransactionRow(
      lancamentoId: l.id,
      description: l.descricao,
      category: categoryPath,
      origem: l.origem,
      value: formattedValue,
      tipo: l.tipo,
      costCenter: costCenter,
      badge: badge,
      grupo: l.grupo,
      conciliado: l.conciliado,
      selected: selected,
      desconsiderado: desconsiderado,
      lancamento: l,
      reconcileButton: LancamentoReconcileButton(
        lancamentoId: l.id,
        conciliado: l.conciliado,
      ),
      onTap: () {
        if (l.conciliado) {
          AppDialog.show(
            context: context,
            child: LancamentoDetailsModal(lancamento: l),
          );
        } else {
          if (l.tipo == LancamentoTipo.transferencia && l.grupo != null) {
            TransferenciaUpdateModal.show(context, grupoId: l.grupo!.grupoId);
          } else {
            AppDialog.show(
              context: context,
              child: LancamentoUpdateModal(lancamento: l),
            );
          }
        }
      },
      onSelect: (_) {
        ref.read(lancamentosListViewModelProvider).toggleSelection(l.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(lancamentoFilterProvider.select((s) => s.ocultarLancamentos), (
      previous,
      next,
    ) {
      if (_isCollapsed != next) {
        setState(() {
          _isCollapsed = next;
        });
      }
    });

    final dia = widget.dia;
    final dateKey = DateFormatter.fullDate(dia.data);
    final shortDateKey = DateFormatter.shortDate(dia.data);

    final isPositive = dia.saldo >= 0;
    final prefix = isPositive ? '' : '- ';
    final balanceStr =
        '$prefix${UtilBrasilFields.obterReal(dia.saldo.abs(), moeda: false)}';

    final isExtractPositive = dia.saldoExtrato >= 0;
    final extractPrefix = isExtractPositive ? '' : '- ';
    final extractBalanceStr =
        '$extractPrefix${UtilBrasilFields.obterReal(dia.saldoExtrato.abs(), moeda: false)}';

    final rows = dia.lancamentos
        .map(
          (l) => _buildTransactionRow(context, l), //
        )
        .toList();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6), //
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final viewModel = ref.watch(lancamentosListViewModelProvider);
                final allSelected = dia.lancamentos.every(
                  (l) => viewModel.selectedLancamentoIds.contains(l.id), //
                );

                return TransactionDayHeader(
                  date: dateKey,
                  shortDate: shortDateKey,
                  balance: balanceStr,
                  extractBalance: extractBalanceStr,
                  positive: isPositive,
                  positiveExtract: isExtractPositive,
                  selected: allSelected,
                  isCollapsed: _isCollapsed,
                  onToggleCollapse: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                  onSelectAll: () {
                    final ids = dia.lancamentos.map((l) => l.id).toList();
                    viewModel.toggleSelectionForList(ids, !allSelected);
                  },
                );
              },
            ),
            if (!_isCollapsed)
              for (var index = 0; index < rows.length; index++) ...[
                rows[index],
                if (index != rows.length - 1)
                  const Divider(
                    height: 1,
                    color: AppColors.slate100, //
                  ),
              ],
          ],
        ),
      ),
    );
  }
}
