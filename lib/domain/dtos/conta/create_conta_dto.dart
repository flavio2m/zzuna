import 'package:zzuna/domain/dtos/conta/conta_dto.dart';

class CreateContaDto implements ContaDto {
  String? id;

  @override
  String descricao;

  @override
  String bancoSigla;

  bool ativo;

  CreateContaDto({this.id, this.descricao = '', this.bancoSigla = '', this.ativo = true});

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
