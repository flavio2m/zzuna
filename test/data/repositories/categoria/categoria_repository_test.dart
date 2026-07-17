import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('CategoriaRepository', () {
    test('create saves a categoria when descricao does not exist', () async {
      final dto = CategoriaDto(descricao: 'Alimentação', ativo: true);

      final result = await repository.create(dto);
      final categorias = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      final list = categorias.getOrThrow();
      expect(list.any((c) => c.descricao == 'Alimentação'), isTrue);
    });

    test(
      'create returns failure when descricao already exists at the same level',
      () async {
        final dto = CategoriaDto(descricao: 'Alimentação');

        await repository.create(dto);

        final result = await repository.create(
          CategoriaDto(descricao: 'Alimentação'), //
        );

        expect(result.isError(), isTrue);
      },
    );

    test(
      'create succeeds when descricao already exists at a different level',
      () async {
        final p1 = await repository.create(
          CategoriaDto(descricao: 'Transporte'),
        );
        final p2 = await repository.create(CategoriaDto(descricao: 'Viagem'));

        await repository.create(
          CategoriaDto(
            descricao: 'Combustível',
            categoriaPaiId: p1.getOrThrow().id,
          ),
        );

        final result = await repository.create(
          CategoriaDto(
            descricao: 'Combustível',
            categoriaPaiId: p2.getOrThrow().id,
          ), //
        );

        expect(result.isSuccess(), isTrue);
      },
    );

    test('create permits maximum 2 levels of hierarchy', () async {
      // Level 1
      final parentResult = await repository.create(
        CategoriaDto(descricao: 'Alimentação'), //
      );
      expect(parentResult.isSuccess(), isTrue);
      final parent = parentResult.getOrThrow();

      // Level 2 (Subcategory)
      final subResult = await repository.create(
        CategoriaDto(descricao: 'Restaurante', categoriaPaiId: parent.id), //
      );
      expect(subResult.isSuccess(), isTrue);
      final sub = subResult.getOrThrow();

      // Level 3 (Invalid sub-subcategory)
      final subSubResult = await repository.create(
        CategoriaDto(descricao: 'Fast Food', categoriaPaiId: sub.id), //
      );
      expect(subSubResult.isError(), isTrue);
    });

    test(
      'update returns failure when new descricao already exists at the same level',
      () async {
        await repository.create(CategoriaDto(descricao: 'Transporte'));
        final created = await repository.create(
          CategoriaDto(descricao: 'Viagem'),
        );

        final result = await repository.update(
          CategoriaDto(
            id: created.getOrThrow().id,
            descricao: 'Transporte',
            ativo: true,
          ),
        );

        expect(result.isError(), isTrue);
      },
    );

    test('update changes an existing categoria', () async {
      final created = await repository.create(
        CategoriaDto(descricao: 'Original'), //
      );

      final categoria = created.getOrThrow();

      final result = await repository.update(
        CategoriaDto(id: categoria.id, descricao: 'Atualizado', ativo: false),
      );

      final saved = await repository.getById(categoria.id);

      expect(result.isSuccess(), isTrue);
      expect(saved.getOrThrow().descricao, 'Atualizado');
      expect(saved.getOrThrow().ativo, false);
    });

    test('delete removes an existing categoria', () async {
      final created = await repository.create(
        CategoriaDto(descricao: 'Temp'), //
      );

      final result = await repository.delete(created.getOrThrow().id);

      expect(result.isSuccess(), isTrue);
    });

    test('observer emits RepositoryCreated after create succeeds', () async {
      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<Categoria>>()), //
      );

      await repository.create(
        CategoriaDto(descricao: 'Stream'), //
      );

      await eventExpectation;
    });

    test('observer emits RepositoryUpdated after update succeeds', () async {
      final created = await repository.create(
        CategoriaDto(descricao: 'Stream'), //
      );

      final categoria = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<Categoria>>()), //
      );

      await repository.update(
        CategoriaDto(id: categoria.id, descricao: 'Stream Upd'), //
      );

      await eventExpectation;
    });

    test('observer emits RepositoryDeleted after delete succeeds', () async {
      final created = await repository.create(
        CategoriaDto(descricao: 'Stream'), //
      );

      final categoria = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(
          isA<RepositoryDeleted<Categoria>>().having(
            (event) => event.id,
            'id',
            categoria.id, //
          ),
        ),
      );

      await repository.delete(categoria.id);

      await eventExpectation;
    });
  });
}
