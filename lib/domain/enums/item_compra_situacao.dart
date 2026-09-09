enum ItemCompraSituacao {
  pendente('Pendente'),
  comprado('Comprado'),
  cancelado('Cancelado');

  const ItemCompraSituacao(this.descricao);

  final String descricao;
}
