import 'package:zzuna/domain/enums/mes.dart';
import 'lancamento_resumo_dia.dart';

class LancamentoResumoMensal {
  final Mes mes;
  final int ano;
  final double receitas;
  final double despesas;
  final double investimentos;
  final List<LancamentoResumoDia> dias;

  const LancamentoResumoMensal({
    required this.mes,
    required this.ano,
    required this.receitas,
    required this.despesas,
    required this.investimentos,
    required this.dias,
  });
}
