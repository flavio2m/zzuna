import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late CentroCustoRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = CentroCustoRepository(createTestCentroCustoStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('CentroCustoRepository', () {
    test('create saves a centro_custo when descricao does not exist', () async {
      final dto = CentroCustoDto(descricao: 'Aluguel', ativo: true);

      final result = await repository.create(dto);
      final centros = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      final list = centros.getOrThrow();
      expect(list.any((c) => c.descricao == 'Aluguel'), isTrue);
    });

    test('create returns failure when descricao already exists', () async {
      final dto = CentroCustoDto(descricao: 'Aluguel');

      await repository.create(dto);

      final result = await repository.create(
        CentroCustoDto(descricao: 'Aluguel'), //
      );

      expect(result.isError(), isTrue);
    });

    test('findByDescricao returns an existing centro_custo', () async {
      final dto = CentroCustoDto(descricao: 'Lazer');

      await repository.create(dto);

      final result = await repository.findByDescricao('Lazer');

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow().descricao, 'Lazer');
    });

    test('findByDescricao returns failure when centro_custo does not exist', () async {
      final result = await repository.findByDescricao('Centro Inexistente');

      expect(result.isError(), isTrue);
    });

    test('update changes an existing centro_custo', () async {
      final created = await repository.create(
        CentroCustoDto(descricao: 'Original'), //
      );

      final centro = created.getOrThrow();

      final result = await repository.update(
        CentroCustoDto(
          id: centro.id,
          descricao: 'Atualizado',
          ativo: false,
        ),
      );

      final saved = await repository.getById(centro.id);

      expect(result.isSuccess(), isTrue);
      expect(saved.getOrThrow().descricao, 'Atualizado');
      expect(saved.getOrThrow().ativo, false);
    });

    test('delete removes an existing centro_custo', () async {
      final created = await repository.create(
        CentroCustoDto(descricao: 'Temp'), //
      );

      final result = await repository.delete(created.getOrThrow().id);

      expect(result.isSuccess(), isTrue);
    });

    test('observer emits RepositoryCreated after create succeeds', () async {
      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<CentroCusto>>()), //
      );

      await repository.create(
        CentroCustoDto(descricao: 'Stream'), //
      );

      await eventExpectation;
    });

    test('observer emits RepositoryUpdated after update succeeds', () async {
      final created = await repository.create(
        CentroCustoDto(descricao: 'Stream'), //
      );

      final centro = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<CentroCusto>>()), //
      );

      await repository.update(
        CentroCustoDto(id: centro.id, descricao: 'Stream Upd'), //
      );

      await eventExpectation;
    });

    test('observer emits RepositoryDeleted after delete succeeds', () async {
      final created = await repository.create(
        CentroCustoDto(descricao: 'Stream'), //
      );

      final centro = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(
          isA<RepositoryDeleted<CentroCusto>>().having(
            (event) => event.id,
            'id',
            centro.id, //
          ),
        ),
      );

      await repository.delete(centro.id);

      await eventExpectation;
    });
  });
}
