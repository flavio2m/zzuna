import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

class LancamentoFilterState {
  final String descricao;
  final Mes mes;
  final int ano;
  final LancamentoTipo? tipo;
  final bool? conciliado;
  final Set<String> contasSelecionadas;
  final Set<String> cartoesSelecionados;
  final Set<String> centrosSelecionados;
  final Set<String> categoriasSelecionadas;

  const LancamentoFilterState({
    this.descricao = '',
    required this.mes,
    required this.ano,
    this.tipo,
    this.conciliado,
    this.contasSelecionadas = const {},
    this.cartoesSelecionados = const {},
    this.centrosSelecionados = const {},
    this.categoriasSelecionadas = const {},
  });

  LancamentoFilterState copyWith({
    String? descricao,
    Mes? mes,
    int? ano,
    LancamentoTipo? tipo,
    bool? conciliado,
    bool clearTipo = false,
    bool clearConciliado = false,
    Set<String>? contasSelecionadas,
    Set<String>? cartoesSelecionados,
    Set<String>? centrosSelecionados,
    Set<String>? categoriasSelecionadas,
  }) {
    return LancamentoFilterState(
      descricao: descricao ?? this.descricao,
      mes: mes ?? this.mes,
      ano: ano ?? this.ano,
      tipo: clearTipo ? null : (tipo ?? this.tipo),
      conciliado: clearConciliado ? null : (conciliado ?? this.conciliado),
      contasSelecionadas: contasSelecionadas ?? this.contasSelecionadas,
      cartoesSelecionados: cartoesSelecionados ?? this.cartoesSelecionados,
      centrosSelecionados: centrosSelecionados ?? this.centrosSelecionados,
      categoriasSelecionadas: categoriasSelecionadas ?? this.categoriasSelecionadas,
    );
  }
}
