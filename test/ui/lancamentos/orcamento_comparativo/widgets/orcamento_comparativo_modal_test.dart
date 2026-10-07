import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/widgets/orcamento_comparativo_button.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/widgets/orcamento_comparativo_modal.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders OrcamentoComparativoModal correctly with data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final catMoradia = Categoria(
      id: 'cat-1',
      descricao: 'Moradia',
      ativo: true,
      natureza: CategoriaNatureza.saida,
      percentualOrcamento: 30.0,
    );

    final mockComparativo = OrcamentoMensalComparativoModel(
      rendaReferencia: 5000.0,
      totalPrevisto: 1500.0,
      totalReal: 1200.0,
      saldoTotal: 300.0,
      percentualGeralUtilizado: 80.0,
      estourouGeral: false,
      totalDespesasForaOrcamento: 50.0,
      categorias: [
        OrcamentoCategoriaComparativoModel(
          categoria: catMoradia,
          percentualOrcamento: 30.0,
          valorPrevisto: 1500.0,
          valorReal: 1200.0,
          percentualUtilizado: 80.0,
          saldoRestante: 300.0,
          estourou: false,
          valorExcedente: 0.0,
          subcategorias: const [
            OrcamentoSubcategoriaDetalhe(
              categoria: CategoriaDetails(
                id: 'sub-1',
                descricao: 'Aluguel',
                ativo: true,
                natureza: CategoriaNatureza.saida,
                categoriaPai: null,
                subcategorias: [],
              ),
              valor: 1200.0,
              percentualDaCategoria: 100.0,
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orcamentoComparativoModelProvider.overrideWithValue(mockComparativo),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: OrcamentoComparativoModal()),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Orçamento: Previsto vs Real'), findsOneWidget);
    expect(find.text('Total Previsto'), findsOneWidget);
    expect(find.text('Total Real Gasto'), findsOneWidget);
    expect(find.text('Saldo Total'), findsOneWidget);
    expect(find.text('Moradia'), findsWidgets);
    expect(find.text('30%'), findsOneWidget);
    expect(find.text('80% utilizado'), findsWidgets);
    expect(
      find.textContaining('sem percentual de orçamento configurado'),
      findsOneWidget,
    );
  });

  testWidgets('OrcamentoComparativoButton opens modal when clicked', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockComparativo = OrcamentoMensalComparativoModel(
      rendaReferencia: 5000.0,
      totalPrevisto: 1500.0,
      totalReal: 0.0,
      saldoTotal: 1500.0,
      percentualGeralUtilizado: 0.0,
      estourouGeral: false,
      totalDespesasForaOrcamento: 0.0,
      categorias: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orcamentoComparativoModelProvider.overrideWithValue(mockComparativo),
        ],
        child: const MaterialApp(
          home: Scaffold(body: OrcamentoComparativoButton()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final buttonFinder = find.byType(OrcamentoComparativoButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(OrcamentoComparativoModal), findsOneWidget);
  });
}
