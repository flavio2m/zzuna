import 'package:zzuna/domain/dtos/conta/conta_dto.dart';

class LoadedContaDto implements ContaDto {
  String id;

  @override
  String descricao;

  @override
  String bancoSigla;

  bool ativo;

  LoadedContaDto({this.id = '', this.descricao = '', this.bancoSigla = '', this.ativo = true});

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

  Map<String, dynamic> toJson() => {
    'id': id, 'descricao': descricao, 'bancoSigla': bancoSigla, 'ativo': ativo, //
  };

  factory LoadedContaDto.fromJson(Map<String, dynamic> json) {
    return LoadedContaDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      bancoSigla: json['bancoSigla'] ?? '',
      ativo: json['ativo'] ?? true,
    );
  }
}
