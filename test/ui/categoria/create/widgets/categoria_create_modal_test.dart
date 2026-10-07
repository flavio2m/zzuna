import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/ui/categoria/create/widgets/categoria_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_color_picker_field.dart';

import '../../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
    // Cria uma categoria pai para aparecer no dropdown
    await repository.create(
      CategoriaDto(
        descricao: 'Moradia',
        natureza: CategoriaNatureza.saida,
        percentualOrcamento: 30,
        cor: '#0084FF',
      ),
    );
  });

  tearDown(() {
    repository.dispose();
  });

  group('CategoriaCreateModal', () {
    testWidgets(
      'exibe Natureza, Percentual e Cor quando nenhuma categoria pai está selecionada',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            categoriaRepositoryProvider.overrideWithValue(repository),
          ],
        );
        await container
            .read(categoriaListViewModelProvider)
            .loadCommand
            .execute();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(body: CategoriaCreateModal()),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Nova Categoria'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Descrição'), findsOneWidget);
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
        expect(find.text('Ativo'), findsNothing);
      },
    );

    testWidgets(
      'oculta Natureza, Percentual e Cor quando uma categoria pai é selecionada',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            categoriaRepositoryProvider.overrideWithValue(repository),
          ],
        );
        await container
            .read(categoriaListViewModelProvider)
            .loadCommand
            .execute();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(body: CategoriaCreateModal()),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Inicialmente campos pai estão visíveis
        expect(find.text('Natureza'), findsOneWidget);
        expect(find.byType(AppColorPickerField), findsOneWidget);

        // Seleciona Moradia como categoria pai
        await tester.tap(find.byType(DropdownMenu<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Moradia').last);
        await tester.pumpAndSettle();

        // Agora não deve mais exibir Natureza, Percentual e Cor
        expect(find.text('Natureza'), findsNothing);
        expect(
          find.widgetWithText(
            TextFormField,
            'Percentual do Orçamento (% - Opcional)',
          ),
          findsNothing,
        );
        expect(find.byType(AppColorPickerField), findsNothing);
        expect(find.text('Ativo'), findsNothing);
      },
    );

    testWidgets('dropdown Categoria Pai não deve listar categorias inativas', (
      tester,
    ) async {
      await repository.create(
        CategoriaDto(
          descricao: 'Transporte Inativo',
          natureza: CategoriaNatureza.saida,
          ativo: false,
        ),
      );

      final container = ProviderContainer(
        overrides: [categoriaRepositoryProvider.overrideWithValue(repository)],
      );
      await container
          .read(categoriaListViewModelProvider)
          .loadCommand
          .execute();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: CategoriaCreateModal()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();

      expect(find.text('Moradia'), findsWidgets);
      expect(find.text('Transporte Inativo'), findsNothing);
    });
  });
}
