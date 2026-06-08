import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_storage.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    final storage = createTestUserStorage();

    container = ProviderContainer(overrides: [userStorageProvider.overrideWithValue(storage)]);
  });

  tearDown(() {
    container.dispose();
  });

  group('userProvider', () {
    test('starts with NotLoggedUser', () async {
      final users = <User>[];

      container.listen(userProvider, (_, next) {
        final user = next.valueOrNull;

        if (user != null) {
          users.add(user);
        }
      }, fireImmediately: true);

      await Future<void>.delayed(Duration.zero);

      expect(users, [isA<NotLoggedUser>()]);
    });

    test('updates user when auth stream emits LoggedUser', () async {
      final users = <User>[];

      final authRepository = container.read(authRepositoryProvider);

      container.listen(userProvider, (_, next) {
        final user = next.valueOrNull;

        if (user != null) {
          users.add(user);
        }
      }, fireImmediately: true);

      final result = await authRepository.registerUser(
        RegisterUserDto(name: 'New User', email: 'new@example.com', password: 'Aa123456!'),
      );

      expect(result.isSuccess(), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(users, [isA<NotLoggedUser>(), isA<LoggedUser>().having((user) => user.email, 'email', 'new@example.com')]);
    });

    test('updates user to NotLoggedUser on logout', () async {
      final users = <User>[];

      final authRepository = container.read(authRepositoryProvider);

      container.listen(userProvider, (_, next) {
        final user = next.valueOrNull;

        if (user != null) {
          users.add(user);
        }
      }, fireImmediately: true);

      final registerResult = await authRepository.registerUser(
        RegisterUserDto(name: 'New User', email: 'new@example.com', password: 'Aa123456!'),
      );

      expect(registerResult.isSuccess(), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final logoutResult = await authRepository.logout();

      expect(logoutResult.isSuccess(), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(users, [isA<NotLoggedUser>(), isA<LoggedUser>(), isA<NotLoggedUser>()]);
    });
  });
}
