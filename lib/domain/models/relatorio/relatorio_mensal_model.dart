import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

class RelatorioSubcategoriaItem {
  final CategoriaDetails categoria;
  final double valor;
  final double percentual;

  const RelatorioSubcategoriaItem({
    required this.categoria,
    required this.valor,
    required this.percentual,
  });
}

class RelatorioCategoriaPaiGroup {
  final CategoriaDetails categoriaPai;
  final double valorTotal;
  final double percentualDoTotal;
  final List<RelatorioSubcategoriaItem> subcategorias;

  const RelatorioCategoriaPaiGroup({
    required this.categoriaPai,
    required this.valorTotal,
    required this.percentualDoTotal,
    required this.subcategorias,
  });
}

class RelatorioCentroCustoGroup {
  final CentroCustoDetails centroCusto;
  final double valorTotal;
  final double percentualDoTotal;
  final List<RelatorioCategoriaPaiGroup> categoriasPai;

  const RelatorioCentroCustoGroup({
    required this.centroCusto,
    required this.valorTotal,
    required this.percentualDoTotal,
    required this.categoriasPai,
  });
}

class RelatorioMensalModel {
  final double totalReceitas;
  final double totalDespesas;
  final double saldo;
  final List<RelatorioCategoriaPaiGroup> categoriasPaiDespesas;
  final List<RelatorioCategoriaPaiGroup> categoriasPaiReceitas;
  final List<RelatorioCentroCustoGroup> centrosDeCustoDespesas;
  final List<RelatorioCentroCustoGroup> centrosDeCustoReceitas;

  List<RelatorioCategoriaPaiGroup> get categoriasPai => categoriasPaiDespesas;
  List<RelatorioCentroCustoGroup> get centrosDeCusto => centrosDeCustoDespesas;

  const RelatorioMensalModel({
    required this.totalReceitas,
    required this.totalDespesas,
    required this.saldo,
    required this.categoriasPaiDespesas,
    required this.categoriasPaiReceitas,
    required this.centrosDeCustoDespesas,
    required this.centrosDeCustoReceitas,
  });
}
