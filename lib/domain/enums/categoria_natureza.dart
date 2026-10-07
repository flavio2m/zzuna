enum CategoriaNatureza {
  entrada('Entrada'),
  saida('Saída');

  const CategoriaNatureza(this.descricao);

  final String descricao;

  bool get isEntrada => this == CategoriaNatureza.entrada;
  bool get isSaida => this == CategoriaNatureza.saida;
}
