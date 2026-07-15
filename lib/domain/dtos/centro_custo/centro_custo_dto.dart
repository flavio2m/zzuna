class CentroCustoDto {
  String? id;
  String descricao;
  bool ativo;
  bool padrao;

  CentroCustoDto({
    this.id,
    this.descricao = '',
    this.ativo = true,
    this.padrao = false,
  });

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  void setPadrao(bool padrao) {
    this.padrao = padrao;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'ativo': ativo,
    'padrao': padrao,
  };

  factory CentroCustoDto.fromJson(Map<String, dynamic> json) => CentroCustoDto(
    id: json['id'],
    descricao: json['descricao'] ?? '',
    ativo: json['ativo'] ?? true,
    padrao: json['padrao'] ?? false,
  );
}
