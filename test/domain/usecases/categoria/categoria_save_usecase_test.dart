import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_save_usecase.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;
  late CategoriaSaveUseCase useCase;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
    useCase = CategoriaSaveUseCase(repository);
  });

  tearDown(() {
    repository.dispose();
  });

  Future<Categoria> criar(CategoriaDto dto) async =>
      (await useCase.create(dto)).getOrThrow();

  Future<Categoria> buscar(String id) async =>
      (await repository.getById(id)).getOrThrow();

  group('CategoriaSaveUseCase - validações', () {
    test('create salva categoria quando descrição não existe', () async {
      final result = await useCase.create(
        CategoriaDto(descricao: 'Alimentação'),
      );

      expect(result.isSuccess(), isTrue);
      final todas = (await repository.getAll()).getOrThrow();
      expect(todas.any((c) => c.descricao == 'Alimentação'), isTrue);
    });

    test('create falha quando descrição já existe no mesmo nível', () async {
      await criar(CategoriaDto(descricao: 'Alimentação'));

      final result = await useCase.create(
        CategoriaDto(descricao: '  alimentação '),
      );

      expect(result.exceptionOrNull(), isA<DomainException>());
    });

    test('create permite mesma descrição em níveis diferentes', () async {
      final p1 = await criar(CategoriaDto(descricao: 'Transporte'));
      final p2 = await criar(CategoriaDto(descricao: 'Viagem'));
      await criar(
        CategoriaDto(descricao: 'Combustível', categoriaPaiId: p1.id),
      );

      final result = await useCase.create(
        CategoriaDto(descricao: 'Combustível', categoriaPaiId: p2.id),
      );

      expect(result.isSuccess(), isTrue);
    });

    test('create permite no máximo 2 níveis', () async {
      final pai = await criar(CategoriaDto(descricao: 'Alimentação'));
      final filha = await criar(
        CategoriaDto(descricao: 'Restaurante', categoriaPaiId: pai.id),
      );

      final result = await useCase.create(
        CategoriaDto(descricao: 'Fast Food', categoriaPaiId: filha.id),
      );

      expect(result.exceptionOrNull(), isA<DomainException>());
    });

    test('create falha quando categoria pai não existe', () async {
      final result = await useCase.create(
        CategoriaDto(descricao: 'Órfã', categoriaPaiId: 'inexistente'),
      );

      expect(result.exceptionOrNull(), isA<DomainException>());
      expect((await repository.getAll()).getOrThrow(), isEmpty);
    });

    test('update falha quando descrição já existe no mesmo nível', () async {
      await criar(CategoriaDto(descricao: 'Transporte'));
      final viagem = await criar(CategoriaDto(descricao: 'Viagem'));

      final result = await useCase.update(
        CategoriaDto(id: viagem.id, descricao: 'Transporte'),
      );

      expect(result.exceptionOrNull(), isA<DomainException>());
    });

    test('update permite manter a própria descrição', () async {
      final cat = await criar(CategoriaDto(descricao: 'Lazer'));

      final result = await useCase.update(
        CategoriaDto(id: cat.id, descricao: 'Lazer', percentualOrcamento: 10),
      );

      expect(result.isSuccess(), isTrue);
    });

    test('update falha quando categoria é pai dela mesma', () async {
      final cat = await criar(CategoriaDto(descricao: 'Lazer'));

      final result = await useCase.update(
        CategoriaDto(id: cat.id, descricao: 'Lazer', categoriaPaiId: cat.id),
      );

      expect(result.exceptionOrNull(), isA<DomainException>());
    });

    test(
      'update falha ao tornar subcategoria uma categoria que possui filhas',
      () async {
        final destino = await criar(CategoriaDto(descricao: 'Casa'));
        final pai = await criar(CategoriaDto(descricao: 'Habitação'));
        await criar(CategoriaDto(descricao: 'Aluguel', categoriaPaiId: pai.id));

        final result = await useCase.update(
          CategoriaDto(
            id: pai.id,
            descricao: 'Habitação',
            categoriaPaiId: destino.id,
          ),
        );

        expect(result.exceptionOrNull(), isA<DomainException>());
        expect((await buscar(pai.id)).categoriaPaiId, isNull);
      },
    );

    test('update falha quando id não é informado', () async {
      final result = await useCase.update(CategoriaDto(descricao: 'Sem id'));

      expect(result.exceptionOrNull(), isA<DomainException>());
    });
  });

  group('CategoriaSaveUseCase - hierarquia de status', () {
    test('desativar categoria pai desativa todas as filhas', () async {
      final pai = await criar(CategoriaDto(descricao: 'Habitação'));
      final f1 = await criar(
        CategoriaDto(descricao: 'Aluguel', categoriaPaiId: pai.id),
      );
      final f2 = await criar(
        CategoriaDto(descricao: 'Condomínio', categoriaPaiId: pai.id),
      );

      final result = await useCase.update(
        CategoriaDto(id: pai.id, descricao: 'Habitação', ativo: false),
      );

      expect(result.isSuccess(), isTrue);
      expect((await buscar(pai.id)).ativo, isFalse);
      expect((await buscar(f1.id)).ativo, isFalse);
      expect((await buscar(f2.id)).ativo, isFalse);
    });

    test('ativar filha com pai inativo ativa o pai', () async {
      final pai = await criar(
        CategoriaDto(descricao: 'Transporte', ativo: false),
      );
      final filha = await criar(
        CategoriaDto(
          descricao: 'Combustível',
          categoriaPaiId: pai.id,
          ativo: false,
        ),
      );

      final result = await useCase.update(
        CategoriaDto(
          id: filha.id,
          descricao: 'Combustível',
          categoriaPaiId: pai.id,
          ativo: true,
        ),
      );

      expect(result.isSuccess(), isTrue);
      expect((await buscar(pai.id)).ativo, isTrue);
      expect((await buscar(filha.id)).ativo, isTrue);
    });

    test('criar filha ativa sob pai inativo ativa o pai', () async {
      final pai = await criar(CategoriaDto(descricao: 'Saúde', ativo: false));

      final result = await useCase.create(
        CategoriaDto(descricao: 'Farmácia', categoriaPaiId: pai.id),
      );

      expect(result.isSuccess(), isTrue);
      expect((await buscar(pai.id)).ativo, isTrue);
    });

    test('desativar filha não altera o pai', () async {
      final pai = await criar(CategoriaDto(descricao: 'Lazer'));
      final filha = await criar(
        CategoriaDto(descricao: 'Cinema', categoriaPaiId: pai.id),
      );

      await useCase.update(
        CategoriaDto(
          id: filha.id,
          descricao: 'Cinema',
          categoriaPaiId: pai.id,
          ativo: false,
        ),
      );

      expect((await buscar(pai.id)).ativo, isTrue);
      expect((await buscar(filha.id)).ativo, isFalse);
    });

    test('validação com falha não grava nada nem altera o pai', () async {
      final pai = await criar(CategoriaDto(descricao: 'Saúde', ativo: false));
      await criar(
        CategoriaDto(
          descricao: 'Farmácia',
          categoriaPaiId: pai.id,
          ativo: false,
        ),
      );

      final result = await useCase.create(
        CategoriaDto(descricao: 'Farmácia', categoriaPaiId: pai.id),
      );

      expect(result.isError(), isTrue);
      expect((await buscar(pai.id)).ativo, isFalse);
    });
  });
}
