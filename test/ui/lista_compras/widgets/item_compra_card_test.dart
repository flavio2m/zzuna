import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/list/widgets/item_compra_card.dart';

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

  const item = ItemCompra(
    id: 'item-1',
    produto: 'Leite Desnatado',
    quantidadePlanejada: 3.0,
    precoEstimado: 4.50,
  );

  const lista = ListaCompras(
    id: 'lista-1',
    ano: 2026,
    mes: Mes.setembro,
    periodo: 202609,
    itens: [item],
  );

  testWidgets('ItemCompraCard renders Dismissible with correct key and label', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listaComprasRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ItemCompraCard(item: item, lista: lista),
          ),
        ),
      ),
    );

    expect(find.text('Leite Desnatado'), findsOneWidget);
    expect(find.byType(Dismissible), findsOneWidget);

    final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
    expect(dismissible.key, const ValueKey('item_compra_item-1'));
    expect(dismissible.direction, DismissDirection.horizontal);
  });

  testWidgets('ItemCompraCard renders Comprado state styling and actions', (
    tester,
  ) async {
    const itemComprado = ItemCompra(
      id: 'item-2',
      produto: 'Arroz 5kg',
      quantidadePlanejada: 1.0,
      quantidadeComprada: 1.0,
      situacao: ItemCompraSituacao.comprado,
    );

    const listaComprado = ListaCompras(
      id: 'lista-1',
      ano: 2026,
      mes: Mes.setembro,
      periodo: 202609,
      itens: [itemComprado],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listaComprasRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ItemCompraCard(item: itemComprado, lista: listaComprado),
          ),
        ),
      ),
    );

    expect(find.text('Arroz 5kg'), findsOneWidget);
    expect(find.byType(Dismissible), findsOneWidget);

    final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
    expect(dismissible.direction, DismissDirection.endToStart);
  });

  testWidgets(
    'ItemCompraCard renders Cancelado state and restricts to startToEnd swipe',
    (tester) async {
      const itemCancelado = ItemCompra(
        id: 'item-3',
        produto: 'Feijão Preto',
        quantidadePlanejada: 2.0,
        quantidadeComprada: 1.0,
        situacao: ItemCompraSituacao.cancelado,
      );

      const listaCancelado = ListaCompras(
        id: 'lista-1',
        ano: 2026,
        mes: Mes.setembro,
        periodo: 202609,
        itens: [itemCancelado],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            listaComprasRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ItemCompraCard(item: itemCancelado, lista: listaCancelado),
            ),
          ),
        ),
      );

      expect(find.text('Feijão Preto'), findsOneWidget);
      expect(find.byType(Dismissible), findsOneWidget);

      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      expect(dismissible.direction, DismissDirection.startToEnd);
    },
  );
}
