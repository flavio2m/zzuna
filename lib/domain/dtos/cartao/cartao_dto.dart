class CartaoDto {
  String? id;

  String descricao;
  double limite;
  String bancoSigla;
  bool ativo;
  int diaFechamento;

  CartaoDto({
    this.id,
    this.descricao = '',
    this.limite = 0,
    this.bancoSigla = '',
    this.ativo = true,
    this.diaFechamento = 1,
  });

  void setId(String? id) {
    this.id = id;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setLimite(double limite) {
    this.limite = limite;
  }

  void setBancoSigla(String bancoSigla) {
    this.bancoSigla = bancoSigla;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  void setDiaFechamento(int diaFechamento) {
    this.diaFechamento = diaFechamento;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'limite': limite,
    'bancoSigla': bancoSigla,
    'ativo': ativo,
    'diaFechamento': diaFechamento,
  };

  factory CartaoDto.fromJson(Map<String, dynamic> json) {
    return CartaoDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      limite: (json['limite'] ?? 0).toDouble(),
      bancoSigla: json['bancoSigla'] ?? '',
      ativo: json['ativo'] ?? true,
      diaFechamento: json['diaFechamento'] ?? 1,
    );
  }
}
