import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/lancamento_modo.dart';
import 'package:zzuna/domain/enums/mes.dart';

class LancamentoFilterState {
  final String descricao;
  final Mes mes;
  final int ano;
  final LancamentoTipo? tipo;
  final LancamentoModo? modo;
  final bool? conciliado;
  final bool incluirSaldoInicial;
  final Set<String> contasSelecionadas;
  final Set<String> cartoesSelecionados;
  final Set<String> centrosSelecionados;
  final Set<String> categoriasSelecionadas;

  const LancamentoFilterState({
    this.descricao = '',
    required this.mes,
    required this.ano,
    this.tipo,
    this.modo,
    this.conciliado,
    this.incluirSaldoInicial = true,
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
    LancamentoModo? modo,
    bool? conciliado,
    bool? incluirSaldoInicial,
    bool clearTipo = false,
    bool clearModo = false,
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
      modo: clearModo ? null : (modo ?? this.modo),
      conciliado: clearConciliado ? null : (conciliado ?? this.conciliado),
      incluirSaldoInicial: incluirSaldoInicial ?? this.incluirSaldoInicial,
      contasSelecionadas: contasSelecionadas ?? this.contasSelecionadas,
      cartoesSelecionados: cartoesSelecionados ?? this.cartoesSelecionados,
      centrosSelecionados: centrosSelecionados ?? this.centrosSelecionados,
      categoriasSelecionadas:
          categoriasSelecionadas ?? this.categoriasSelecionadas,
    );
  }
}
