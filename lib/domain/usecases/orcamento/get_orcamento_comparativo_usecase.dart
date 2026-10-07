import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class GetOrcamentoComparativoUseCase {
  OrcamentoMensalComparativoModel execute({
    required double rendaReferencia,
    required List<Categoria> categoriasPai,
    required List<LancamentoDetails> lancamentos,
  }) {
    // 1. Filtra as categorias pai ativas de despesa que possuem percentual configurado
    final categoriasOrcamento = categoriasPai
        .where(
          (c) =>
              c.ativo &&
              c.natureza == CategoriaNatureza.saida &&
              c.percentualOrcamento != null &&
              c.categoriaPaiId == null,
        )
        .toList();

    // 2. Agrega os gastos por categoria raiz
    final Map<
      String,
      ({double total, Map<String, ({CategoriaDetails sub, double valor})> subs})
    >
    gastosPorPai = {};
    double totalDespesasForaOrcamento = 0.0;

    for (final l in lancamentos) {
      if (l.tipo != LancamentoTipo.despesa) continue;

      for (final item in l.itens) {
        if (item is! LancamentoItemDetailsStandard) continue;

        final rootCat = _getRootCategory(item.categoria);
        final subCat = item.categoria;
        final itemValor = item.valor;

        final isNoOrcamento = categoriasOrcamento.any(
          (c) => c.id == rootCat.id,
        );
        if (!isNoOrcamento) {
          totalDespesasForaOrcamento += itemValor;
          continue;
        }

        final existing = gastosPorPai[rootCat.id];
        if (existing == null) {
          gastosPorPai[rootCat.id] = (
            total: itemValor,
            subs: {subCat.id: (sub: subCat, valor: itemValor)},
          );
        } else {
          final subs = existing.subs;
          final existingSub = subs[subCat.id];
          if (existingSub == null) {
            subs[subCat.id] = (sub: subCat, valor: itemValor);
          } else {
            subs[subCat.id] = (
              sub: subCat,
              valor: existingSub.valor + itemValor,
            );
          }
          gastosPorPai[rootCat.id] = (
            total: existing.total + itemValor,
            subs: subs,
          );
        }
      }
    }

    // 3. Monta o comparativo para cada categoria do orçamento
    final List<OrcamentoCategoriaComparativoModel> categoriasComparativo = [];
    double totalPrevisto = 0.0;
    double totalReal = 0.0;

    for (final cat in categoriasOrcamento) {
      final pct = cat.percentualOrcamento ?? 0.0;
      final valorPrevisto = (rendaReferencia * pct) / 100.0;
      totalPrevisto += valorPrevisto;

      final gastoPai = gastosPorPai[cat.id];
      final valorReal = gastoPai?.total ?? 0.0;
      totalReal += valorReal;

      final percentualUtilizado = valorPrevisto > 0
          ? (valorReal / valorPrevisto) * 100.0
          : 0.0;
      final saldoRestante = valorPrevisto - valorReal;
      final estourou = valorReal > valorPrevisto;
      final valorExcedente = estourou ? (valorReal - valorPrevisto) : 0.0;

      final List<OrcamentoSubcategoriaDetalhe> subDetalhes = [];
      if (gastoPai != null) {
        final subEntries = gastoPai.subs.values.toList()
          ..sort((a, b) => b.valor.compareTo(a.valor));

        for (final s in subEntries) {
          final subPct = valorReal > 0 ? (s.valor / valorReal) * 100.0 : 0.0;
          subDetalhes.add(
            OrcamentoSubcategoriaDetalhe(
              categoria: s.sub,
              valor: s.valor,
              percentualDaCategoria: subPct,
            ),
          );
        }
      }

      categoriasComparativo.add(
        OrcamentoCategoriaComparativoModel(
          categoria: cat,
          percentualOrcamento: pct,
          valorPrevisto: valorPrevisto,
          valorReal: valorReal,
          percentualUtilizado: percentualUtilizado,
          saldoRestante: saldoRestante,
          estourou: estourou,
          valorExcedente: valorExcedente,
          subcategorias: subDetalhes,
        ),
      );
    }

    final saldoTotal = totalPrevisto - totalReal;
    final percentualGeralUtilizado = totalPrevisto > 0
        ? (totalReal / totalPrevisto) * 100.0
        : 0.0;
    final estourouGeral = totalReal > totalPrevisto;

    return OrcamentoMensalComparativoModel(
      rendaReferencia: rendaReferencia,
      totalPrevisto: totalPrevisto,
      totalReal: totalReal,
      saldoTotal: saldoTotal,
      percentualGeralUtilizado: percentualGeralUtilizado,
      estourouGeral: estourouGeral,
      totalDespesasForaOrcamento: totalDespesasForaOrcamento,
      categorias: categoriasComparativo,
    );
  }

  CategoriaDetails _getRootCategory(CategoriaDetails cat) {
    CategoriaDetails current = cat;
    while (current.categoriaPai != null) {
      current = current.categoriaPai!;
    }
    return current;
  }
}
