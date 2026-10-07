import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';

void main() {
  group('CategoriaField - Filtro de Categorias Ativas', () {
    testWidgets(
      'não deve exibir categorias inativas nem suas filhas no dropdown',
      (tester) async {
        final treeUseCase = CategoriaTreeUseCase();

        // Lista com categorias ativas e inativas
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
          const Categoria(
            id: 'c2',
            descricao: 'Transporte (Inativo)',
            ativo: false,
          ),
          const Categoria(
            id: 'c2_1',
            descricao: 'Combustível',
            categoriaPaiId: 'c2',
            ativo: false,
          ),
        ];

        // Constrói árvore
        final tree = treeUseCase.build(rawCategorias);

        String? selectedValue;

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

        // NÃO deve exibir a filha inativa
        expect(find.text('Alimentação > Doces (Antigo)'), findsNothing);

        // NÃO deve exibir o pai inativo nem a filha do pai inativo
        expect(find.text('Transporte (Inativo)'), findsNothing);
        expect(find.text('Transporte (Inativo) > Combustível'), findsNothing);
        expect(find.text('Combustível'), findsNothing);
      },
    );
  });
}
