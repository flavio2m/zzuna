import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/enums/mes.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late LancamentoRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LancamentoRepository(createTestLancamentoStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('LancamentoRepository', () {
    test('create saves a lancamento successfully', () async {
      final dto = LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 18),
        descricao: 'Supermercado',
        origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
        extratoFaturaId: 'ef-1',
        itens: const [],
        conciliado: false,
        observacao: 'Compra mensal',
      );

      final result = await repository.create(dto);
      final lancamentos = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(lancamentos.getOrThrow(), hasLength(1));
      expect(lancamentos.getOrThrow().first.descricao, 'Supermercado');
    });

    test('update changes an existing lancamento', () async {
      final created = await repository.create(
        LancamentoDto(tipo: LancamentoTipo.receita, data: DateTime(2026, 6, 18), descricao: 'Salário'),
      );

      final model = created.getOrThrow();

      final result = await repository.update(
        LancamentoDto(
          id: model.id,
          tipo: LancamentoTipo.receita,
          data: DateTime(2026, 6, 18),
          descricao: 'Salário Atualizado',
          conciliado: true,
          observacao: 'Bônus',
        ),
      );

      final saved = await repository.getById(model.id);

      expect(result.isSuccess(), isTrue);
      expect(saved.getOrThrow().descricao, 'Salário Atualizado');
      expect(saved.getOrThrow().conciliado, isTrue);
      expect(saved.getOrThrow().observacao, 'Bônus');
    });

    test('delete removes an existing lancamento', () async {
      final created = await repository.create(
        LancamentoDto(tipo: LancamentoTipo.despesa, data: DateTime(2026, 6, 18), descricao: 'Lanche'),
      );

      final model = created.getOrThrow();
      final result = await repository.delete(model.id);

      expect(result.isSuccess(), isTrue);
    });

    test('getById returns the correct lancamento', () async {
      final created = await repository.create(LancamentoDto(descricao: 'Luz'));

      final model = created.getOrThrow();
      final result = await repository.getById(model.id);

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow().descricao, 'Luz');
    });

    test('search filters by descricao', () async {
      await repository.create(LancamentoDto(descricao: 'Supermercado', data: DateTime(2026, 6, 15)));
      await repository.create(LancamentoDto(descricao: 'Combustível', data: DateTime(2026, 6, 16)));

      final searchResult = await repository.search(
        LancamentoFilterDto(descricao: 'Super', mes: Mes.junho, ano: 2026), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.descricao, 'Supermercado');
    });

    test('search filters by tipo', () async {
      await repository.create(
        LancamentoDto(descricao: 'A', tipo: LancamentoTipo.receita, data: DateTime(2026, 6, 15)), //
      );
      await repository.create(
        LancamentoDto(descricao: 'B', tipo: LancamentoTipo.despesa, data: DateTime(2026, 6, 16)), //
      );

      final searchResult = await repository.search(
        LancamentoFilterDto(tipo: LancamentoTipo.receita, mes: Mes.junho, ano: 2026), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.descricao, 'A');
    });

    test('search filters by conciliado', () async {
      await repository.create(
        LancamentoDto(descricao: 'A', conciliado: true, data: DateTime(2026, 6, 15)), //
      );
      await repository.create(
        LancamentoDto(descricao: 'B', conciliado: false, data: DateTime(2026, 6, 16)), //
      );

      final searchResult = await repository.search(
        LancamentoFilterDto(conciliado: true, mes: Mes.junho, ano: 2026), //
      );

      expect(searchResult.getOrThrow(), hasLength(1));
      expect(searchResult.getOrThrow().first.descricao, 'A');
    });

    test('observer emits RepositoryCreated after create', () async {
      final expectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<Lancamento>>()), //
      );

      await repository.create(LancamentoDto(descricao: 'A'));

      await expectation;
    });

    test('observer emits RepositoryUpdated after update', () async {
      final created = await repository.create(LancamentoDto(descricao: 'A'));
      final model = created.getOrThrow();

      final expectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<Lancamento>>()), //
      );

      await repository.update(
        LancamentoDto(id: model.id, descricao: 'B'), //
      );

      await expectation;
    });

    test('observer emits RepositoryDeleted after delete', () async {
      final created = await repository.create(LancamentoDto(descricao: 'A'));
      final model = created.getOrThrow();

      final expectation = expectLater(
        repository.observer(),
        emits(
          isA<RepositoryDeleted<Lancamento>>().having(
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

  test('getById returns failure when id does not exist', () async {
    final result = await repository.getById('inexistente');

    expect(result.isError(), isTrue);
  });

  test('update returns failure when id does not exist', () async {
    final result = await repository.update(LancamentoDto(id: 'inexistente', descricao: 'Teste'));

    expect(result.isError(), isTrue);
  });

  test('delete returns failure when id does not exist', () async {
    final result = await repository.delete('inexistente');

    expect(result.isError(), isTrue);
  });
}
