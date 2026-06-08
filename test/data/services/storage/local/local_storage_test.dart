import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  });
}
