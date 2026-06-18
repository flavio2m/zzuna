import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ExtratoRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = ExtratoRepository(createTestExtratoStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('ExtratoRepository', () {
    test('create saves an extrato successfully', () async {
      final dto = ExtratoDto(
        contaId: 'account-1',
        ano: 2026,
        mes: Mes.janeiro,
        dataInicio: DateTime(2026, 1, 1),
        dataFim: DateTime(2026, 1, 31),
        fechado: false,
      );

      final result = await repository.create(dto);
      final extratos = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(extratos.getOrThrow(), hasLength(1));
      expect(extratos.getOrThrow().first.contaId, 'account-1');
    });

    test('update changes an existing extrato', () async {
      final created = await repository.create(
        ExtratoDto(
          contaId: 'account-1',
          ano: 2026,
          mes: Mes.janeiro,
          fechado: false,
        ),
      );

      final model = created.getOrThrow();

      final result = await repository.update(
        ExtratoDto(
          id: model.id,
          contaId: 'account-1',
          ano: 2026,
          mes: Mes.fevereiro,
          fechado: true,
        ),
      );

      final saved = await repository.getById(model.id);

      expect(result.isSuccess(), isTrue);
      expect(saved.getOrThrow().mes, Mes.fevereiro);
      expect(saved.getOrThrow().fechado, isTrue);
    });

    test('delete removes an existing extrato', () async {
      final created = await repository.create(
        ExtratoDto(contaId: 'account-1'), //
      );

      final model = created.getOrThrow();
      final result = await repository.delete(model.id);

      expect(result.isSuccess(), isTrue);
    });

    test('getById returns the correct extrato', () async {
      final created = await repository.create(
        ExtratoDto(contaId: 'account-2'), //
      );

      final model = created.getOrThrow();
      final result = await repository.getById(model.id);

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow().contaId, 'account-2');
    });

    test('getAll returns empty list when no extratos exist', () async {
      final result = await repository.getAll();
      expect(result.getOrThrow(), isEmpty);
    });

    test('getAll returns list of extratos when they exist', () async {
      await repository.create(ExtratoDto(contaId: 'account-1'));
      await repository.create(ExtratoDto(contaId: 'account-2'));

      final result = await repository.getAll();
      expect(result.getOrThrow(), hasLength(2));
    });

    test('search filters by mes', () async {
      await repository.create(ExtratoDto(mes: Mes.janeiro));
      await repository.create(ExtratoDto(mes: Mes.fevereiro));

      final searchResult = await repository.search(
        ExtratoFilterDto(mes: Mes.janeiro), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.mes, Mes.janeiro);
    });

    test('search filters by status (fechado/aberto)', () async {
      await repository.create(ExtratoDto(fechado: true));
      await repository.create(ExtratoDto(fechado: false));

      final searchResult = await repository.search(
        ExtratoFilterDto(fechado: true), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.fechado, isTrue);
    });

    test('search filters by combined filters', () async {
      await repository.create(ExtratoDto(mes: Mes.janeiro, fechado: true));
      await repository.create(ExtratoDto(mes: Mes.janeiro, fechado: false));
      await repository.create(ExtratoDto(mes: Mes.fevereiro, fechado: true));

      final searchResult = await repository.search(
        ExtratoFilterDto(mes: Mes.janeiro, fechado: true), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.mes, Mes.janeiro);
      expect(searchResult.getOrThrow().first.fechado, isTrue);
    });

    test('update of non-existent extrato returns failure', () async {
      final result = await repository.update(
        ExtratoDto(id: 'non-existent', contaId: 'account-1'), //
      );
      expect(result.isError(), isTrue);
    });

    test('delete of non-existent extrato returns failure', () async {
      final result = await repository.delete('non-existent');
      expect(result.isError(), isTrue);
    });

    test('getById of non-existent extrato returns failure', () async {
      final result = await repository.getById('non-existent');
      expect(result.isError(), isTrue);
    });

    test('observer emits RepositoryCreated after create', () async {
      final expectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<Extrato>>()), //
      );

      await repository.create(ExtratoDto(contaId: 'account-1'));

      await expectation;
    });

    test('observer emits RepositoryUpdated after update', () async {
      final created = await repository.create(ExtratoDto(contaId: 'account-1'));
      final model = created.getOrThrow();

      final expectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<Extrato>>()), //
      );

      await repository.update(
        ExtratoDto(id: model.id, contaId: 'account-2'), //
      );

      await expectation;
    });

    test('observer emits RepositoryDeleted after delete', () async {
      final created = await repository.create(ExtratoDto(contaId: 'account-1'));
      final model = created.getOrThrow();

      final expectation = expectLater(
        repository.observer(),
        emits(
          isA<RepositoryDeleted<Extrato>>().having(
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
