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
      final dto = createTestUserDto();

      final result = await repository.create(dto);
      final savedUsers = await repository.getAll();

      expect(result.isSuccess(), isTrue);

      expect(savedUsers.getOrThrow(), [LoadedUser(id: dto.id!, name: dto.name, email: dto.email)]);
    });

    test('create returns failure when email already exists', () async {
      final user = createTestUserDto();
      final duplicatedUser = createTestUserDto(id: 'user-2', email: user.email);

      await repository.create(user);

      final result = await repository.create(duplicatedUser);

      expect(result.isError(), isTrue);
    });

    test('findUserByEmail returns an existing user', () async {
      final dto = createTestUserDto(email: 'test@example.com');

      await repository.create(dto);

      final result = await repository.findUserByEmail('test@example.com');

      expect(result.isSuccess(), isTrue);

      expect(result.getOrThrow(), LoadedUser(id: dto.id!, name: dto.name, email: dto.email));
    });

    test('findUserByEmail returns failure when email does not exist', () async {
      final result = await repository.findUserByEmail('missing@example.com');

      expect(result.isError(), isTrue);
    });

    test('update changes an existing user', () async {
      final user = createTestUser();

      final updatedUser = user.copyWith(name: 'Updated User');

      await repository.create(createTestRegisterUserDto(user));

      final result = await repository.update(createTestLoadedUserDto(updatedUser));

      final savedUser = await repository.getById(user.id);

      expect(result.isSuccess(), isTrue);
      expect(savedUser.getOrThrow(), updatedUser);
    });

    test('delete removes an existing user', () async {
      final dto = createTestUserDto();

      final createdResult = await repository.create(dto);

      final result = await repository.delete(createdResult.getOrThrow().id);

      final usersResult = await repository.getAll();

      expect(result.isSuccess(), isTrue);
      expect(usersResult.getOrThrow(), isEmpty);
    });

    test('observer emits RepositoryCreated after create succeeds', () async {
      final dto = createTestUserDto();

      final expectedUser = LoadedUser(id: dto.id!, name: dto.name, email: dto.email);

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryCreated<LoadedUser>>().having((event) => event.model, 'model', expectedUser)),
      );

      await repository.create(dto);

      await eventExpectation;
    });

    test('observer emits RepositoryUpdated after update succeeds', () async {
      final user = createTestUser();

      final updatedUser = user.copyWith(name: 'Updated User');

      await repository.create(createTestRegisterUserDto(user));

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryUpdated<LoadedUser>>().having((event) => event.model, 'model', updatedUser)),
      );

      await repository.update(createTestLoadedUserDto(updatedUser));

      await eventExpectation;
    });

    test('observer emits RepositoryDeleted after delete succeeds', () async {
      final dto = createTestUserDto();

      final createdResult = await repository.create(dto);

      final eventExpectation = expectLater(
        repository.observer(),
        emits(isA<RepositoryDeleted<LoadedUser>>().having((event) => event.id, 'id', createdResult.getOrThrow().id)),
      );

      await repository.delete(createdResult.getOrThrow().id);

      await eventExpectation;
    });

    test('observer does not emit when create fails', () async {
      var emitted = false;

      final subscription = repository.observer().listen((_) {
        emitted = true;
      });

      final user = createTestUserDto();

      final duplicatedUser = createTestUserDto(id: 'user-2', email: user.email);

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
