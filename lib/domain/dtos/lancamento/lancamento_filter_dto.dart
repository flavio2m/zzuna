import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/lancamento_modo.dart';
import 'package:zzuna/domain/enums/mes.dart';

class LancamentoFilterDto {
  final String descricao;
  final LancamentoTipo? tipo;
  final LancamentoModo? modo;
  final bool? conciliado;
  final Mes? mes;
  final int? ano;
  final Set<String> contasSelecionadas;
  final Set<String> cartoesSelecionados;
  final Set<String> centrosSelecionados;
  final Set<String> categoriasSelecionadas;

  const LancamentoFilterDto({
    this.descricao = '',
    this.tipo,
    this.modo,
    this.conciliado,
    this.mes,
    this.ano,
    this.contasSelecionadas = const {},
    this.cartoesSelecionados = const {},
    this.centrosSelecionados = const {},
    this.categoriasSelecionadas = const {},
  });
}
