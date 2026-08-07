enum LancamentoModo {
  parcelado('Parcelado'),
  replicado('Replicado'),
  recorrencia('Recorrência'),
  simples('Simples');

  const LancamentoModo(this.descricao);
  final String descricao;
}
