import 'package:zzuna/domain/enums/mes.dart';
import 'lancamento_resumo_dia.dart';

class LancamentoResumoMensal {
  final Mes mes;
  final int ano;
  final double saldoInicial;
  final double saldoFinal;
  final double receitas;
  final double despesas;
  final double transferencias;
  final bool exibirResumoFinanceiro;
  final List<LancamentoResumoDia> dias;

  const LancamentoResumoMensal({
    required this.mes,
    required this.ano,
    required this.saldoInicial,
    required this.saldoFinal,
    required this.receitas,
    required this.despesas,
    required this.transferencias,
    required this.exibirResumoFinanceiro,
    required this.dias,
  });
}
