import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';

class ItemCompraDto {
  String? id;
  String produto;
  double quantidadePlanejada;
  double quantidadeComprada;
  double precoEstimado;
  List<SupermercadoItem> supermercados;
  ItemCompraSituacao situacao;

  ItemCompraDto({
    this.id,
    this.produto = '',
    this.quantidadePlanejada = 1.0,
    this.quantidadeComprada = 0.0,
    this.precoEstimado = 0.0,
    List<SupermercadoItem>? supermercados,
    this.situacao = ItemCompraSituacao.pendente,
  }) : supermercados = supermercados ?? [];

  void setProduto(String val) => produto = val;
  void setQuantidadePlanejada(double val) => quantidadePlanejada = val;
  void setQuantidadeComprada(double val) => quantidadeComprada = val;
  void setPrecoEstimado(double val) => precoEstimado = val;
  void setSupermercados(List<SupermercadoItem> val) => supermercados = val;
  void setSituacao(ItemCompraSituacao val) => situacao = val;
}
