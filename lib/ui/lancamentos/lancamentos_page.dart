import 'package:zzuna/ui/lancamentos/widgets/accounts_side_menu.dart';
import 'package:zzuna/ui/lancamentos/widgets/lancamentos_toolbar.dart';
import 'package:zzuna/ui/lancamentos/widgets/transaction_day_header.dart';
import 'package:zzuna/ui/lancamentos/widgets/transaction_row.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LancamentosPage extends StatelessWidget {
  const LancamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AccountsSideMenu(),
        Expanded(
          child: Column(
            children: [
              LancamentosToolbar(),
              Expanded(child: _TransactionsWorkspace()),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionsWorkspace extends StatelessWidget {
  const _TransactionsWorkspace();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _TransactionDayCard(
            date: '05/03/2026, Quinta-feira',
            balance: '+R\$ 6.708,73',
            positive: true,
            rows: [
              TransactionRow(
                description: 'Salario',
                category: 'Receitas > Salario',
                account: 'BC BB',
                value: '+R\$ 7.374,93',
                kind: TransactionKind.income,
                status: 'Ativo',
                costCenter: 'CC: Geral',
                selected: true,
              ),
              TransactionRow(
                description: 'Emprestimo Guilherme',
                category: 'Receitas > Terceiros',
                account: 'BC BB',
                value: '-R\$ 666,20',
                status: 'Pendente',
                costCenter: 'CC: Geral',
              ),
            ],
          ),
          SizedBox(height: 16),
          _TransactionDayCard(
            date: '04/03/2026, Quarta-feira',
            balance: '-R\$ 2.040,07',
            rows: [
              TransactionRow(
                description: 'Boleto Cartorio Registro Imoveis',
                category: 'Moradia > Financiamento',
                account: 'BC C6',
                value: '-R\$ 1.877,21',
                status: 'Ativo',
                costCenter: 'CC: Habitacao',
                badge: 'Recorrente',
              ),
              TransactionRow(
                description: 'Seguro Imovel',
                category: 'Moradia > Condominio',
                account: 'BC Bradesco',
                value: '-R\$ 162,86',
                status: 'Pendente',
                costCenter: 'CC: Habitacao',
              ),
            ],
          ),
          SizedBox(height: 16),
          _TransactionDayCard(
            date: '03/03/2026, Terca-feira',
            balance: '-R\$ 884,72',
            rows: [
              TransactionRow(
                description: 'Supermercado Goncalves',
                category: 'Alimentacao > Supermercado',
                account: 'Nubank Ultravioleta',
                value: '-R\$ 524,15',
                status: 'Pendente',
                costCenter: 'CC: Geral',
                badge: 'Rateio',
              ),
              TransactionRow(
                description: 'Transferencia Bradesco',
                category: 'Transferencia',
                account: 'BC Bradesco',
                value: '-R\$ 360,57',
                kind: TransactionKind.transfer,
                status: 'Ativo',
                costCenter: 'CC: Geral',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionDayCard extends StatelessWidget {
  const _TransactionDayCard({
    required this.date,
    required this.balance,
    required this.rows,
    this.positive = false,
  });

  final String date;
  final String balance;
  final List<Widget> rows;
  final bool positive;

  @override
  Widget build(BuildContext context) {
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
            TransactionDayHeader(
              date: date,
              balance: balance,
              positive: positive,
            ),
            for (var index = 0; index < rows.length; index++) ...[
              rows[index],
              if (index != rows.length - 1)
                const Divider(height: 1, color: AppColors.slate100),
            ],
          ],
        ),
      ),
    );
  }
}
