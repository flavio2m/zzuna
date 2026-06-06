import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class RegisterViewModel {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository);

  late final registerCommand = Command1(_register);

  AsyncResult<LoggedUser> _register(RegisterUserDto dto) {
    return _authRepository.registerUser(dto);
  }
}
