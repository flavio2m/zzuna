import 'package:zzuna/domain/dtos/conta/conta_dto.dart';

class CreateContaDto implements ContaDto {
  String? id;

  @override
  String descricao;

  @override
  String bancoSigla;

  bool ativo;

  @override
  DateTime? dataInicial;

  CreateContaDto({
    this.id,
    this.descricao = '',
    this.bancoSigla = '',
    this.ativo = true,
    DateTime? dataInicial,
  }) : dataInicial = dataInicial ?? DateTime(DateTime.now().year, DateTime.now().month, 1);

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setBancoSigla(String bancoSigla) {
    this.bancoSigla = bancoSigla;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  void setDataInicial(DateTime dataInicial) {
    this.dataInicial = dataInicial;
  }

  Map<String, dynamic> toJson() => {
    'descricao': descricao,
    'bancoSigla': bancoSigla,
    'ativo': ativo,
    'dataInicial': dataInicial?.toIso8601String(),
  };

  factory CreateContaDto.fromJson(Map<String, dynamic> json) {
    return CreateContaDto(
      descricao: json['descricao'] ?? '',
      bancoSigla: json['bancoSigla'] ?? '',
      dataInicial: json['dataInicial'] != null ? DateTime.parse(json['dataInicial']) : null,
    )..ativo = json['ativo'] ?? true;
  }
}
