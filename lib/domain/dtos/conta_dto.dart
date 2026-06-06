class ContaDto {
  String? id;

  String descricao;
  String bancoSigla;
  bool ativo;

  ContaDto({
    this.id,
    this.descricao = '',
    this.bancoSigla = '',
    this.ativo = true, //
  });

  void setId(String? id) {
    this.id = id;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setBancoSigla(String bancoSigla) {
    this.bancoSigla = bancoSigla;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'descricao': descricao, 'bancoSigla': bancoSigla, 'ativo': ativo, //
  };

  factory ContaDto.fromJson(Map<String, dynamic> json) {
    return ContaDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      bancoSigla: json['bancoSigla'] ?? '',
      ativo: json['ativo'] ?? true,
    );
  }
}
