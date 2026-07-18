import 'package:zzuna/domain/enums/cartao_comportamento_fechamento.dart';

class CartaoDto {
  String? id;

  String descricao;
  double limite;
  String bancoSigla;
  bool ativo;
  int diaFechamento;
  DateTime? dataInicial;
  CartaoComportamentoFechamento comportamentoFechamento;

  CartaoDto({
    this.id,
    this.descricao = '',
    this.limite = 0,
    this.bancoSigla = '',
    this.ativo = true,
    this.diaFechamento = 5,
    this.comportamentoFechamento =
        CartaoComportamentoFechamento.migrarAnteriores,
    DateTime? dataInicial,
  }) : dataInicial =
           dataInicial ??
           DateTime(DateTime.now().year, DateTime.now().month, 1);

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

  void setDataInicial(DateTime dataInicial) {
    this.dataInicial = dataInicial;
  }

  void setComportamentoFechamento(
    CartaoComportamentoFechamento comportamentoFechamento,
  ) {
    this.comportamentoFechamento = comportamentoFechamento;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'limite': limite,
    'bancoSigla': bancoSigla,
    'ativo': ativo,
    'diaFechamento': diaFechamento,
    'dataInicial': dataInicial?.toIso8601String(),
    'comportamentoFechamento': comportamentoFechamento.name,
  };

  factory CartaoDto.fromJson(Map<String, dynamic> json) {
    return CartaoDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      limite: (json['limite'] ?? 0).toDouble(),
      bancoSigla: json['bancoSigla'] ?? '',
      ativo: json['ativo'] ?? true,
      diaFechamento: json['diaFechamento'] ?? 5,
      dataInicial: json['dataInicial'] != null
          ? DateTime.parse(json['dataInicial'])
          : null,
      comportamentoFechamento: CartaoComportamentoFechamento.values.firstWhere(
        (e) => e.name == json['comportamentoFechamento'],
        orElse: () => CartaoComportamentoFechamento.migrarAnteriores,
      ),
    );
  }
}
