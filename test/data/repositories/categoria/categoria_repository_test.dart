import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';

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

    test(
      'create and update persist percentualOrcamento, natureza and cor correctly',
      () async {
        final dto = CategoriaDto(
          descricao: 'Custos Fixos',
          percentualOrcamento: 30,
          natureza: CategoriaNatureza.saida,
          cor: '#0084FF',
        );

        final result = await repository.create(dto);
        expect(result.isSuccess(), isTrue);
        final created = result.getOrThrow();
        expect(created.percentualOrcamento, equals(30));
        expect(created.natureza, equals(CategoriaNatureza.saida));
        expect(created.cor, equals('#0084FF'));

        final updateDto = CategoriaDto(
          id: created.id,
          descricao: 'Custos Fixos Atualizado',
          percentualOrcamento: 35,
          natureza: CategoriaNatureza.saida,
          cor: '#7C6DF2',
        );

        final updateResult = await repository.update(updateDto);
        expect(updateResult.isSuccess(), isTrue);
        final updated = updateResult.getOrThrow();
        expect(updated.percentualOrcamento, equals(35));
        expect(updated.descricao, equals('Custos Fixos Atualizado'));
        expect(updated.cor, equals('#7C6DF2'));
      },
    );
  });
}
