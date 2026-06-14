class CategoriaDto {
  String? id;

  String descricao;
  String? categoriaPaiId;
  bool ativo;

  CategoriaDto({
    this.id,
    this.descricao = '',
    this.categoriaPaiId,
    this.ativo = true,
  });

  void setId(String? id) {
    this.id = id;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setCategoriaPaiId(String? categoriaPaiId) {
    this.categoriaPaiId = categoriaPaiId;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'categoriaPaiId': categoriaPaiId,
        'ativo': ativo,
      };

  factory CategoriaDto.fromJson(Map<String, dynamic> json) {
    return CategoriaDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      categoriaPaiId: json['categoriaPaiId'],
      ativo: json['ativo'] ?? true,
    );
  }
}
