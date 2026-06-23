import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/enums/mes.dart';

import '../../../../helpers/test_storage.dart';

void main() {
  late int collectionCounter;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    collectionCounter = 0;
  });

  String nextCollectionName() => 'users_${collectionCounter++}';

  group('LocalStorage', () {
    test('create saves an item and getAll returns it', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());
      final user = createTestUser();

      final createResult = await storage.create(user);
      final listResult = await storage.getAll();

      expect(createResult.isSuccess(), isTrue);
      expect(listResult.isSuccess(), isTrue);
      expect(listResult.getOrThrow(), [user]);
    });

    test('getById returns the item when id exists', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());
      final user = createTestUser(id: 'user-1');

      await storage.create(user);
      final result = await storage.getById('user-1');

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), user);
    });

    test('getById returns failure when id does not exist', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());

      final result = await storage.getById('missing-id');

      expect(result.isError(), isTrue);
    });

    test('update replaces the existing item', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());
      final user = createTestUser();
      final loadedUserDto = user.copyWith(name: 'Updated User');

      await storage.create(user);
      final updateResult = await storage.update(loadedUserDto);
      final savedResult = await storage.getById(user.id);

      expect(updateResult.isSuccess(), isTrue);
      expect(savedResult.getOrThrow(), loadedUserDto);
    });

    test('update returns failure when id does not exist', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());

      final result = await storage.update(createTestUser(id: 'missing-id'));

      expect(result.isError(), isTrue);
    });

    test('delete removes an existing item', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());
      final user = createTestUser();

      await storage.create(user);
      final deleteResult = await storage.delete(user.id);
      final listResult = await storage.getAll();

      expect(deleteResult.isSuccess(), isTrue);
      expect(listResult.getOrThrow(), isEmpty);
    });

    test('delete returns failure when id does not exist', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());

      final result = await storage.delete('missing-id');

      expect(result.isError(), isTrue);
    });

    test('searchByFields finds a user by email', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());
      final user = createTestUser(email: 'test@example.com');

      await storage.create(user);
      final result = await storage.searchByFields([
        SearchField(fieldName: 'email', value: 'test@example.com', type: SearchFieldType.string),
      ]);

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), [user]);
    });

    test('searchByFields is case-insensitive for strings', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());
      final user = createTestUser(email: 'Test@Example.com');

      await storage.create(user);
      final result = await storage.searchByFields([
        SearchField(fieldName: 'email', value: 'test@example.com', type: SearchFieldType.string),
      ]);

      expect(result.getOrThrow(), [user]);
    });

    test('getAll returns an empty list when storage is empty', () async {
      final storage = createTestUserStorage(collectionName: nextCollectionName());

      final result = await storage.getAll();

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), isEmpty);
    });

    test('searchByFields with operators, ordering, and limits', () async {
      final storage = createTestExtratoFaturaStorage(collectionName: nextCollectionName());
      const o1 = LancamentoOrigem.conta(contaId: 'c1');

      final ef1 = ExtratoFatura(
        id: 'ef-1',
        origem: o1,
        ano: 2025,
        mes: Mes.janeiro,
        dataInicio: DateTime(2025, 1, 1),
        dataFim: DateTime(2025, 1, 31),
        saldoInicial: 100.0,
        saldoFinal: 200.0,
        fechado: false,
        periodo: 202501,
        origemKey: 'conta_c1',
      );

      final ef2 = ExtratoFatura(
        id: 'ef-2',
        origem: o1,
        ano: 2026,
        mes: Mes.fevereiro,
        dataInicio: DateTime(2026, 2, 1),
        dataFim: DateTime(2026, 2, 28),
        saldoInicial: 200.0,
        saldoFinal: 300.0,
        fechado: false,
        periodo: 202602,
        origemKey: 'conta_c1',
      );

      final ef3 = ExtratoFatura(
        id: 'ef-3',
        origem: o1,
        ano: 2027,
        mes: Mes.marco,
        dataInicio: DateTime(2027, 3, 1),
        dataFim: DateTime(2027, 3, 31),
        saldoInicial: 300.0,
        saldoFinal: 400.0,
        fechado: false,
        periodo: 202703,
        origemKey: 'conta_c1',
      );

      await storage.create(ef1);
      await storage.create(ef2);
      await storage.create(ef3);

      // 1. Operator: greaterThanOrEqual
      final resGte = await storage.searchByFields([
        SearchField(
          fieldName: 'ano',
          value: 2026,
          type: SearchFieldType.int,
          operator: SearchOperator.greaterThanOrEqual,
        ),
      ]);
      expect(resGte.getOrThrow(), containsAll([ef2, ef3]));
      expect(resGte.getOrThrow(), isNot(contains(ef1)));

      // 2. Operator: between
      final resBetween = await storage.searchByFields([
        SearchField(
          fieldName: 'ano',
          value: const [2025, 2026],
          type: SearchFieldType.int,
          operator: SearchOperator.between,
        ),
      ]);
      expect(resBetween.getOrThrow(), containsAll([ef1, ef2]));
      expect(resBetween.getOrThrow(), isNot(contains(ef3)));

      // 3. Ordering: descending
      final resOrder = await storage.searchByFields(
        [],
        orderBy: 'ano',
        order: SearchOrder.descending,
      );
      expect(resOrder.getOrThrow(), [ef3, ef2, ef1]);

      // 4. Limit
      final resLimit = await storage.searchByFields(
        [],
        orderBy: 'ano',
        order: SearchOrder.ascending,
        limit: 2,
      );
      expect(resLimit.getOrThrow(), [ef1, ef2]);
    });
  });
}
