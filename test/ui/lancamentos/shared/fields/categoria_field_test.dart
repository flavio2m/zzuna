import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';

void main() {
  group('CategoriaField - Exibição de Categorias', () {
    testWidgets(
      'deve exibir categorias ativas normalmente e categorias inativas com sufixo (Inativa)',
      (tester) async {
        final treeUseCase = CategoriaTreeUseCase();

        final rawCategorias = [
          const Categoria(id: 'c1', descricao: 'Alimentação', ativo: true),
          const Categoria(
            id: 'c1_1',
            descricao: 'Supermercado',
            categoriaPaiId: 'c1',
            ativo: true,
          ),
          const Categoria(
            id: 'c1_2',
            descricao: 'Doces (Antigo)',
            categoriaPaiId: 'c1',
            ativo: false,
          ),
        ];

        final tree = treeUseCase.build(rawCategorias);

        String? selectedValue = 'c1_2';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CategoriaField(
                    categorias: tree,
                    value: selectedValue,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Clica no dropdown para abrir o menu
        await tester.tap(find.byType(CategoriaField));
        await tester.pumpAndSettle();

        // Deve exibir as categorias ativas
        expect(find.text('Alimentação'), findsWidgets);
        expect(find.text('Alimentação > Supermercado'), findsWidgets);

        // Deve exibir a categoria inativa com o sufixo (Inativa)
        expect(
          find.text('Alimentação > Doces (Antigo) (Inativa)'),
          findsWidgets,
        );
      },
    );
  });
}
