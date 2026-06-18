import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/lancamento/fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/fatura_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/fatura_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late FaturaRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = FaturaRepository(createTestFaturaStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('FaturaRepository', () {
    test('create saves a fatura successfully', () async {
      final dto = FaturaDto(
        cartaoId: 'card-1',
        ano: 2026,
        mes: Mes.janeiro,
        dataInicio: DateTime(2026, 1, 1),
        dataFim: DateTime(2026, 1, 31),
        fechada: false,
      );

      final result = await repository.create(dto);
      final faturas = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(faturas.getOrThrow(), hasLength(1));
      expect(faturas.getOrThrow().first.cartaoId, 'card-1');
    });

    test('update changes an existing fatura', () async {
      final created = await repository.create(
        FaturaDto(
          cartaoId: 'card-1',
          ano: 2026,
          mes: Mes.janeiro,
          fechada: false,
        ),
      );

      final model = created.getOrThrow();

      final result = await repository.update(
        FaturaDto(
          id: model.id,
          cartaoId: 'card-1',
          ano: 2026,
          mes: Mes.fevereiro,
          fechada: true,
        ),
      );

      final saved = await repository.getById(model.id);

      expect(result.isSuccess(), isTrue);
      expect(saved.getOrThrow().mes, Mes.fevereiro);
      expect(saved.getOrThrow().fechada, isTrue);
    });

    test('delete removes an existing fatura', () async {
      final created = await repository.create(
        FaturaDto(cartaoId: 'card-1'), //
      );

      final model = created.getOrThrow();
      final result = await repository.delete(model.id);

      expect(result.isSuccess(), isTrue);
    });

    test('getById returns the correct fatura', () async {
      final created = await repository.create(
        FaturaDto(cartaoId: 'card-2'), //
      );

      final model = created.getOrThrow();
      final result = await repository.getById(model.id);

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow().cartaoId, 'card-2');
    });

    test('getAll returns empty list when no faturas exist', () async {
      final result = await repository.getAll();
      expect(result.getOrThrow(), isEmpty);
    });

    test('getAll returns list of faturas when they exist', () async {
      await repository.create(FaturaDto(cartaoId: 'card-1'));
      await repository.create(FaturaDto(cartaoId: 'card-2'));

      final result = await repository.getAll();
      expect(result.getOrThrow(), hasLength(2));
    });

    test('search filters by mes', () async {
      await repository.create(FaturaDto(mes: Mes.janeiro));
      await repository.create(FaturaDto(mes: Mes.fevereiro));

      final searchResult = await repository.search(
        FaturaFilterDto(mes: Mes.janeiro), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.mes, Mes.janeiro);
    });

    test('search filters by status (fechada/aberta)', () async {
      await repository.create(FaturaDto(fechada: true));
      await repository.create(FaturaDto(fechada: false));

      final searchResult = await repository.search(
        FaturaFilterDto(fechada: true), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.fechada, isTrue);
    });

    test('search filters by combined filters', () async {
      await repository.create(FaturaDto(mes: Mes.janeiro, fechada: true));
      await repository.create(FaturaDto(mes: Mes.janeiro, fechada: false));
      await repository.create(FaturaDto(mes: Mes.fevereiro, fechada: true));

      final searchResult = await repository.search(
        FaturaFilterDto(mes: Mes.janeiro, fechada: true), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.mes, Mes.janeiro);
      expect(searchResult.getOrThrow().first.fechada, isTrue);
    });

    test('update of non-existent fatura returns failure', () async {
      final result = await repository.update(
        FaturaDto(id: 'non-existent', cartaoId: 'card-1'), //
      );
      expect(result.isError(), isTrue);
    });

    test('delete of non-existent fatura returns failure', () async {
      final result = await repository.delete('non-existent');
      expect(result.isError(), isTrue);
    });

    test('getById of non-existent fatura returns failure', () async {
      final result = await repository.getById('non-existent');
      expect(result.isError(), isTrue);
    });

    test('observer emits RepositoryCreated after create', () async {
      final expectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<Fatura>>()), //
      );

      await repository.create(FaturaDto(cartaoId: 'card-1'));

      await expectation;
    });

    test('observer emits RepositoryUpdated after update', () async {
      final created = await repository.create(FaturaDto(cartaoId: 'card-1'));
      final model = created.getOrThrow();

      final expectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<Fatura>>()), //
      );

      await repository.update(
        FaturaDto(id: model.id, cartaoId: 'card-2'), //
      );

      await expectation;
    });

    test('observer emits RepositoryDeleted after delete', () async {
      final created = await repository.create(FaturaDto(cartaoId: 'card-1'));
      final model = created.getOrThrow();

      final expectation = expectLater(
        repository.observer(),
        emits(
          isA<RepositoryDeleted<Fatura>>().having(
            (e) => e.id,
            'id',
            model.id, //
          ),
        ),
      );

      await repository.delete(model.id);

      await expectation;
    });
  });
}
