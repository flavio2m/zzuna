import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import '../../models/lancamento_resumo_dia.dart';
import '../../models/lancamento_resumo_mensal.dart';

class LancamentoResumoMensalUseCase {
  LancamentoResumoMensal execute(List<LancamentoDetails> lancamentos) {
    final mes = lancamentos.isNotEmpty ? Mes.fromDate(lancamentos.first.data) : Mes.fromDate(DateTime.now());
    final ano = lancamentos.isNotEmpty ? lancamentos.first.data.year : DateTime.now().year;

    final totals = _calcularTotais(lancamentos);
    final dias = _agruparPorDia(lancamentos);

    return LancamentoResumoMensal(
      mes: mes,
      ano: ano,
      receitas: totals.receitas,
      despesas: totals.despesas,
      investimentos: totals.investimentos,
      dias: dias,
    );
  }

  _Totais _calcularTotais(List<LancamentoDetails> lancamentos) {
    double receitas = 0;
    double despesas = 0;
    double investimentos = 0;

    for (final l in lancamentos) {
      switch (l.tipo) {
        case LancamentoTipo.receita:
          receitas += l.valor;
          break;
        case LancamentoTipo.despesa:
          despesas += l.valor;
          break;
        case LancamentoTipo.investimento:
          investimentos += l.valor;
          break;
        case LancamentoTipo.transferencia:
          // Transferências não entram nas somas de receitas, despesas ou investimentos do mês
          break;
      }
    }

    return _Totais(receitas: receitas, despesas: despesas, investimentos: investimentos);
  }

  List<LancamentoResumoDia> _agruparPorDia(List<LancamentoDetails> lancamentos) {
    final sorted = List<LancamentoDetails>.from(lancamentos)..sort((a, b) => b.data.compareTo(a.data));

    final Map<DateTime, List<LancamentoDetails>> grouped = {};
    for (final l in sorted) {
      final dateKey = DateTime(l.data.year, l.data.month, l.data.day);
      grouped.putIfAbsent(dateKey, () => []).add(l);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedKeys.map((date) {
      final items = grouped[date]!;
      double saldo = 0;

      for (final l in items) {
        if (l.tipo == LancamentoTipo.receita) {
          saldo += l.valor;
        } else {
          saldo -= l.valor;
        }
      }

      return LancamentoResumoDia(data: date, saldo: saldo, lancamentos: items);
    }).toList();
  }
}

class _Totais {
  final double receitas;
  final double despesas;
  final double investimentos;

  const _Totais({required this.receitas, required this.despesas, required this.investimentos});
}
