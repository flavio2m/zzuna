import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

class LancamentoFilterDto {
  String descricao;
  LancamentoTipo? tipo;
  bool? conciliado;

  LancamentoFilterDto({this.descricao = '', this.tipo, this.conciliado});
}
