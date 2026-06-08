import 'package:zzuna/data/services/auth/local/auth_local_client.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/test_storage.dart';

void main() {
  late AuthLocalClient authClient;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    authClient = AuthLocalClient(createTestUserStorage());
  });

  group('AuthLocalClient', () {
    test('login returns LoggedUser when email exists in storage', () async {
      final storage = createTestUserStorage();

      final user = createTestUser(email: 'test@example.com');

      authClient = AuthLocalClient(storage);

      await storage.create(user);

      final result = await authClient.login(Credentials(email: user.email, password: 'anything'));

      expect(result.isSuccess(), isTrue);

      expect(result.getOrThrow().id, user.id);

      expect(result.getOrThrow().name, user.name);

      expect(result.getOrThrow().email, user.email);
    });

    test('login returns failure when email does not exist', () async {
      final result = await authClient.login(Credentials(email: 'missing@example.com', password: 'anything'));

      expect(result.isError(), isTrue);
    });

    test('registerUser returns LoggedUser with generated id', () async {
      final result = await authClient.registerUser(
        RegisterUserDto(name: 'New User', email: 'new@example.com', password: 'Aa123456!'),
      );

      expect(result.isSuccess(), isTrue);

      final user = result.getOrThrow();

      expect(user.id, isNotEmpty);

      expect(user.name, 'New User');

      expect(user.email, 'new@example.com');
    });

    test('updateUser returns LoggedUser with data from dto', () async {
      final result = await authClient.updateUser(
        LoadedUserDto(id: 'user-1', name: 'Updated User', email: 'updated@example.com'),
      );

      expect(result.isSuccess(), isTrue);

      expect(result.getOrThrow().id, 'user-1');

      expect(result.getOrThrow().name, 'Updated User');

      expect(result.getOrThrow().email, 'updated@example.com');
    });

    test('logout returns success', () async {
      final result = await authClient.logout();

      expect(result.isSuccess(), isTrue);
    });
  });
}
