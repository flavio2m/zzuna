import 'package:zzuna/domain/entities/categoria_entity.dart';

/// Detalhamento de gasto de uma subcategoria dentro do orçamento
class OrcamentoSubcategoriaDetalhe {
  final CategoriaDetails categoria;
  final double valor;
  final double percentualDaCategoria;

  const OrcamentoSubcategoriaDetalhe({
    required this.categoria,
    required this.valor,
    required this.percentualDaCategoria,
  });
}

/// Comparativo de Orçamento (Previsto vs Real) para uma categoria pai
class OrcamentoCategoriaComparativoModel {
  final Categoria categoria;
  final double percentualOrcamento;
  final double valorPrevisto;
  final double valorReal;
  final double percentualUtilizado;
  final double saldoRestante;
  final bool estourou;
  final double valorExcedente;
  final List<OrcamentoSubcategoriaDetalhe> subcategorias;

  const OrcamentoCategoriaComparativoModel({
    required this.categoria,
    required this.percentualOrcamento,
    required this.valorPrevisto,
    required this.valorReal,
    required this.percentualUtilizado,
    required this.saldoRestante,
    required this.estourou,
    required this.valorExcedente,
    this.subcategorias = const [],
  });
}

/// Comparativo Mensal Geral do Orçamento
class OrcamentoMensalComparativoModel {
  final double rendaReferencia;
  final double totalPrevisto;
  final double totalReal;
  final double saldoTotal;
  final double percentualGeralUtilizado;
  final bool estourouGeral;
  final double totalDespesasForaOrcamento;
  final List<OrcamentoCategoriaComparativoModel> categorias;

  const OrcamentoMensalComparativoModel({
    required this.rendaReferencia,
    required this.totalPrevisto,
    required this.totalReal,
    required this.saldoTotal,
    required this.percentualGeralUtilizado,
    required this.estourouGeral,
    required this.totalDespesasForaOrcamento,
    required this.categorias,
  });
}
