class ContaFilterDto {
  String descricao;
  String? bancoSigla;
  bool? ativo;

  ContaFilterDto({this.descricao = '', this.bancoSigla, this.ativo});

  void setDescricao(String value) {
    descricao = value;
  }

  void setBancoSigla(String? value) {
    bancoSigla = value;
  }

  void setAtivo(bool? value) {
    ativo = value;
  }
}
