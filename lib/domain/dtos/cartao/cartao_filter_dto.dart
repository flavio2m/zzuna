class CartaoFilterDto {
  String descricao;
  String? bancoSigla;
  bool? ativo;

  CartaoFilterDto({this.descricao = '', this.bancoSigla, this.ativo});
}
