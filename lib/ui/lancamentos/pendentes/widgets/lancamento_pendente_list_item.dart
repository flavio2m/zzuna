import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_row.dart';
import 'package:zzuna/ui/lancamentos/reconcile/widgets/lancamento_reconcile_button.dart';
import 'package:zzuna/ui/lancamentos/update/individual/widgets/lancamento_update_modal.dart';
import 'package:zzuna/ui/lancamentos/transferencia/widgets/transferencia_update_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

/// Exibe um lançamento individual na lista de Pendentes.
/// Similar ao [TransactionRow], mas com binding no [lancamentoPendenteViewModelProvider].
class LancamentoPendenteRow extends ConsumerWidget {
  const LancamentoPendenteRow({super.key, required this.lancamento});

  final LancamentoDetails lancamento;

  String _categoryPath(CategoriaDetails cat) {
    if (cat.categoriaPai != null) {
      return '${_categoryPath(cat.categoriaPai!)} > ${cat.descricao}';
    }
    return cat.descricao;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = lancamento;

    final costCenter = l.itens.isEmpty
        ? 'CC: Geral'
        : 'CC: ${l.itens.map((i) => switch (i) {
            LancamentoItemDetailsStandard(:final centroCusto) => centroCusto.descricao,
            LancamentoItemDetailsTransferencia() => 'Transferência',
          }).join(', ')}';

    final categoryPath = l.itens.isNotEmpty
        ? (switch (l.itens.first) {
            LancamentoItemDetailsStandard(:final categoria) => _categoryPath(
              categoria,
            ),
            LancamentoItemDetailsTransferencia() => 'Transferência',
          })
        : 'Sem categoria';

    final formattedValue = UtilBrasilFields.obterReal(
      l.valor.abs(),
      moeda: false,
    );

    final selected = ref.watch(
      lancamentoPendenteViewModelProvider.select(
        (vm) => vm.selectedLancamentoIds.contains(l.id),
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
      badge: null,
      grupo: l.grupo,
      conciliado: l.conciliado,
      selected: selected,
      lancamento: l,
      reconcileButton: LancamentoReconcileButton(
        lancamentoId: l.id,
        conciliado: l.conciliado,
      ),
      onTap: () {
        if (l.tipo == LancamentoTipo.transferencia && l.grupo != null) {
          TransferenciaUpdateModal.show(context, grupoId: l.grupo!.grupoId);
        } else {
          AppDialog.show(
            context: context,
            child: LancamentoUpdateModal(lancamento: l),
          );
        }
      },
      onSelect: (_) {
        ref.read(lancamentoPendenteViewModelProvider).toggleSelection(l.id);
      },
    );
  }
}

/// Card de grupo de lançamentos do mesmo dia (usada na lista de Pendentes).
class LancamentoPendenteDayCard extends StatelessWidget {
  const LancamentoPendenteDayCard({
    super.key,
    required this.data,
    required this.lancamentos,
  });

  final DateTime data;
  final List<LancamentoDetails> lancamentos;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header simples com data
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: AppColors.slate100,
              child: Row(
                children: [
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.slate700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${lancamentos.length} lançamento${lancamentos.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
            for (var i = 0; i < lancamentos.length; i++) ...[
              LancamentoPendenteRow(lancamento: lancamentos[i]),
              if (i != lancamentos.length - 1)
                const Divider(height: 1, color: AppColors.slate100),
            ],
          ],
        ),
      ),
    );
  }
}
