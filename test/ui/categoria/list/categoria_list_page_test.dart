import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/ui/categoria/list/categoria_list_page.dart';
import 'package:zzuna/ui/categoria/orcamento/widgets/controle_orcamento_card.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
    // Cria categorias com percentual para popular o ControleOrcamentoCard
    await repository.create(
      CategoriaDto(
        descricao: 'Custos Fixos',
        natureza: CategoriaNatureza.saida,
        percentualOrcamento: 50,
        cor: '#0084FF',
      ),
    );
    await repository.create(
      CategoriaDto(
        descricao: 'Conforto',
        natureza: CategoriaNatureza.saida,
        percentualOrcamento: 20,
        cor: '#F43F85',
      ),
    );
    await repository.create(
      CategoriaDto(
        descricao: 'Metas Financeiras',
        natureza: CategoriaNatureza.saida,
        percentualOrcamento: 15,
        cor: '#A855F7',
      ),
    );
  });

  tearDown(() {
    repository.dispose();
  });

  group('CategoriaListPage layout', () {
    testWidgets(
      'renders narrow layout inside SingleChildScrollView without overflow on small screens',
      (tester) async {
        tester.view.physicalSize = const Size(360, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

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

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: CategoriaListPage()),
          ),
        );
        await tester.pumpAndSettle();

        // Verifica se o ControleOrcamentoCard foi renderizado
        expect(find.byType(ControleOrcamentoCard), findsOneWidget);
        expect(find.text('Orçamento'), findsOneWidget);
        // "Custos Fixos" aparece no card de orçamento e na lista de categorias
        expect(find.text('Custos Fixos'), findsNWidgets(2));

        // Verifica se SingleChildScrollView está presente no layout narrow
        expect(find.byType(SingleChildScrollView), findsWidgets);

        // Rola a página para baixo para testar scroll sem exceção
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        // Não deve ocorrer nenhuma exceção de overflow
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'renders wide layout with options on top and side-by-side list and budget',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

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

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: CategoriaListPage()),
          ),
        );
        await tester.pumpAndSettle();

        // Verifica elementos do topo e das duas colunas
        expect(find.text('Orçamento'), findsOneWidget);
        expect(find.text('Custos Fixos'), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      },
    );
  });
}
