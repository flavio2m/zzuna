import 'package:zzuna/domain/dtos/register_user_dto.dart';
import 'package:lucid_validation/lucid_validation.dart';

class RegisterUserDtoValidator extends LucidValidator<RegisterUserDto> {
  RegisterUserDtoValidator() {
    ruleFor((dto) => dto.name, key: 'name').notEmpty().minLength(3);

    ruleFor((dto) => dto.email, key: 'email').notEmpty().validEmail();

    ruleFor(
      (dto) => dto.password,
      key: 'password',
    ).notEmpty().minLength(6).mustHaveLowercase().mustHaveUppercase().mustHaveNumber().mustHaveSpecialCharacter();
  }
}
