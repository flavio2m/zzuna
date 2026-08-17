import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/models/relatorio/relatorio_mensal_model.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

typedef _CategoryAggregator =
    Map<
      String,
      ({
        CategoriaDetails parent,
        Map<String, ({CategoriaDetails sub, double value})> subs,
        double total,
      })
    >;

class GetRelatorioMensalUseCase {
  RelatorioMensalModel execute(List<LancamentoDetails> lancamentos) {
    double totalReceitas = 0.0;
    double totalDespesas = 0.0;

    final _CategoryAggregator despesasCategoryMap = {};
    final _CategoryAggregator receitasCategoryMap = {};

    final Map<
      String,
      ({CentroCustoDetails cc, _CategoryAggregator categories, double total})
    >
    despesasCcMap = {};

    final Map<
      String,
      ({CentroCustoDetails cc, _CategoryAggregator categories, double total})
    >
    receitasCcMap = {};

    for (final l in lancamentos) {
      if (l.tipo == LancamentoTipo.receita) {
        totalReceitas += l.valor;

        for (final item in l.itens) {
          if (item is LancamentoItemDetailsStandard) {
            _accumulateCategoryItem(receitasCategoryMap, item);
            _accumulateCcItem(receitasCcMap, item);
          }
        }
      } else if (l.tipo == LancamentoTipo.despesa) {
        totalDespesas += l.valor;

        for (final item in l.itens) {
          if (item is LancamentoItemDetailsStandard) {
            _accumulateCategoryItem(despesasCategoryMap, item);
            _accumulateCcItem(despesasCcMap, item);
          }
        }
      }
    }

    final saldo = totalReceitas - totalDespesas;

    final categoriasPaiDespesas = _processCategoryMap(
      despesasCategoryMap,
      totalDespesas,
    );

    final categoriasPaiReceitas = _processCategoryMap(
      receitasCategoryMap,
      totalReceitas,
    );

    final centrosDeCustoDespesas = _processCcMap(despesasCcMap, totalDespesas);

    final centrosDeCustoReceitas = _processCcMap(receitasCcMap, totalReceitas);

    return RelatorioMensalModel(
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      saldo: saldo,
      categoriasPaiDespesas: categoriasPaiDespesas,
      categoriasPaiReceitas: categoriasPaiReceitas,
      centrosDeCustoDespesas: centrosDeCustoDespesas,
      centrosDeCustoReceitas: centrosDeCustoReceitas,
    );
  }

  void _accumulateCategoryItem(
    _CategoryAggregator categoryMap,
    LancamentoItemDetailsStandard item,
  ) {
    final parentCat = item.categoria.categoriaPai ?? item.categoria;
    final subCat = item.categoria;
    final itemValue = item.valor;

    final existingParent = categoryMap[parentCat.id];
    if (existingParent == null) {
      categoryMap[parentCat.id] = (
        parent: parentCat,
        subs: {subCat.id: (sub: subCat, value: itemValue)},
        total: itemValue,
      );
    } else {
      final currentSubs = existingParent.subs;
      final existingSub = currentSubs[subCat.id];
      if (existingSub == null) {
        currentSubs[subCat.id] = (sub: subCat, value: itemValue);
      } else {
        currentSubs[subCat.id] = (
          sub: subCat,
          value: existingSub.value + itemValue,
        );
      }

      categoryMap[parentCat.id] = (
        parent: parentCat,
        subs: currentSubs,
        total: existingParent.total + itemValue,
      );
    }
  }

  void _accumulateCcItem(
    Map<
      String,
      ({CentroCustoDetails cc, _CategoryAggregator categories, double total})
    >
    ccMap,
    LancamentoItemDetailsStandard item,
  ) {
    final cc = item.centroCusto;
    final existingCc = ccMap[cc.id];
    if (existingCc == null) {
      final _CategoryAggregator catMap = {};
      _accumulateCategoryItem(catMap, item);
      ccMap[cc.id] = (cc: cc, categories: catMap, total: item.valor);
    } else {
      _accumulateCategoryItem(existingCc.categories, item);
      ccMap[cc.id] = (
        cc: cc,
        categories: existingCc.categories,
        total: existingCc.total + item.valor,
      );
    }
  }

  List<RelatorioCategoriaPaiGroup> _processCategoryMap(
    _CategoryAggregator categoryMap,
    double totalBase,
  ) {
    final List<RelatorioCategoriaPaiGroup> result = [];
    final categoryEntries = categoryMap.values.toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    for (final entry in categoryEntries) {
      final parentTotal = entry.total;
      final percentualParent = totalBase > 0
          ? (parentTotal / totalBase) * 100
          : 0.0;

      final subEntries = entry.subs.values.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final List<RelatorioSubcategoriaItem> subcategories = subEntries.map((s) {
        final subPercentual = parentTotal > 0
            ? (s.value / parentTotal) * 100
            : 0.0;
        return RelatorioSubcategoriaItem(
          categoria: s.sub,
          valor: s.value,
          percentual: subPercentual,
        );
      }).toList();

      result.add(
        RelatorioCategoriaPaiGroup(
          categoriaPai: entry.parent,
          valorTotal: parentTotal,
          percentualDoTotal: percentualParent,
          subcategorias: subcategories,
        ),
      );
    }

    return result;
  }

  List<RelatorioCentroCustoGroup> _processCcMap(
    Map<
      String,
      ({CentroCustoDetails cc, _CategoryAggregator categories, double total})
    >
    ccMap,
    double totalBase,
  ) {
    final List<RelatorioCentroCustoGroup> result = [];
    final ccEntries = ccMap.values.toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    for (final entry in ccEntries) {
      final ccTotal = entry.total;
      final percentual = totalBase > 0 ? (ccTotal / totalBase) * 100 : 0.0;
      final ccCategories = _processCategoryMap(entry.categories, ccTotal);

      result.add(
        RelatorioCentroCustoGroup(
          centroCusto: entry.cc,
          valorTotal: ccTotal,
          percentualDoTotal: percentual,
          categoriasPai: ccCategories,
        ),
      );
    }

    return result;
  }
}
