enum LancamentoTipo {
  receita('Receita'),
  despesa('Despesa'),
  transferencia('Transferência');

  const LancamentoTipo(this.descricao);
  final String descricao;
}
