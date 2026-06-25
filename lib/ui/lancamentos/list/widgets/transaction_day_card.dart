import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/models/lancamento_resumo_dia.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_day_header.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_row.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/formatters/date_formatter.dart';

class TransactionDayCard extends StatelessWidget {
  const TransactionDayCard({super.key, required this.dia});

  final LancamentoResumoDia dia;

  String _categoryPath(CategoriaDetails cat) {
    if (cat.categoriaPai != null) {
      return '${_categoryPath(cat.categoriaPai!)} > ${cat.descricao}';
    }
    return cat.descricao;
  }

  TransactionKind _transactionKind(LancamentoTipo tipo) {
    return tipo == LancamentoTipo.receita
        ? TransactionKind.income
        : (tipo == LancamentoTipo.transferencia ? TransactionKind.transfer : TransactionKind.expense);
  }

  String _formatValue(double valor, LancamentoTipo tipo) {
    final rowPrefix = tipo == LancamentoTipo.receita ? '+' : '-';
    return UtilBrasilFields.obterReal(valor, moeda: true).replaceFirst(
      'R\$',
      '$rowPrefix R\$', //
    );
  }

  Widget _buildTransactionRow(LancamentoDetails l) {
    final kind = _transactionKind(l.tipo);
    final formattedValue = _formatValue(l.valor, l.tipo);
    const String? badge = null;

    final costCenter = //
    l.itens.isEmpty
        ? 'CC: Geral'
        : 'CC: ${l.itens.map((i) => i.centroCusto.descricao).join(', ')}';

    final categoryPath = //
    l.itens.isNotEmpty
        ? _categoryPath(l.itens.first.categoria)
        : 'Sem categoria';

    return TransactionRow(
      description: l.descricao,
      category: categoryPath,
      account: switch (l.origem) {
        LancamentoOrigemContaDetail(conta: final c) => c.descricao,
        LancamentoOrigemCartaoDetail(cartao: final c) => c.descricao,
      },
      value: formattedValue,
      kind: kind,
      status: l.conciliado ? 'Ativo' : 'Pendente',
      costCenter: costCenter,
      badge: badge,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = DateFormatter.fullDate(dia.data);

    final isPositive = dia.saldo >= 0;
    final prefix = isPositive ? '+' : '-';
    final balanceStr =
        UtilBrasilFields //
            .obterReal(dia.saldo.abs(), moeda: true)
            .replaceFirst('R\$', '$prefix R\$');

    final isExtractPositive = dia.saldoExtrato >= 0;
    final extractPrefix = isExtractPositive ? '+' : '-';
    final extractBalanceStr = UtilBrasilFields.obterReal(
      dia.saldoExtrato.abs(),
      moeda: true,
    ).replaceFirst('R\$', '$extractPrefix R\$');

    final rows = dia.lancamentos.map(_buildTransactionRow).toList();

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
          children: [
            TransactionDayHeader(
              date: dateKey,
              balance: balanceStr,
              extractBalance: extractBalanceStr,
              positive: isPositive,
              positiveExtract: isExtractPositive,
            ),
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
