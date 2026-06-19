import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/ui/lancamentos/sidebar/widgets/accounts_side_menu.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/lancamento_filter_bar.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_day_header.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_row.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentosPage extends ConsumerStatefulWidget {
  const LancamentosPage({super.key});

  @override
  ConsumerState<LancamentosPage> createState() => _LancamentosPageState();
}

class _LancamentosPageState extends ConsumerState<LancamentosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lancamentosListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AccountsSideMenu(),
        Expanded(
          child: Column(
            children: [
              LancamentoFilterBar(),
              Expanded(child: _TransactionsWorkspace()),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionsWorkspace extends ConsumerWidget {
  const _TransactionsWorkspace();

  String _formatGroupDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    final weekdays = {
      DateTime.monday: 'Segunda-feira',
      DateTime.tuesday: 'Terça-feira',
      DateTime.wednesday: 'Quarta-feira',
      DateTime.thursday: 'Quinta-feira',
      DateTime.friday: 'Sexta-feira',
      DateTime.saturday: 'Sábado',
      DateTime.sunday: 'Domingo',
    };

    final weekdayStr = weekdays[date.weekday] ?? '';
    return '$day/$month/$year, $weekdayStr';
  }

  String _categoryPath(CategoriaDetails cat) {
    if (cat.categoriaPai != null) {
      return '${_categoryPath(cat.categoriaPai!)} > ${cat.descricao}';
    }
    return cat.descricao;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(lancamentosListViewModelProvider);

    return Container(
      color: AppColors.background,
      child: ListenableBuilder(
        listenable: viewModel.loadCommand,
        builder: (context, _) {
          final state = viewModel.loadCommand.value;
          final list = viewModel.lancamentos;

          if (state.isRunning && list.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Text(
                'Erro ao carregar lançamentos: ${state.getExceptionOrNull()}',
                style: const TextStyle(color: AppColors.danger),
              ),
            );
          }

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum lançamento encontrado.',
                style: TextStyle(color: AppColors.slate500),
              ),
            );
          }

          final sortedList = List<LancamentoDetails>.from(list)
            ..sort((a, b) => b.data.compareTo(a.data));

          final Map<String, List<LancamentoDetails>> grouped = {};
          for (final item in sortedList) {
            final dateKey = _formatGroupDate(item.data);
            grouped.putIfAbsent(dateKey, () => []).add(item);
          }

          final keys = grouped.keys.toList();

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: keys.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, groupIndex) {
              final dateKey = keys[groupIndex];
              final items = grouped[dateKey]!;

              double dailySum = 0;
              for (final l in items) {
                if (l.tipo == LancamentoTipo.receita) {
                  dailySum += l.valor;
                } else {
                  dailySum -= l.valor;
                }
              }

              final isPositive = dailySum >= 0;
              final prefix = isPositive ? '+' : '-';
              final balanceStr = UtilBrasilFields.obterReal(
                dailySum.abs(),
                moeda: true,
              ).replaceFirst('R\$', '$prefix R\$');

              return _TransactionDayCard(
                date: dateKey,
                balance: balanceStr,
                positive: isPositive,
                rows: items.map((l) {
                  final kind = l.tipo == LancamentoTipo.receita
                      ? TransactionKind.income
                      : (l.tipo == LancamentoTipo.transferencia
                          ? TransactionKind.transfer
                          : TransactionKind.expense);

                  final rowPrefix = l.tipo == LancamentoTipo.receita ? '+' : '-';
                  final formattedValue = UtilBrasilFields.obterReal(
                    l.valor,
                    moeda: true,
                  ).replaceFirst('R\$', '$rowPrefix R\$');

                  const String? badge = null;

                  final costCenter = l.itens.isEmpty
                      ? 'CC: Geral'
                      : 'CC: ${l.itens.map((i) => i.centroCusto.descricao).join(', ')}';

                  final categoryPath = l.itens.isNotEmpty
                      ? _categoryPath(l.itens.first.categoria)
                      : 'Sem categoria';

                  return TransactionRow(
                    description: l.descricao,
                    category: categoryPath,
                    account: switch (l.origem) {
                      LancamentoOrigemContaDetail(conta: final c) =>
                        c.descricao,
                      LancamentoOrigemCartaoDetail(cartao: final c) =>
                        c.descricao,
                    },
                    value: formattedValue,
                    kind: kind,
                    status: l.conciliado ? 'Ativo' : 'Pendente',
                    costCenter: costCenter,
                    badge: badge,
                  );
                }).toList(),
              );
            },
          );
        },
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
