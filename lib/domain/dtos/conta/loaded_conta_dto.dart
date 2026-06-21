import 'package:zzuna/domain/dtos/conta/conta_dto.dart';

class LoadedContaDto implements ContaDto {
  String id;

  @override
  String descricao;

  @override
  String bancoSigla;

  bool ativo;

  @override
  DateTime dataInicial;

  LoadedContaDto({
    this.id = '',
    this.descricao = '',
    this.bancoSigla = '',
    this.ativo = true,
    DateTime? dataInicial,
  }) : dataInicial = dataInicial ?? DateTime(DateTime.now().year, DateTime.now().month, 1);

  void setId(String id) {
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

  void setDataInicial(DateTime dataInicial) {
    this.dataInicial = dataInicial;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'bancoSigla': bancoSigla,
    'ativo': ativo,
    'dataInicial': dataInicial.toIso8601String(),
  };

  factory LoadedContaDto.fromJson(Map<String, dynamic> json) {
    return LoadedContaDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      bancoSigla: json['bancoSigla'] ?? '',
      ativo: json['ativo'] ?? true,
      dataInicial: json['dataInicial'] != null ? DateTime.parse(json['dataInicial']) : null,
    );
  }
}
