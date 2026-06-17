import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late CartaoRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = CartaoRepository(createTestCartaoStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('CartaoRepository', () {
    test('create saves a cartao when descricao does not exist', () async {
      final dto = CartaoDto(
        descricao: 'Cartão Platinum',
        limite: 5000,
        bancoSigla: 'BB',
        ativo: true,
        diaFechamento: 10,
      );

      final result = await repository.create(dto);
      final cartoes = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      // getAll might seed if empty, and our newly created is added
      final list = cartoes.getOrThrow();
      expect(list.any((c) => c.descricao == 'Cartão Platinum'), isTrue);
    });

    test('create returns failure when descricao already exists', () async {
      final dto = CartaoDto(
        descricao: 'Cartão Platinum',
        limite: 5000,
        bancoSigla: 'BB',
      );

      await repository.create(dto);

      final result = await repository.create(
        CartaoDto(
          descricao: 'Cartão Platinum',
          limite: 2000,
          bancoSigla: 'ITAU', //
        ),
      );

      expect(result.isError(), isTrue);
    });

    test('findByDescricao returns an existing cartao', () async {
      final dto = CartaoDto(
        descricao: 'Cartão Gold',
        limite: 3000,
        bancoSigla: 'BB',
      );

      await repository.create(dto);

      final result = await repository.findByDescricao('Cartão Gold');

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow().descricao, 'Cartão Gold');
    });

    test('findByDescricao returns failure when cartao does not exist', () async {
      final result = await repository.findByDescricao('Cartão Inexistente');

      expect(result.isError(), isTrue);
    });

    test('update changes an existing cartao', () async {
      final created = await repository.create(
        CartaoDto(descricao: 'Cartão Original', limite: 1000, bancoSigla: 'BB'), //
      );

      final cartao = created.getOrThrow();

      final result = await repository.update(
        CartaoDto(
          id: cartao.id,
          descricao: 'Cartão Atualizado',
          limite: 1500,
          bancoSigla: 'ITAU',
          ativo: false,
          diaFechamento: 15,
        ),
      );

      final saved = await repository.getById(cartao.id);

      expect(result.isSuccess(), isTrue);
      expect(saved.getOrThrow().descricao, 'Cartão Atualizado');
      expect(saved.getOrThrow().limite, 1500);
      expect(saved.getOrThrow().bancoSigla, 'ITAU');
      expect(saved.getOrThrow().ativo, false);
      expect(saved.getOrThrow().diaFechamento, 15);
    });

    test('delete removes an existing cartao', () async {
      final created = await repository.create(
        CartaoDto(descricao: 'Cartão Temp', limite: 500, bancoSigla: 'BB'), //
      );

      final result = await repository.delete(created.getOrThrow().id);

      expect(result.isSuccess(), isTrue);
    });

    test('observer emits RepositoryCreated after create succeeds', () async {
      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<Cartao>>()), //
      );

      await repository.create(
        CartaoDto(descricao: 'Cartão Stream', limite: 100, bancoSigla: 'BB'), //
      );

      await eventExpectation;
    });

    test('observer emits RepositoryUpdated after update succeeds', () async {
      final created = await repository.create(
        CartaoDto(descricao: 'Cartão Stream', limite: 100, bancoSigla: 'BB'), //
      );

      final cartao = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<Cartao>>()), //
      );

      await repository.update(
        CartaoDto(
          id: cartao.id,
          descricao: 'Cartão Stream Upd',
          limite: 200,
          bancoSigla: 'BB',
        ),
      );

      await eventExpectation;
    });

    test('observer emits RepositoryDeleted after delete succeeds', () async {
      final created = await repository.create(
        CartaoDto(descricao: 'Cartão Stream', limite: 100, bancoSigla: 'BB'), //
      );

      final cartao = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(
          isA<RepositoryDeleted<Cartao>>().having(
            (event) => event.id,
            'id',
            cartao.id, //
          ),
        ),
      );

      await repository.delete(cartao.id);

      await eventExpectation;
    });
  });
}
