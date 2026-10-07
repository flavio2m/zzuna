import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_item_form.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_percent_form_field.dart';

void main() {
  testWidgets(
    'LancamentoItemForm aceita percentual com 3 ou mais casas decimais sem erro',
    (tester) async {
      final categorias = [
        const CategoriaDetails(
          id: 'cat-1',
          descricao: 'Limpeza',
          ativo: true,
          natureza: CategoriaNatureza.saida,
          categoriaPai: null,
          subcategorias: [],
        ),
      ];

      final centros = [
        const CentroCusto(id: 'cc-1', descricao: 'Geral', ativo: true),
      ];

      double? savedValor;
      String? savedCcId;
      String? savedCatId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LancamentoItemForm(
                categorias: categorias,
                centros: centros,
                totalValor: 3.37,
                initialItem: const LancamentoItem(
                  numero: 2,
                  categoriaId: 'cat-1',
                  centroCustoId: 'cc-1',
                  valor: 1.09,
                ),
                onSave: (ccId, catId, valor) {
                  savedCcId = ccId;
                  savedCatId = catId;
                  savedValor = valor;
                },
                onCancel: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // O percentual calculado para 1.09 / 3.37 * 100 é aprox 32.344%
      expect(find.byType(AppPercentFormField), findsOneWidget);
      expect(find.text('Máximo de 2 casas decimais'), findsNothing);

      // Clica no botão de salvar (ButtonSave)
      final saveBtn = find.byType(ButtonSave);
      expect(saveBtn, findsOneWidget);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Máximo de 2 casas decimais'), findsNothing);
      expect(savedValor, 1.09);
      expect(savedCcId, 'cc-1');
      expect(savedCatId, 'cat-1');
    },
  );
}
