import 'package:zzuna/domain/enums/categoria_natureza.dart';

class CategoriaDto {
  String? id;

  String descricao;
  String? categoriaPaiId;
  bool ativo;
  double? percentualOrcamento;
  CategoriaNatureza natureza;
  String? cor;

  CategoriaDto({
    this.id,
    this.descricao = '',
    this.categoriaPaiId,
    this.ativo = true,
    this.percentualOrcamento,
    this.natureza = CategoriaNatureza.saida,
    this.cor,
  });

  void setId(String? id) {
    this.id = id;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setCategoriaPaiId(String? categoriaPaiId) {
    this.categoriaPaiId = categoriaPaiId;
  }

  void setAtivo(bool ativo) {
    this.ativo = ativo;
  }

  void setPercentualOrcamento(double? percentualOrcamento) {
    this.percentualOrcamento = percentualOrcamento;
  }

  void setNatureza(CategoriaNatureza natureza) {
    this.natureza = natureza;
  }

  void setCor(String? cor) {
    this.cor = cor;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'categoriaPaiId': categoriaPaiId,
    'ativo': ativo,
    'percentualOrcamento': percentualOrcamento,
    'natureza': natureza.name,
    'cor': cor,
  };

  factory CategoriaDto.fromJson(Map<String, dynamic> json) {
    return CategoriaDto(
      id: json['id'],
      descricao: json['descricao'] ?? '',
      categoriaPaiId: json['categoriaPaiId'],
      ativo: json['ativo'] ?? true,
      percentualOrcamento: (json['percentualOrcamento'] as num?)?.toDouble(),
      natureza: json['natureza'] != null
          ? CategoriaNatureza.values.firstWhere(
              (e) => e.name == json['natureza'],
              orElse: () => CategoriaNatureza.saida,
            )
          : CategoriaNatureza.saida,
      cor: json['cor'] as String?,
    );
  }
}
