import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/list/widgets/item_compra_historico_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';

class _FakeBaseStorage implements BaseStorage<ListaCompras> {
  final Map<String, ListaCompras> storage = {};

  @override
  AsyncResult<ListaCompras> create(ListaCompras model) async {
    storage[model.id] = model;
    return Success(model);
  }

  @override
  AsyncResult<Unit> createAll(List<ListaCompras> models) async {
    for (final m in models) {
      storage[m.id] = m;
    }
    return const Success(unit);
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    storage.remove(id);
    return const Success(unit);
  }

  @override
  AsyncResult<List<ListaCompras>> getAll() async {
    return Success(storage.values.toList());
  }

  @override
  AsyncResult<ListaCompras> getById(String id) async {
    if (storage.containsKey(id)) {
      return Success(storage[id]!);
    }
    return Failure(Exception('Not found'));
  }

  @override
  AsyncResult<ListaCompras> update(ListaCompras model) async {
    storage[model.id] = model;
    return Success(model);
  }

  @override
  AsyncResult<Unit> updateAll(List<ListaCompras> models) async {
    for (final m in models) {
      storage[m.id] = m;
    }
    return const Success(unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ListaComprasRepository repository;

  setUp(() {
    repository = ListaComprasRepository(_FakeBaseStorage());
  });

  testWidgets(
    'ItemCompraHistoricoModal renders empty state when no purchases',
    (tester) async {
      const item = ItemCompra(
        id: 'item-1',
        produto: 'Azeite',
        quantidadePlanejada: 2.0,
        historicoCompras: [],
        situacao: ItemCompraSituacao.pendente,
      );

      const lista = ListaCompras(
        id: 'l1',
        ano: 2026,
        mes: Mes.setembro,
        periodo: 202609,
        itens: [item],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            listaComprasRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ItemCompraHistoricoModal(item: item, lista: lista),
            ),
          ),
        ),
      );

      expect(find.text('Histórico de Compras'), findsOneWidget);
      expect(find.text('Azeite'), findsOneWidget);
      expect(
        find.text('Nenhuma compra registrada para este item.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('ItemCompraHistoricoModal renders purchase records and details', (
    tester,
  ) async {
    final item = ItemCompra(
      id: 'item-2',
      produto: 'Arroz 5kg',
      quantidadePlanejada: 3.0,
      historicoCompras: [
        RegistroCompra(
          data: DateTime(2026, 9, 10),
          quantidade: 2.0,
          precoReal: 25.0,
          supermercadoId: 'Mercado Central',
        ),
      ],
      situacao: ItemCompraSituacao.pendente,
    );

    final lista = ListaCompras(
      id: 'l1',
      ano: 2026,
      mes: Mes.setembro,
      periodo: 202609,
      itens: [item],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listaComprasRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ItemCompraHistoricoModal(item: item, lista: lista),
          ),
        ),
      ),
    );

    expect(find.text('Histórico de Compras'), findsOneWidget);
    expect(find.text('Arroz 5kg'), findsOneWidget);
    expect(find.text('10/09/2026'), findsOneWidget);
    expect(find.text('Qtd: 2 un.'), findsOneWidget);
    expect(find.text('Mercado Central'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Editar Compra'), findsOneWidget);
    expect(find.text('Data da Compra'), findsOneWidget);
    expect(find.text('Quantidade Comprada'), findsOneWidget);

    final dataField = find.widgetWithText(TextFormField, 'Data da Compra');
    expect(dataField, findsOneWidget);
    final dataTextField = tester.widget<TextField>(
      find.descendant(of: dataField, matching: find.byType(TextField)),
    );
    expect(dataTextField.focusNode?.hasFocus, isTrue);

    // Enter no campo Data -> vai para Quantidade
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();

    final qtdField = find.widgetWithText(TextFormField, 'Quantidade Comprada');
    expect(qtdField, findsOneWidget);
    final qtdTextField = tester.widget<TextField>(
      find.descendant(of: qtdField, matching: find.byType(TextField)),
    );
    expect(qtdTextField.focusNode?.hasFocus, isTrue);

    // Enter no campo Quantidade -> vai para Preço
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();

    final precoField = find.widgetWithText(TextFormField, 'Preço');
    expect(precoField, findsOneWidget);
    final precoTextField = tester.widget<TextField>(
      find.descendant(of: precoField, matching: find.byType(TextField)),
    );
    expect(precoTextField.focusNode?.hasFocus, isTrue);

    // Enter no campo Preço -> vai para Supermercado
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();

    final mercadoField = find.widgetWithText(
      TextFormField,
      'Nome do Supermercado',
    );
    expect(mercadoField, findsOneWidget);
    final mercadoTextField = tester.widget<TextField>(
      find.descendant(of: mercadoField, matching: find.byType(TextField)),
    );
    expect(mercadoTextField.focusNode?.hasFocus, isTrue);

    // Enter no campo Supermercado -> vai para o botão Salvar
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(AppButton, 'Salvar');
    expect(saveButton, findsOneWidget);
    final saveFocusNode = tester.widget<AppButton>(saveButton).focusNode;
    expect(saveFocusNode?.hasFocus, isTrue);
  });
}
