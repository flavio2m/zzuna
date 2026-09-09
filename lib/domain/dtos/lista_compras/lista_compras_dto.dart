import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';

class ListaComprasDto {
  String? id;
  int ano;
  Mes mes;
  List<ItemCompra> itens;

  ListaComprasDto({
    this.id,
    required this.ano,
    required this.mes,
    List<ItemCompra>? itens,
  }) : itens = itens ?? [];

  int get periodo => ano * 100 + mes.numero;

  void setAno(int val) => ano = val;
  void setMes(Mes val) => mes = val;
  void setItens(List<ItemCompra> val) => itens = val;
}
