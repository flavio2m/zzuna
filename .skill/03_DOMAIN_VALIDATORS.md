# VALIDATORS

## Use quando

* Validar DTOs
* Validar formulários

## Regras

* Nome termina com `Validator`
* Um Validator para cada DTO
* Estende `LucidValidator<T>`
* Todo `ruleFor()` deve possuir `key`
* Encadear validações do mesmo campo
* Criar em `domain/validators`

## Padrão

`key` deve ser o nome da propriedade do DTO.

```dart
ruleFor((dto) => dto.email, key: 'email')
```

O Validator deve ser compatível com:

```dart
validator.byField(dto, 'email')
validator.validate(dto)
```

## Não fazer

* Regras de negócio
* HTTP
* Services
* Repositories
* UseCases
* Widgets
* Estado de UI

## Template

```dart
import 'package:lucid_validation/lucid_validation.dart';

class ExampleDtoValidator extends LucidValidator<ExampleDto> {
  ExampleDtoValidator() {
    ruleFor((dto) => dto.field, key: 'field')
        .notEmpty();
  }
}
```

## Exemplo

```dart
class RegisterUserDtoValidator
    extends LucidValidator<RegisterUserDto> {

  RegisterUserDtoValidator() {
    ruleFor((dto) => dto.name, key: 'name')
        .notEmpty()
        .minLength(3);

    ruleFor((dto) => dto.email, key: 'email')
        .notEmpty()
        .validEmail();

    ruleFor((dto) => dto.password, key: 'password')
        .notEmpty()
        .minLength(6);
  }
}
```
