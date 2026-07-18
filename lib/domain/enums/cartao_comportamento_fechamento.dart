enum CartaoComportamentoFechamento {
  migrarAnteriores,
  migrarPosteriores,
  manterNoMes;

  String get descricao {
    switch (this) {
      case CartaoComportamentoFechamento.migrarAnteriores:
        return 'Anteriores ao fechamento vão para o mês anterior';
      case CartaoComportamentoFechamento.migrarPosteriores:
        return 'A partir do fechamento vão para o mês seguinte';
      case CartaoComportamentoFechamento.manterNoMes:
        return 'Manter no mês do lançamento';
    }
  }
}
