class ContaDto {
  String? id;

  String descricao;
  double saldoInicial;
  String bancoSigla;
  bool ativo;

  ContaDto({
    this.id,
    this.descricao = '',
    this.saldoInicial = 0,
    this.bancoSigla = '',
    this.ativo = true, //
  });

  void setId(String? id) {
    this.id = id;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setSaldoInicial(double saldoInicial) {
    this.saldoInicial = saldoInicial;
  }

  void setBancoSigla(String bancoSigla) {
    this.bancoSigla = bancoSigla;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'saldoInicial': saldoInicial,
    'bancoSigla': bancoSigla,
    'ativo': ativo,
  };

  factory ContaDto.fromJson(Map<String, dynamic> json) {
    return ContaDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      saldoInicial: (json['saldoInicial'] ?? 0).toDouble(),
      bancoSigla: json['bancoSigla'] ?? '',
      ativo: json['ativo'] ?? true,
    );
  }
}
