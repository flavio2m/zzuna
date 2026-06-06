enum BancoIcon {
  bancoDoBrasil,
  bancoDoNordeste,
  bradesco,
  c6,
  caixa,
  inter,
  itau,
  nubank,
  outros,
  santander,
  sicoob,
  sicredi,
}

class Banco {
  final String descricao;
  final String sigla;
  final BancoIcon icon;

  const Banco({required this.descricao, required this.sigla, required this.icon});
}
