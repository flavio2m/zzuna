import 'package:zzuna/domain/dtos/credentials.dart';
import 'package:zzuna/domain/dtos/register_user_dto.dart';
import 'package:zzuna/domain/dtos/update_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AuthClientBase {
  AsyncResult<LoggedUser> login(Credentials credentials);
  AsyncResult<Unit> logout();
  AsyncResult<LoggedUser> registerUser(RegisterUserDto dto);
  AsyncResult<LoggedUser> updateUser(UpdateUserDto dto);
}
