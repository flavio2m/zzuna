import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class LancamentoDto {
  String? id;

  LancamentoTipo tipo;
  DateTime data;
  String descricao;
  LancamentoOrigem origem;
  String extratoFaturaId;
  List<LancamentoItem> itens;
  bool conciliado;
  String? observacao;

  LancamentoDto({
    this.id,
    this.tipo = LancamentoTipo.despesa,
    DateTime? data,
    this.descricao = '',
    LancamentoOrigem? origem,
    this.extratoFaturaId = '',
    this.itens = const [],
    this.conciliado = false,
    this.observacao,
  }) : data = data ?? DateTime.now(),
       origem = origem ?? const LancamentoOrigem.conta(contaId: '');

  void setId(String? id) {
    this.id = id;
  }

  void setTipo(LancamentoTipo tipo) {
    this.tipo = tipo;
  }

  void setData(DateTime data) {
    this.data = data;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setOrigem(LancamentoOrigem origem) {
    this.origem = origem;
  }

  void setExtratoFaturaId(String extratoFaturaId) {
    this.extratoFaturaId = extratoFaturaId;
  }

  void setItens(List<LancamentoItem> itens) {
    this.itens = itens;
  }

  void addItem(LancamentoItem item) {
    itens = [...itens, item];
  }

  void removeItem(LancamentoItem item) {
    itens = itens.where((e) => e != item).toList();
  }

  void setConciliado(bool conciliado) {
    this.conciliado = conciliado;
  }

  void setObservacao(String? observacao) {
    this.observacao = observacao;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipo': tipo.name,
    'data': data.toIso8601String(),
    'descricao': descricao,
    'origem': origem.toJson(),
    'extratoFaturaId': extratoFaturaId,
    'itens': itens.map((e) => e.toJson()).toList(),
    'conciliado': conciliado,
    'observacao': observacao,
  };

  factory LancamentoDto.fromJson(Map<String, dynamic> json) {
    return LancamentoDto(
      id: json['id'],
      tipo: LancamentoTipo.values.firstWhere((e) => e.name == json['tipo']),
      data: DateTime.parse(json['data']),
      descricao: json['descricao'] ?? '',
      origem: LancamentoOrigem.fromJson(
        Map<String, dynamic>.from(json['origem']), //
      ),
      extratoFaturaId: json['extratoFaturaId'] ?? '',
      itens: (json['itens'] as List<dynamic>? ?? [])
          .map((e) => LancamentoItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      conciliado: json['conciliado'] ?? false,
      observacao: json['observacao'],
    );
  }
}
