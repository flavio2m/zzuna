import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/repositories/lista_compras/lista_compras_repository.dart';
import 'package:zzuna/domain/dtos/lista_compras/item_compra_dto.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_dto.dart';
import 'package:zzuna/domain/dtos/lista_compras/lista_compras_filter_dto.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lista_compras/create/item_compra/viewmodels/item_compras_create_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/delete/item_compra/viewmodels/item_compras_delete_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/delete/lista_compra/viewmodels/lista_compras_delete_lista_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/list/viewmodels/lista_compras_list_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/update/cancelar/viewmodels/lista_compras_status_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/update/comprar/viewmodels/lista_compras_comprar_viewmodel.dart';
import 'package:zzuna/ui/lista_compras/create/lista_compra/viewmodels/lista_compras_duplicar_viewmodel.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class FakeBaseStorage implements BaseStorage<ListaCompras> {
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
  group('ListaCompras Action ViewModels Tests', () {
    late FakeBaseStorage fakeStorage;
    late ListaComprasRepository repository;
    late ListaComprasListViewModel listVm;
    late ItemComprasCreateViewModel createVm;
    late ListaComprasComprarViewModel comprarVm;
    late ListaComprasStatusViewModel statusVm;
    late ListaComprasDuplicarViewModel duplicarVm;
    late ItemComprasDeleteViewModel deleteVm;

    setUp(() {
      fakeStorage = FakeBaseStorage();
      repository = ListaComprasRepository(fakeStorage);
      listVm = ListaComprasListViewModel(repository);
      createVm = ItemComprasCreateViewModel(repository);
      comprarVm = ListaComprasComprarViewModel(repository);
      statusVm = ListaComprasStatusViewModel(repository);
      duplicarVm = ListaComprasDuplicarViewModel(repository);
      deleteVm = ItemComprasDeleteViewModel(repository);
    });

    test('creates empty list for current filter', () async {
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);

      await createVm.criarListaVaziaCommand.execute(filter);
      expect(createVm.criarListaVaziaCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      expect(listVm.listaAtual, isNotNull);
      expect(listVm.listaAtual!.mes, Mes.setembro);
      expect(listVm.listaAtual!.ano, 2026);
      expect(listVm.listaAtual!.itens, isEmpty);
    });

    test('salvarItem adds new item and updates item', () async {
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);
      await createVm.criarListaVaziaCommand.execute(filter);
      await listVm.loadCommand.execute();

      final dto = ItemCompraDto(
        produto: 'Arroz',
        quantidadePlanejada: 5.0,
        precoEstimado: 4.5,
        supermercados: [const SupermercadoItem(nome: 'Mercadona')],
      );

      await createVm.salvarItemCommand.execute((
        dto: dto,
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      expect(createVm.salvarItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      expect(listVm.listaAtual!.itens.length, 1);

      final item = listVm.listaAtual!.itens.first;
      expect(item.produto, 'Arroz');
      expect(item.supermercados.first.nome, 'Mercadona');
    });

    test(
      'comprarItem marks last used supermarket and updates bought quantity',
      () async {
        final filter = const ListaComprasFilterDto(
          ano: 2026,
          mes: Mes.setembro,
        );
        listVm.setFilter(filter);
        await createVm.criarListaVaziaCommand.execute(filter);
        await listVm.loadCommand.execute();

        await createVm.salvarItemCommand.execute((
          dto: ItemCompraDto(
            produto: 'Azeite',
            quantidadePlanejada: 2.0,
            precoEstimado: 7.0,
            supermercados: [
              const SupermercadoItem(nome: 'Lidl'),
              const SupermercadoItem(nome: 'Continente'),
            ],
          ),
          filter: filter,
          listaAtual: listVm.listaAtual,
        ));
        await listVm.loadCommand.execute();

        final item = listVm.listaAtual!.itens.first;

        await comprarVm.comprarItemCommand.execute((
          lista: listVm.listaAtual!,
          itemId: item.id,
          quantidadeComprada: 2.0,
          supermercadoNome: 'Continente',
          observacao: 'Comprado na promoção',
          precoEstimado: 2.50,
        ));

        expect(comprarVm.comprarItemCommand.value.isSuccess, isTrue);
        await listVm.loadCommand.execute();

        final updatedItem = listVm.listaAtual!.itens.first;
        expect(updatedItem.situacao, ItemCompraSituacao.comprado);
        expect(updatedItem.quantidadeComprada, 2.0);
        expect(updatedItem.observacao, 'Comprado na promoção');
        expect(updatedItem.precoEstimado, 2.50);

        final continente = updatedItem.supermercados.firstWhere(
          (s) => s.nome == 'Continente',
        );
        expect(continente.ultimoUtilizado, isTrue);

        final lidl = updatedItem.supermercados.firstWhere(
          (s) => s.nome == 'Lidl',
        );
        expect(lidl.ultimoUtilizado, isFalse);
      },
    );

    test(
      'duplicarListaCommand clones list, resetting bought items to pendente with qtd=0 and keeping cancelados',
      () async {
        final filter = const ListaComprasFilterDto(
          ano: 2026,
          mes: Mes.setembro,
        );
        listVm.setFilter(filter);
        await createVm.criarListaVaziaCommand.execute(filter);
        await listVm.loadCommand.execute();

        await createVm.salvarItemCommand.execute((
          dto: ItemCompraDto(
            id: 'i1',
            produto: 'Café',
            quantidadePlanejada: 2.0,
            quantidadeComprada: 2.0,
            situacao: ItemCompraSituacao.comprado,
          ),
          filter: filter,
          listaAtual: listVm.listaAtual,
        ));

        await listVm.loadCommand.execute();

        await createVm.salvarItemCommand.execute((
          dto: ItemCompraDto(
            id: 'i2',
            produto: 'Leite',
            quantidadePlanejada: 4.0,
            quantidadeComprada: 1.0,
            situacao: ItemCompraSituacao.pendente,
          ),
          filter: filter,
          listaAtual: listVm.listaAtual,
        ));

        await listVm.loadCommand.execute();

        await createVm.salvarItemCommand.execute((
          dto: ItemCompraDto(
            id: 'i3',
            produto: 'Chocolate',
            quantidadePlanejada: 3.0,
            situacao: ItemCompraSituacao.cancelado,
          ),
          filter: filter,
          listaAtual: listVm.listaAtual,
        ));

        await listVm.loadCommand.execute();

        await duplicarVm.duplicarListaCommand.execute((
          listaOrigem: listVm.listaAtual!,
          anoDestino: 2026,
          mesDestino: Mes.outubro,
        ));
        expect(duplicarVm.duplicarListaCommand.value.isSuccess, isTrue);

        final novaLista = duplicarVm.duplicarListaCommand.value
            .getValueOrNull()!;
        expect(novaLista.ano, 2026);
        expect(novaLista.mes, Mes.outubro);
        expect(novaLista.itens.length, 3);

        final cafeClonado = novaLista.itens.firstWhere(
          (i) => i.produto == 'Café',
        );
        expect(cafeClonado.situacao, ItemCompraSituacao.pendente);
        expect(cafeClonado.quantidadeComprada, 0.0);
        expect(cafeClonado.quantidadePlanejada, 2.0);

        final leiteClonado = novaLista.itens.firstWhere(
          (i) => i.produto == 'Leite',
        );
        expect(leiteClonado.situacao, ItemCompraSituacao.pendente);
        expect(leiteClonado.quantidadeComprada, 0.0);

        final chocolateClonado = novaLista.itens.firstWhere(
          (i) => i.produto == 'Chocolate',
        );
        expect(chocolateClonado.situacao, ItemCompraSituacao.cancelado);
      },
    );

    test(
      'duplicarListaAnteriorCommand clones the most recent prior list',
      () async {
        final filterMaio = const ListaComprasFilterDto(
          ano: 2026,
          mes: Mes.maio,
        );
        listVm.setFilter(filterMaio);
        await createVm.criarListaVaziaCommand.execute(filterMaio);
        await listVm.loadCommand.execute();
        await createVm.salvarItemCommand.execute((
          dto: ItemCompraDto(
            produto: 'Feijão',
            quantidadePlanejada: 3.0,
            situacao: ItemCompraSituacao.comprado,
          ),
          filter: filterMaio,
          listaAtual: listVm.listaAtual,
        ));

        final filterJulho = const ListaComprasFilterDto(
          ano: 2026,
          mes: Mes.julho,
        );
        await duplicarVm.duplicarListaAnteriorCommand.execute((
          anoDestino: filterJulho.ano,
          mesDestino: filterJulho.mes,
        ));
        expect(duplicarVm.duplicarListaAnteriorCommand.value.isSuccess, isTrue);

        final novaLista = duplicarVm.duplicarListaAnteriorCommand.value
            .getValueOrNull()!;
        expect(novaLista.ano, 2026);
        expect(novaLista.mes, Mes.julho);
        expect(novaLista.itens.length, 1);
        expect(novaLista.itens.first.produto, 'Feijão');
        expect(novaLista.itens.first.situacao, ItemCompraSituacao.pendente);
      },
    );

    test(
      'duplicarListaAnteriorCommand fails if no prior list exists',
      () async {
        final filterJulho = const ListaComprasFilterDto(
          ano: 2030,
          mes: Mes.julho,
        );
        await duplicarVm.duplicarListaAnteriorCommand.execute((
          anoDestino: filterJulho.ano,
          mesDestino: filterJulho.mes,
        ));
        expect(duplicarVm.duplicarListaAnteriorCommand.value.isFailure, isTrue);
      },
    );

    test('itensFiltrados filters items by situacao and supermercado', () async {
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);
      await createVm.criarListaVaziaCommand.execute(filter);
      await listVm.loadCommand.execute();

      await createVm.salvarItemCommand.execute((
        dto: ItemCompraDto(
          produto: 'Arroz',
          situacao: ItemCompraSituacao.comprado,
          supermercados: [const SupermercadoItem(nome: 'Mercadona')],
        ),
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      await listVm.loadCommand.execute();

      await createVm.salvarItemCommand.execute((
        dto: ItemCompraDto(
          produto: 'Feijão',
          situacao: ItemCompraSituacao.pendente,
          supermercados: [const SupermercadoItem(nome: 'Continente')],
        ),
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      await listVm.loadCommand.execute();

      expect(
        listVm.supermercadosDisponiveis,
        containsAll(['Continente', 'Mercadona']),
      );

      expect(listVm.itensFiltrados.length, 2);

      listVm.setFilter(filter.copyWith(situacao: ItemCompraSituacao.comprado));
      expect(listVm.itensFiltrados.length, 1);
      expect(listVm.itensFiltrados.first.produto, 'Arroz');

      listVm.setFilter(filter.copyWith(supermercado: 'Continente'));
      expect(listVm.itensFiltrados.length, 1);
      expect(listVm.itensFiltrados.first.produto, 'Feijão');
    });

    test('duplicarListaCommand fails if target list already exists', () async {
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);
      await createVm.criarListaVaziaCommand.execute(filter);
      await listVm.loadCommand.execute();

      // Create list in October first
      await repository.create(ListaComprasDto(ano: 2026, mes: Mes.outubro));

      await duplicarVm.duplicarListaCommand.execute((
        listaOrigem: listVm.listaAtual!,
        anoDestino: 2026,
        mesDestino: Mes.outubro,
      ));
      expect(duplicarVm.duplicarListaCommand.value.isFailure, isTrue);
    });

    test('removerItemCommand removes item from list', () async {
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);
      await createVm.criarListaVaziaCommand.execute(filter);
      await listVm.loadCommand.execute();

      await createVm.salvarItemCommand.execute((
        dto: ItemCompraDto(
          id: 'item1',
          produto: 'Sabão',
          quantidadePlanejada: 1.0,
        ),
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      await listVm.loadCommand.execute();

      expect(listVm.listaAtual!.itens.length, 1);

      await deleteVm.removerItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
      ));
      expect(deleteVm.removerItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      expect(listVm.listaAtual!.itens, isEmpty);
    });

    test('alternarStatusItemCommand updates item status', () async {
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);
      await createVm.criarListaVaziaCommand.execute(filter);
      await listVm.loadCommand.execute();

      await createVm.salvarItemCommand.execute((
        dto: ItemCompraDto(
          id: 'item1',
          produto: 'Detergente',
          quantidadePlanejada: 2.0,
        ),
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      await listVm.loadCommand.execute();

      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
        situacao: ItemCompraSituacao.comprado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      expect(
        listVm.listaAtual!.itens.first.situacao,
        ItemCompraSituacao.comprado,
      );
      expect(listVm.listaAtual!.itens.first.quantidadeComprada, 2.0);

      // Tentar cancelar item comprado deve falhar
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
        situacao: ItemCompraSituacao.comprado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);

      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
        situacao: ItemCompraSituacao.cancelado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isFailure, isTrue);

      // Desmarcar comprado -> pendente
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
        situacao: ItemCompraSituacao.pendente,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      expect(
        listVm.listaAtual!.itens.first.situacao,
        ItemCompraSituacao.pendente,
      );
      expect(listVm.listaAtual!.itens.first.quantidadeComprada, 0.0);

      // Item parcialmente comprado (5 de 10)
      await createVm.salvarItemCommand.execute((
        dto: ItemCompraDto(
          id: 'item-parcial',
          produto: 'Sabão em pó',
          quantidadePlanejada: 10.0,
          quantidadeComprada: 5.0,
        ),
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      await listVm.loadCommand.execute();

      final itemParcial = listVm.listaAtual!.itens.firstWhere(
        (i) => i.id == 'item-parcial',
      );
      expect(itemParcial.quantidadeComprada, 5.0);
      expect(itemParcial.quantidadePlanejada, 10.0);

      // Cancelar item parcialmente comprado
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item-parcial',
        situacao: ItemCompraSituacao.cancelado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      final itemCancelado = listVm.listaAtual!.itens.firstWhere(
        (i) => i.id == 'item-parcial',
      );
      expect(itemCancelado.situacao, ItemCompraSituacao.cancelado);
      expect(itemCancelado.quantidadeComprada, 5.0);

      // Reativar item parcialmente comprado deve manter 5.0 comprados
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item-parcial',
        situacao: ItemCompraSituacao.pendente,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      final itemReativado = listVm.listaAtual!.itens.firstWhere(
        (i) => i.id == 'item-parcial',
      );
      expect(itemReativado.situacao, ItemCompraSituacao.pendente);
      expect(itemReativado.quantidadeComprada, 5.0);
      expect(itemReativado.quantidadePlanejada, 10.0);

      // Comprar item parcialmente comprado (5 de 10) deve alterar para 10 de 10
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item-parcial',
        situacao: ItemCompraSituacao.comprado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);

      await listVm.loadCommand.execute();
      final itemTotalmenteComprado = listVm.listaAtual!.itens.firstWhere(
        (i) => i.id == 'item-parcial',
      );
      expect(itemTotalmenteComprado.situacao, ItemCompraSituacao.comprado);
      expect(itemTotalmenteComprado.quantidadeComprada, 10.0);

      // Cancelar item item1 novamente para testar bloqueio de compra direta
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
        situacao: ItemCompraSituacao.cancelado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isSuccess, isTrue);
      await listVm.loadCommand.execute();

      // Tentar comprar item cancelado deve falhar
      await statusVm.alternarStatusItemCommand.execute((
        lista: listVm.listaAtual!,
        itemId: 'item1',
        situacao: ItemCompraSituacao.comprado,
      ));
      expect(statusVm.alternarStatusItemCommand.value.isFailure, isTrue);
    });

    test(
      'cloning item creates a new item with pendente situation and zero bought quantity',
      () async {
        final filter = const ListaComprasFilterDto(
          ano: 2026,
          mes: Mes.setembro,
        );
        listVm.setFilter(filter);
        await createVm.criarListaVaziaCommand.execute(filter);
        await listVm.loadCommand.execute();

        final originalItem = const ItemCompra(
          id: 'orig1',
          produto: 'Banana',
          quantidadePlanejada: 3.0,
          quantidadeComprada: 3.0,
          precoEstimado: 2.0,
          situacao: ItemCompraSituacao.comprado,
          observacao: 'Madura',
        );

        final cloneDto = ItemCompraDto(
          produto: originalItem.produto,
          quantidadePlanejada: originalItem.quantidadePlanejada,
          quantidadeComprada: 0.0,
          precoEstimado: originalItem.precoEstimado,
          supermercados: originalItem.supermercados,
          situacao: ItemCompraSituacao.pendente,
          observacao: originalItem.observacao,
        );

        await createVm.salvarItemCommand.execute((
          dto: cloneDto,
          filter: filter,
          listaAtual: listVm.listaAtual,
        ));

        expect(createVm.salvarItemCommand.value.isSuccess, isTrue);
        await listVm.loadCommand.execute();

        expect(listVm.listaAtual!.itens.length, 1);
        final item = listVm.listaAtual!.itens.first;
        expect(item.id, isNot('orig1'));
        expect(item.produto, 'Banana');
        expect(item.situacao, ItemCompraSituacao.pendente);
        expect(item.quantidadeComprada, 0.0);
      },
    );

    test(
      'itensOrdenados returns items sorted alphabetically by product description',
      () {
        final lista = ListaCompras(
          id: 'l1',
          ano: 2026,
          mes: Mes.setembro,
          periodo: 202609,
          itens: const [
            ItemCompra(id: '1', produto: 'Arroz parborizado'),
            ItemCompra(id: '2', produto: 'Arroz parborizado3'),
            ItemCompra(id: '3', produto: 'Aa parborizado'),
          ],
        );

        final ordenados = lista.itensOrdenados;
        expect(ordenados.map((i) => i.produto).toList(), [
          'Aa parborizado',
          'Arroz parborizado',
          'Arroz parborizado3',
        ]);
      },
    );

    test(
      'excluirListaCommand deletes entire list when no items bought',
      () async {
        final deleteListaVm = ListaComprasDeleteListaViewModel(repository);
        final filter = const ListaComprasFilterDto(
          ano: 2026,
          mes: Mes.setembro,
        );
        listVm.setFilter(filter);
        await createVm.criarListaVaziaCommand.execute(filter);
        await listVm.loadCommand.execute();

        expect(listVm.listaAtual, isNotNull);

        await deleteListaVm.excluirListaCommand.execute(listVm.listaAtual!);
        expect(deleteListaVm.excluirListaCommand.value.isSuccess, isTrue);

        await listVm.loadCommand.execute();
        expect(listVm.listaAtual, isNull);
      },
    );

    test('excluirListaCommand fails when list contains bought items', () async {
      final deleteListaVm = ListaComprasDeleteListaViewModel(repository);
      final filter = const ListaComprasFilterDto(ano: 2026, mes: Mes.setembro);
      listVm.setFilter(filter);
      await createVm.criarListaVaziaCommand.execute(filter);
      await listVm.loadCommand.execute();

      await createVm.salvarItemCommand.execute((
        dto: ItemCompraDto(
          produto: 'Leite',
          situacao: ItemCompraSituacao.comprado,
        ),
        filter: filter,
        listaAtual: listVm.listaAtual,
      ));
      await listVm.loadCommand.execute();

      await deleteListaVm.excluirListaCommand.execute(listVm.listaAtual!);
      expect(deleteListaVm.excluirListaCommand.value.isFailure, isTrue);

      await listVm.loadCommand.execute();
      expect(listVm.listaAtual, isNotNull);
    });
  });
}
