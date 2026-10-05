import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';

class ItemCompraDto {
  String? id;
  String produto;
  double quantidadePlanejada;
  double precoEstimado;
  List<SupermercadoItem> supermercados;
  ItemCompraSituacao situacao;
  String observacao;
  List<RegistroCompra> historicoCompras;
  double _quantidadeCompradaLegada;

  ItemCompraDto({
    this.id,
    this.produto = '',
    this.quantidadePlanejada = 1.0,
    double quantidadeComprada = 0.0,
    this.precoEstimado = 0.0,
    List<SupermercadoItem>? supermercados,
    this.situacao = ItemCompraSituacao.pendente,
    this.observacao = '',
    List<RegistroCompra>? historicoCompras,
  }) : _quantidadeCompradaLegada = quantidadeComprada,
       historicoCompras = historicoCompras ?? [],
       supermercados = supermercados ?? [];

  double get quantidadeComprada {
    if (historicoCompras.isEmpty) return _quantidadeCompradaLegada;
    return historicoCompras.fold(0.0, (sum, item) => sum + item.quantidade);
  }

  void setProduto(String val) => produto = val;
  void setQuantidadePlanejada(double val) => quantidadePlanejada = val;
  void setQuantidadeComprada(double val) {
    _quantidadeCompradaLegada = val;
  }

  void setPrecoEstimado(double val) => precoEstimado = val;
  void setSupermercados(List<SupermercadoItem> val) => supermercados = val;
  void setSituacao(ItemCompraSituacao val) => situacao = val;
  void setObservacao(String val) => observacao = val;
  void setHistoricoCompras(List<RegistroCompra> val) => historicoCompras = val;
}
