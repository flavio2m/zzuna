class CreateContaDto {
  String? id; // Pode ter um ID, necessário para gerar o ID no repositório

  String descricao;
  String bancoSigla;
  bool ativo = true; //

  CreateContaDto({this.id, this.descricao = '', this.bancoSigla = ''});

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
    'descricao': descricao, 'bancoSigla': bancoSigla, 'ativo': ativo, //
  };

  factory CreateContaDto.fromJson(Map<String, dynamic> json) {
    return CreateContaDto(
      descricao: json['descricao'] ?? '',
      bancoSigla: json['bancoSigla'] ?? '', //
    )..ativo = json['ativo'] ?? true;
  }
}
