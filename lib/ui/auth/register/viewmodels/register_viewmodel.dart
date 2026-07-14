import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/domain/usecases/seed/seed_initial_data_usecase.dart';

class RegisterViewModel {
  final AuthRepository _authRepository;
  final SeedInitialDataUseCase _seedInitialDataUseCase;

  RegisterViewModel(this._authRepository, this._seedInitialDataUseCase);

  late final registerCommand = Command1(_register);

  AsyncResult<LoggedUser> _register(RegisterUserDto dto) async {
    final result = await _authRepository.registerUser(dto);

    return result.fold((user) async {
      // if (dotenv.env['USE_LOCAL_STORAGE'] != 'true') {
      await _seedInitialDataUseCase.execute();
      // }
      return Success(user);
    }, (error) => Failure(error));
  }
}
