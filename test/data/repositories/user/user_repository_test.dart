import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late UserRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = UserRepository(createTestUserStorage());
  });

  tearDown(() {
    repository.dispose();
  });

  group('UserRepository', () {
    test('create saves a user when email does not exist', () async {
      final user = createTestUser();

      final result = await repository.create(user);
      final savedUsers = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(savedUsers.getOrThrow(), [user]);
    });

    test('create returns failure when email already exists', () async {
      final user = createTestUser();
      final duplicatedUser = createTestUser(id: 'user-2', email: user.email);

      await repository.create(user);
      final result = await repository.create(duplicatedUser);

      expect(result.isError(), isTrue);
    });

    test('findUserByEmail returns an existing user', () async {
      final user = createTestUser(email: 'test@example.com');

      await repository.create(user);
      final result = await repository.findUserByEmail('test@example.com');

      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), user);
    });

    test('findUserByEmail returns failure when email does not exist', () async {
      final result = await repository.findUserByEmail('missing@example.com');

      expect(result.isError(), isTrue);
    });

    test('update changes an existing user', () async {
      final user = createTestUser();
      final updatedUser = user.copyWith(name: 'Updated User');

      await repository.create(user);
      final result = await repository.update(updatedUser);
      final savedUser = await repository.getById(user.id);

      expect(result.isSuccess(), isTrue);
      expect(savedUser.getOrThrow(), updatedUser);
    });

    test('delete removes an existing user', () async {
      final user = createTestUser();

      await repository.create(user);
      final result = await repository.delete(user.id);
      final usersResult = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(usersResult.getOrThrow(), isEmpty);
    });

    test('observer emits RepositoryCreated after create succeeds', () async {
      final user = createTestUser();
      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<LoadedUser>>().having((event) => event.model, 'model', user)),
      );

      await repository.create(user);

      await eventExpectation;
    });

    test('observer emits RepositoryUpdated after update succeeds', () async {
      final user = createTestUser();
      final updatedUser = user.copyWith(name: 'Updated User');

      await repository.create(user);
      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<LoadedUser>>().having((event) => event.model, 'model', updatedUser)),
      );

      await repository.update(updatedUser);

      await eventExpectation;
    });

    test('observer emits RepositoryDeleted after delete succeeds', () async {
      final user = createTestUser();

      await repository.create(user);
      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryDeleted<LoadedUser>>().having((event) => event.id, 'id', user.id)),
      );

      await repository.delete(user.id);

      await eventExpectation;
    });

    test('observer does not emit when create fails', () async {
      var emitted = false;
      final subscription = repository.observer().listen((_) {
        emitted = true;
      });
      final user = createTestUser();
      final duplicatedUser = createTestUser(id: 'user-2', email: user.email);

      await repository.create(user);
      await Future<void>.delayed(Duration.zero);
      emitted = false;
      final result = await repository.create(duplicatedUser);
      await Future<void>.delayed(Duration.zero);

      expect(result.isError(), isTrue);
      expect(emitted, isFalse);

      await subscription.cancel();
    });
  });
}
