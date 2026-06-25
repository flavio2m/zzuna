enum LancamentoTipo {
  receita('Receita'),
  despesa('Despesa'),
  transferencia('Transferência'),
  investimento('Investimento');

  const LancamentoTipo(this.descricao);
  final String descricao;
}
