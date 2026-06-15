class CategoriaFilterDto {
  String descricao;
  String? categoriaPaiId;
  bool? ativo;

  CategoriaFilterDto({this.descricao = '', this.categoriaPaiId, this.ativo});
}
