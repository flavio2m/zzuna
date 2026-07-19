import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';

class UserSeed {
  final AuthRepository authRepository;

  UserSeed(this.authRepository);

  Future<void> execute() async {
    final dto = RegisterUserDto(
      name: 'Teste',
      email: 'teste1@gmail.com',
      password: 'teste1@gmail.comT',
    );
    
    final result = await authRepository.registerUser(dto);
    if (result.isError()) {
      // O usuário pode já existir
    }
  }
}
