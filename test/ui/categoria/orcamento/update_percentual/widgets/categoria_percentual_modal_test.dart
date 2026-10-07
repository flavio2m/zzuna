import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/ui/categoria/orcamento/widgets/controle_orcamento_card.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

import '../../../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
    await repository.create(
      CategoriaDto(
        descricao: 'Custos Fixos',
        natureza: CategoriaNatureza.saida,
        percentualOrcamento: 30,
        cor: '#0084FF',
      ),
    );
  });

  tearDown(() {
    repository.dispose();
  });

  testWidgets(
    'ao alterar percentual via modal para 35, o card deve atualizar e exibir 35%',
    (tester) async {
      final user = User(
        id: 'u1',
        name: 'Flavio',
        email: 'flavio@test.com',
        orcamento: 5000.0,
      );

      final container = ProviderContainer(
        overrides: [
          categoriaRepositoryProvider.overrideWithValue(repository),
          userProvider.overrideWith((ref) => Stream.value(user)),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(categoriaListViewModelProvider)
          .loadCommand
          .execute();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: ControleOrcamentoCard(isExpanded: true)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica exibição inicial de 30%
      expect(find.text('30'), findsOneWidget);

      // Clica no badge do percentual (onde está '30')
      await tester.tap(find.text('30'));
      await tester.pumpAndSettle();

      // Verifica que o modal abriu
      expect(find.text('Editar Percentual'), findsOneWidget);

      // Limpa e digita 35 no campo de texto
      final textField = find.byType(TextField);
      await tester.enterText(textField, '35');
      await tester.pumpAndSettle();

      // Clica em Salvar
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // Verifica se o modal fechou e o card atualizou para 35%
      expect(find.text('Editar Percentual'), findsNothing);
      expect(find.text('35'), findsOneWidget);
    },
  );

  testWidgets(
    'ao alterar percentual via modal para 35,50, o card deve atualizar e exibir 35,50%',
    (tester) async {
      final user = User(
        id: 'u1',
        name: 'Flavio',
        email: 'flavio@test.com',
        orcamento: 5000.0,
      );

      final container = ProviderContainer(
        overrides: [
          categoriaRepositoryProvider.overrideWithValue(repository),
          userProvider.overrideWith((ref) => Stream.value(user)),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(categoriaListViewModelProvider)
          .loadCommand
          .execute();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: ControleOrcamentoCard(isExpanded: true)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('30'), findsOneWidget);

      await tester.tap(find.text('30'));
      await tester.pumpAndSettle();

      expect(find.text('Editar Percentual'), findsOneWidget);

      final textField = find.byType(TextField);
      await tester.enterText(textField, '35,50');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(find.text('Editar Percentual'), findsNothing);
      expect(find.text('35,50'), findsOneWidget);
    },
  );

  testWidgets(
    'cor do total Alocado é verde escuro em 100% e vermelho quando > 100%',
    (tester) async {
      final user = User(
        id: 'u1',
        name: 'Flavio',
        email: 'flavio@test.com',
        orcamento: 5000.0,
      );

      // Cria segunda categoria com 80% (total = 30 + 80 = 110%)
      await repository.create(
        CategoriaDto(
          descricao: 'Lazer',
          natureza: CategoriaNatureza.saida,
          percentualOrcamento: 80,
          cor: '#FF6B00',
        ),
      );

      final container = ProviderContainer(
        overrides: [
          categoriaRepositoryProvider.overrideWithValue(repository),
          userProvider.overrideWith((ref) => Stream.value(user)),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(categoriaListViewModelProvider)
          .loadCommand
          .execute();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: ControleOrcamentoCard(isExpanded: true)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 30 + 80 = 110% (> 100% -> vermelho)
      final text110 = tester.widget<AppText>(
        find.byWidgetPredicate((w) => w is AppText && w.text == '110% / 100%'),
      );
      expect(text110.color, AppColors.danger);

      // Altera Lazer de 80 para 70 (30 + 70 = 100% -> verde escuro)
      await tester.tap(find.text('80'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '70');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      final text100 = tester.widget<AppText>(
        find.byWidgetPredicate((w) => w is AppText && w.text == '100% / 100%'),
      );
      expect(text100.color, AppColors.emerald800);
    },
  );
}
