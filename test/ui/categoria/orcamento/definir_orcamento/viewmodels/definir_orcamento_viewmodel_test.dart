import 'package:flutter_test/flutter_test.dart';
import 'package:result_command/result_command.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/data/services/auth/local/auth_local_client.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/ui/categoria/orcamento/definir_orcamento/viewmodels/definir_orcamento_viewmodel.dart';

import '../../../../../helpers/test_storage.dart';

void main() {
  late UserRepository userRepository;
  late AuthRepository authRepository;
  late DefinirOrcamentoViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final userStorage = createTestUserStorage();

    userRepository = UserRepository(userStorage);
    authRepository = AuthRepository(
      AuthLocalClient(userStorage),
      userRepository,
    );

    viewModel = DefinirOrcamentoViewModel(authRepository);
  });

  tearDown(() {
    authRepository.dispose();
    userRepository.dispose();
  });

  group('DefinirOrcamentoViewModel', () {
    test(
      'updateOrcamentoCommand updates budget and emits to auth observer',
      () async {
        final registerResult = await authRepository.registerUser(
          RegisterUserDto(
            name: 'Flávio',
            email: 'flavio@example.com',
            password: 'Aa123456!',
          ),
        );
        expect(registerResult.isSuccess(), isTrue);
        final loggedUser = registerResult.getOrThrow();
        expect(loggedUser.orcamento, 0.0);

        final observerExpectation = expectLater(
          authRepository.userObserver(),
          emits(
            isA<LoggedUser>()
                .having((u) => u.orcamento, 'orcamento', 7500.0)
                .having((u) => u.email, 'email', 'flavio@example.com'),
          ),
        );

        await viewModel.updateOrcamentoCommand.execute((
          user: loggedUser,
          orcamento: 7500.0,
        ));

        expect(viewModel.updateOrcamentoCommand.value.isSuccess, isTrue);
        final updatedUser =
            (viewModel.updateOrcamentoCommand.value
                    as SuccessCommand<LoggedUser>)
                .value;
        expect(updatedUser.orcamento, 7500.0);
        await observerExpectation;
      },
    );
  });
}
