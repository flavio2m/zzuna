import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import '../../models/lancamento_resumo_dia.dart';
import '../../models/lancamento_resumo_mensal.dart';

class LancamentoResumoMensalUseCase {
  LancamentoResumoMensal execute(
    List<LancamentoDetails> lancamentos, {
    required List<ExtratoFatura> extratos,
    required Set<String> contasSelecionadas,
    required Set<String> cartoesSelecionados,
    required bool temFiltroRestritivo,
    required Mes mes,
    required int ano,
  }) {
    final totals = _calcularTotais(lancamentos);
    final dias = _agruparPorDia(lancamentos);

    double saldoInicial = 0;
    double saldoFinal = 0;

    final exibirResumoFinanceiro = !temFiltroRestritivo;

    if (exibirResumoFinanceiro) {
      final considerados = extratos.where((ef) {
        if (contasSelecionadas.isEmpty && cartoesSelecionados.isEmpty) {
          return true;
        }
        final origem = ef.origem;
        if (origem is LancamentoOrigemConta) {
          return contasSelecionadas.contains(origem.contaId);
        } else if (origem is LancamentoOrigemCartao) {
          return cartoesSelecionados.contains(origem.cartaoId);
        }
        return false;
      });

      for (final ef in considerados) {
        saldoInicial += ef.saldoInicial;
        saldoFinal += ef.saldoFinal;
      }
    }

    return LancamentoResumoMensal(
      mes: mes,
      ano: ano,
      saldoInicial: saldoInicial,
      saldoFinal: saldoFinal,
      receitas: totals.receitas,
      despesas: totals.despesas,
      transferencias: totals.transferencias,
      investimentos: totals.investimentos,
      exibirResumoFinanceiro: exibirResumoFinanceiro,
      dias: dias,
    );
  }

  _Totais _calcularTotais(List<LancamentoDetails> lancamentos) {
    double receitas = 0;
    double despesas = 0;
    double transferencias = 0;
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
          transferencias += l.valor;
          break;
      }
    }

    return _Totais(
      receitas: receitas,
      despesas: despesas,
      transferencias: transferencias,
      investimentos: investimentos,
    );
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
  final double transferencias;
  final double investimentos;

  const _Totais({
    required this.receitas,
    required this.despesas,
    required this.transferencias,
    required this.investimentos,
  });
}
