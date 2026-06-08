import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/data/services/auth/local/auth_local_client.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late UserRepository userRepository;
  late AuthRepository authRepository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    final storage = createTestUserStorage();

    userRepository = UserRepository(storage);

    authRepository = AuthRepository(AuthLocalClient(storage), userRepository);
  });

  tearDown(() {
    authRepository.dispose();
    userRepository.dispose();
  });

  group('AuthRepository', () {
    test('login emits LoggedUser when credentials are valid', () async {
      final user = createTestUser(email: 'test@example.com');

      await userRepository.create(
        RegisterUserDto(id: user.id, name: user.name, email: user.email, password: 'Aa123456!'),
      );

      final eventExpectation = expectLater(
        authRepository.userObserver(),
        emits(isA<LoggedUser>().having((event) => event.id, 'id', user.id)),
      );

      final result = await authRepository.login(Credentials(email: user.email, password: 'Aa123456!'));

      expect(result.isSuccess(), isTrue);

      await eventExpectation;
    });

    test('registerUser creates user and emits LoggedUser', () async {
      final userEventExpectation = expectLater(userRepository.observer(), emits(isA<RepositoryCreated<LoadedUser>>()));

      final authEventExpectation = expectLater(authRepository.userObserver(), emits(isA<LoggedUser>()));

      final result = await authRepository.registerUser(
        RegisterUserDto(name: 'New User', email: 'new@example.com', password: 'Aa123456!'),
      );

      final usersResult = await userRepository.getAll();

      expect(result.isSuccess(), isTrue);

      expect(usersResult.getOrThrow(), hasLength(1));

      expect(usersResult.getOrThrow().first.id, result.getOrThrow().id);

      expect(usersResult.getOrThrow().first.email, 'new@example.com');

      await userEventExpectation;
      await authEventExpectation;
    });

    test('registerUser fails with invalid credentials and does not create user', () async {
      final result = await authRepository.registerUser(
        RegisterUserDto(name: 'Invalid User', email: 'invalid-email', password: 'weak'),
      );

      final usersResult = await userRepository.getAll();

      expect(result.isError(), isTrue);

      expect(usersResult.getOrThrow(), isEmpty);
    });

    test('registerUser fails when email already exists', () async {
      await authRepository.registerUser(
        RegisterUserDto(name: 'First User', email: 'duplicated@example.com', password: 'Aa123456!'),
      );

      final result = await authRepository.registerUser(
        RegisterUserDto(name: 'Second User', email: 'duplicated@example.com', password: 'Aa123456!'),
      );

      final usersResult = await userRepository.getAll();

      expect(result.isError(), isTrue);

      expect(usersResult.getOrThrow(), hasLength(1));
    });

    test('updateUser updates user and emits events', () async {
      final user = createTestUser(id: 'user-1', name: 'Original User', email: 'original@example.com');

      await userRepository.create(
        RegisterUserDto(id: user.id, name: user.name, email: user.email, password: 'Aa123456!'),
      );

      final userEventExpectation = expectLater(
        userRepository.observer(),
        emits(isA<RepositoryUpdated<LoadedUser>>().having((event) => event.model.name, 'name', 'Updated User')),
      );

      final authEventExpectation = expectLater(
        authRepository.userObserver(),
        emits(
          isA<LoggedUser>()
              .having((event) => event.name, 'name', 'Updated User')
              .having((event) => event.email, 'email', 'ignored@example.com'),
        ),
      );

      final result = await authRepository.updateUser(
        LoadedUserDto(id: user.id, name: 'Updated User', email: 'ignored@example.com'),
      );

      final savedUser = await userRepository.getById(user.id);

      expect(result.isSuccess(), isTrue);

      expect(result.getOrThrow().name, 'Updated User');

      expect(result.getOrThrow().email, 'ignored@example.com');

      expect(savedUser.getOrThrow().name, 'Updated User');

      expect(savedUser.getOrThrow().email, 'ignored@example.com');

      await userEventExpectation;
      await authEventExpectation;
    });

    test('logout emits NotLoggedUser', () async {
      final eventExpectation = expectLater(authRepository.userObserver(), emits(isA<NotLoggedUser>()));

      final result = await authRepository.logout();

      expect(result.isSuccess(), isTrue);

      await eventExpectation;
    });
  });
}
