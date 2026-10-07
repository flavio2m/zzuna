import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/ui/categoria/update/widgets/categoria_update_modal.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_color_picker_field.dart';

import '../../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  Widget createWidgetUnderTest({
    required CategoriaDto categoria,
    bool temSubcategorias = false,
  }) {
    return ProviderScope(
      overrides: [
        categoriaRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: CategoriaUpdateModal(
            categoria: categoria,
            temSubcategorias: temSubcategorias,
          ),
        ),
      ),
    );
  }

  group('CategoriaUpdateModal', () {
    testWidgets(
      'exibe Natureza, Percentual e Cor para categoria pai sem subcategorias',
      (tester) async {
        final cat = CategoriaDto(
          id: 'cat-1',
          descricao: 'Moradia',
          natureza: CategoriaNatureza.saida,
          percentualOrcamento: 30,
          cor: '#0084FF',
        );

        await tester.pumpWidget(
          createWidgetUnderTest(categoria: cat, temSubcategorias: false),
        );
        await tester.pumpAndSettle();

        expect(find.text('Editar Categoria'), findsOneWidget);
        expect(find.text('Categoria Pai'), findsOneWidget);
        expect(find.text('Natureza'), findsOneWidget);
        expect(
          find.widgetWithText(
            TextFormField,
            'Percentual do Orçamento (% - Opcional)',
          ),
          findsOneWidget,
        );
        expect(find.byType(AppColorPickerField), findsOneWidget);
      },
    );

    testWidgets(
      'não exibe Categoria Pai quando temSubcategorias é true',
      (tester) async {
        final cat = CategoriaDto(
          id: 'cat-1',
          descricao: 'Moradia',
          natureza: CategoriaNatureza.saida,
          percentualOrcamento: 30,
          cor: '#0084FF',
        );

        await tester.pumpWidget(
          createWidgetUnderTest(categoria: cat, temSubcategorias: true),
        );
        await tester.pumpAndSettle();

        expect(find.text('Categoria Pai'), findsNothing);
        expect(find.text('Natureza'), findsOneWidget);
        expect(
          find.widgetWithText(
            TextFormField,
            'Percentual do Orçamento (% - Opcional)',
          ),
          findsOneWidget,
        );
        expect(find.byType(AppColorPickerField), findsOneWidget);
      },
    );

    testWidgets(
      'não exibe Natureza, Percentual e Cor para subcategoria (categoria filha)',
      (tester) async {
        final cat = CategoriaDto(
          id: 'cat-2',
          descricao: 'Aluguel',
          categoriaPaiId: 'cat-1',
          natureza: CategoriaNatureza.saida,
        );

        await tester.pumpWidget(
          createWidgetUnderTest(categoria: cat, temSubcategorias: false),
        );
        await tester.pumpAndSettle();

        expect(find.text('Categoria Pai'), findsOneWidget);
        expect(find.text('Natureza'), findsNothing);
        expect(
          find.widgetWithText(
            TextFormField,
            'Percentual do Orçamento (% - Opcional)',
          ),
          findsNothing,
        );
        expect(find.byType(AppColorPickerField), findsNothing);
      },
    );
  });
}
