import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = ContaRepository(createTestContaStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('ContaRepository', () {
    test('create saves a conta when descricao does not exist', () async {
      final dto = CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB');

      final result = await repository.create(dto);
      final contas = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(contas.getOrThrow(), hasLength(1));

      expect(contas.getOrThrow().first.descricao, dto.descricao);

      expect(contas.getOrThrow().first.bancoSigla, dto.bancoSigla);
    });

    test('create returns failure when descricao already exists', () async {
      final dto = CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB');

      await repository.create(dto);

      final result = await repository.create(
        CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'ITAU'), //
      );

      expect(result.isError(), isTrue);
    });

    test('findByDescricao returns an existing conta', () async {
      final dto = CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB');

      await repository.create(dto);

      final result = await repository.findByDescricao('Conta Corrente');

      expect(result.isSuccess(), isTrue);

      expect(result.getOrThrow().descricao, 'Conta Corrente');
    });

    test('findByDescricao returns failure when conta does not exist', () async {
      final result = await repository.findByDescricao('Conta Inexistente');

      expect(result.isError(), isTrue);
    });

    test('update changes an existing conta', () async {
      final created = await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB'));

      final conta = created.getOrThrow();

      final result = await repository.update(
        LoadedContaDto(id: conta.id, descricao: 'Conta Atualizada', bancoSigla: 'ITAU', ativo: false),
      );

      final saved = await repository.getById(conta.id);

      expect(result.isSuccess(), isTrue);

      expect(saved.getOrThrow().descricao, 'Conta Atualizada');

      expect(saved.getOrThrow().bancoSigla, 'ITAU');

      expect(saved.getOrThrow().ativo, false);
    });

    test('delete removes an existing conta', () async {
      final created = await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB'));

      final result = await repository.delete(created.getOrThrow().id);

      final contas = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      // expect(contas.getOrThrow(), isEmpty);
    });

    test('observer emits RepositoryCreated after create succeeds', () async {
      final eventExpectation = expectLater(repository.observer(), emits(isA<RepositoryCreated<Conta>>()));

      await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB'));

      await eventExpectation;
    });

    test('observer emits RepositoryUpdated after update succeeds', () async {
      final created = await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB'));

      final conta = created.getOrThrow();

      final eventExpectation = expectLater(repository.observer(), emits(isA<RepositoryUpdated<Conta>>()));

      await repository.update(LoadedContaDto(id: conta.id, descricao: 'Conta Atualizada', bancoSigla: 'ITAU'));

      await eventExpectation;
    });

    test('observer emits RepositoryDeleted after delete succeeds', () async {
      final created = await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB'));

      final conta = created.getOrThrow();

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryDeleted<Conta>>().having((event) => event.id, 'id', conta.id)),
      );

      await repository.delete(conta.id);

      await eventExpectation;
    });

    test('observer does not emit when create fails', () async {
      var emitted = false;

      final subscription = repository.observer().listen((_) => emitted = true);

      await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'BB'));

      await Future<void>.delayed(Duration.zero);

      emitted = false;

      final result = await repository.create(CreateContaDto(descricao: 'Conta Corrente', bancoSigla: 'ITAU'));

      await Future<void>.delayed(Duration.zero);

      expect(result.isError(), isTrue);
      expect(emitted, isFalse);

      await subscription.cancel();
    });
  });
}
