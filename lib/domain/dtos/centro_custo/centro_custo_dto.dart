class CentroCustoDto {
  String? id;
  String descricao;
  bool ativo;

  CentroCustoDto({this.id, this.descricao = '', this.ativo = true});

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'descricao': descricao, 'ativo': ativo, //
  };

  factory CentroCustoDto.fromJson(Map<String, dynamic> json) => CentroCustoDto(
    id: json['id'],
    descricao: json['descricao'] ?? '',
    ativo: json['ativo'] ?? true, //
  );
}
