# VALIDATORS

## Use quando

* Validar DTOs
* Validar formulários

## Regras

* Nome termina com `Validator`
* Preferencialmente um Validator para cada contrato de validação
* Quando múltiplos DTOs possuírem exatamente as mesmas regras de validação, é permitido reutilizar um único Validator compartilhado
* Quando existir apenas um DTO para a entidade, utilizar:

  * `ContaValidator`
  * `CartaoValidator`
  * `CategoriaValidator`
* Quando existirem DTOs específicos com regras distintas, utilizar:

  * `CreateContaDtoValidator`
  * `LoadedContaDtoValidator`
  * `RegisterUserDtoValidator`
* Estende `LucidValidator<T>`
* Todo `ruleFor()` deve possuir `key`
* Encadear validações do mesmo campo
* Criar em `domain/validators`

## Estratégia de modelagem

Antes de criar Validators, analisar a estratégia adotada para os DTOs.

### Caso 1 - DTO único

Quando a entidade utiliza apenas um DTO:

```text
ContaDto
```

Criar apenas um Validator:

```text
ContaValidator
```

Exemplo:

```dart
class ContaValidator
    extends LucidValidator<ContaDto> {

  ContaValidator() {
    ruleFor(
      (dto) => dto.descricao,
      key: 'descricao',
    )
        .notEmpty()
        .minLength(2);

    ruleFor(
      (dto) => dto.bancoSigla,
      key: 'bancoSigla',
    )
        .notEmpty();
  }
}
```

### Caso 2 - DTOs separados

Quando a entidade utiliza DTOs distintos:

```text
CreateContaDto
LoadedContaDto
```

Criar Validators específicos quando necessário:

```text
CreateContaDtoValidator
LoadedContaDtoValidator
```

### Caso 3 - Regras idênticas

Quando múltiplos DTOs possuem exatamente as mesmas regras, é permitido utilizar um Validator compartilhado.

Exemplo:

```dart
class ContaValidator<T>
    extends LucidValidator<T> {
  ...
}
```

ou

```dart
class ContaValidator
    extends LucidValidator<ContaDto> {
  ...
}
```

A solução mais simples deve ser priorizada.

## Padrão

`key` deve ser o nome da propriedade do DTO.

```dart
ruleFor(
  (dto) => dto.email,
  key: 'email',
)
```

O Validator deve ser compatível com:

```dart
validator.byField(dto, 'email');
validator.validate(dto);
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

class ExampleValidator
    extends LucidValidator<ExampleDto> {

  ExampleValidator() {
    ruleFor(
      (dto) => dto.field,
      key: 'field',
    )
        .notEmpty();
  }
}
```

## Exemplo

```dart
class RegisterUserDtoValidator
    extends LucidValidator<RegisterUserDto> {

  RegisterUserDtoValidator() {
    ruleFor(
      (dto) => dto.name,
      key: 'name',
    )
        .notEmpty()
        .minLength(3);

    ruleFor(
      (dto) => dto.email,
      key: 'email',
    )
        .notEmpty()
        .validEmail();

    ruleFor(
      (dto) => dto.password,
      key: 'password',
    )
        .notEmpty()
        .minLength(6);
  }
}
```
