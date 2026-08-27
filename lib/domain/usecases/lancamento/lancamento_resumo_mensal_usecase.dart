import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
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
    bool incluirSaldoInicial = true,
    Set<String> lancamentosDesconsiderados = const {},
    Set<String> categoriasSelecionadas = const {},
    Set<String> centrosSelecionados = const {},
  }) {
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

      final currentPeriodo = ano * 100 + mes.numero;

      for (final ef in considerados) {
        if (ef.periodo == currentPeriodo) {
          saldoInicial += ef.saldoInicial;
          saldoFinal += ef.saldoFinal;
        } else if (ef.periodo < currentPeriodo) {
          saldoInicial += ef.saldoFinal;
          saldoFinal += ef.saldoFinal;
        }
      }
    }

    final totals = _calcularTotais(
      lancamentos,
      lancamentosDesconsiderados,
      categoriasSelecionadas,
      centrosSelecionados,
    );

    final saldoInicialReal = saldoInicial;
    final saldoFinalReal = saldoFinal;

    final saldoInicialExibicao = incluirSaldoInicial ? saldoInicialReal : 0.0;
    final saldoFinalExibicao = lancamentosDesconsiderados.isEmpty
        ? (incluirSaldoInicial
              ? saldoFinalReal
              : (saldoFinalReal - saldoInicialReal))
        : (saldoInicialExibicao +
              totals.receitas -
              totals.despesas +
              totals.netTransferencias);

    final dias = _agruparPorDia(
      lancamentos,
      saldoInicialExibicao,
      lancamentosDesconsiderados,
      categoriasSelecionadas,
      centrosSelecionados,
    );

    return LancamentoResumoMensal(
      mes: mes,
      ano: ano,
      saldoInicial: saldoInicialExibicao,
      saldoFinal: saldoFinalExibicao,
      saldoInicialReal: saldoInicialReal,
      saldoFinalReal: saldoFinalReal,
      incluirSaldoInicial: incluirSaldoInicial,
      receitas: totals.receitas,
      despesas: totals.despesas,
      transferencias: totals.transferencias,
      exibirResumoFinanceiro: exibirResumoFinanceiro,
      dias: dias,
    );
  }

  double _calcValorCalculado(
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

  _Totais _calcularTotais(
    List<LancamentoDetails> lancamentos,
    Set<String> lancamentosDesconsiderados,
    Set<String> categoriasSelecionadas,
    Set<String> centrosSelecionados,
  ) {
    double receitas = 0;
    double despesas = 0;
    double transferencias = 0;
    double netTransferencias = 0;

    for (final l in lancamentos) {
      if (lancamentosDesconsiderados.contains(l.id)) {
        continue;
      }

      final itemVal = _calcValorCalculado(
        l,
        categoriasSelecionadas,
        centrosSelecionados,
      );

      switch (l.tipo) {
        case LancamentoTipo.receita:
          receitas += itemVal;
          break;
        case LancamentoTipo.despesa:
          despesas += itemVal;
          break;
        case LancamentoTipo.transferencia:
          transferencias += itemVal;
          final firstItem = l.itens.isNotEmpty ? l.itens.first : null;
          if (firstItem is LancamentoItemDetailsTransferencia) {
            final currentOrigem = l.origem.map(
              conta: (c) => LancamentoOrigem.conta(contaId: c.conta.id),
              cartao: (c) => LancamentoOrigem.cartao(cartaoId: c.cartao.id),
            );
            final entryOrigem = firstItem.origemEntrada.map(
              conta: (c) => LancamentoOrigem.conta(contaId: c.conta.id),
              cartao: (c) => LancamentoOrigem.cartao(cartaoId: c.cartao.id),
            );
            final exitOrigem = firstItem.origemSaida.map(
              conta: (c) => LancamentoOrigem.conta(contaId: c.conta.id),
              cartao: (c) => LancamentoOrigem.cartao(cartaoId: c.cartao.id),
            );
            if (currentOrigem == entryOrigem) {
              netTransferencias += itemVal;
            } else if (currentOrigem == exitOrigem) {
              netTransferencias -= itemVal;
            }
          }
          break;
      }
    }

    return _Totais(
      receitas: receitas,
      despesas: despesas,
      transferencias: transferencias,
      netTransferencias: netTransferencias,
    );
  }

  List<LancamentoResumoDia> _agruparPorDia(
    List<LancamentoDetails> lancamentos,
    double saldoInicialExtrato,
    Set<String> lancamentosDesconsiderados,
    Set<String> categoriasSelecionadas,
    Set<String> centrosSelecionados,
  ) {
    final Map<DateTime, List<LancamentoDetails>> grouped = {};
    for (final l in lancamentos) {
      final dateKey = DateTime(l.data.year, l.data.month, l.data.day);
      grouped.putIfAbsent(dateKey, () => []).add(l);
    }

    final sortedKeysAsc = grouped.keys.toList()..sort((a, b) => a.compareTo(b));

    final List<LancamentoResumoDia> resumosCronologicos = [];
    double saldoExtratoAcumulado = saldoInicialExtrato;

    for (final date in sortedKeysAsc) {
      final items = grouped[date]!;
      items.sort((a, b) => b.data.compareTo(a.data));

      double saldoDia = 0;
      for (final l in items) {
        if (lancamentosDesconsiderados.contains(l.id)) {
          continue;
        }

        final itemVal = _calcValorCalculado(
          l,
          categoriasSelecionadas,
          centrosSelecionados,
        );

        if (l.tipo == LancamentoTipo.receita) {
          saldoDia += itemVal;
        } else if (l.tipo == LancamentoTipo.despesa) {
          saldoDia -= itemVal;
        } else if (l.tipo == LancamentoTipo.transferencia) {
          final currentOrigem = l.origem.map(
            conta: (c) => LancamentoOrigem.conta(contaId: c.conta.id),
            cartao: (c) => LancamentoOrigem.cartao(cartaoId: c.cartao.id),
          );
          for (final item in l.itens) {
            switch (item) {
              case LancamentoItemDetailsTransferencia(
                :final origemEntrada,
                :final origemSaida,
              ):
                final entryOrigem = origemEntrada.map(
                  conta: (c) => LancamentoOrigem.conta(contaId: c.conta.id),
                  cartao: (c) => LancamentoOrigem.cartao(cartaoId: c.cartao.id),
                );
                final exitOrigem = origemSaida.map(
                  conta: (c) => LancamentoOrigem.conta(contaId: c.conta.id),
                  cartao: (c) => LancamentoOrigem.cartao(cartaoId: c.cartao.id),
                );
                if (currentOrigem == entryOrigem) {
                  saldoDia += item.valor;
                } else if (currentOrigem == exitOrigem) {
                  saldoDia -= item.valor;
                }
              default:
                break;
            }
          }
        }
      }

      saldoExtratoAcumulado += saldoDia;

      resumosCronologicos.add(
        LancamentoResumoDia(
          data: date,
          saldo: saldoDia,
          saldoExtrato: saldoExtratoAcumulado,
          lancamentos: items,
        ),
      );
    }

    return resumosCronologicos.reversed.toList();
  }
}

class _Totais {
  final double receitas;
  final double despesas;
  final double transferencias;
  final double netTransferencias;

  _Totais({
    required this.receitas,
    required this.despesas,
    required this.transferencias,
    required this.netTransferencias,
  });
}
