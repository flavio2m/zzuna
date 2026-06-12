# DTO

## Use quando

* Receber dados de formulário
* Enviar dados para API
* Receber dados de API

## Regras

* Nome termina com `Dto`
* DTO apenas transporta dados
* Sem regras de negócio
* Sem validações
* Campos mutáveis para formulários
* Sempre definir métodos `set` para todos os atributos
* Implementar `toJson()` para requests
* Implementar `fromJson()` para responses
* DTOs devem ser criados em `domain/dtos`
* Todo DTO deve possuir um Validator correspondente
* DTO não representa persistência

## Estratégia de modelagem

Antes de criar DTOs, analisar a diferença entre os contratos de criação e edição.

### Caso 1 - Contratos equivalentes

Quando criação e edição possuem os mesmos campos e a única diferença é a presença do `id`, utilizar apenas um DTO.

Exemplo:

```dart
class ContaDto {
  String? id;
  String descricao;
  String bancoSigla;
  bool ativo;
}
```

Neste caso:

* `id == null` → criação
* `id != null` → edição

Evitar criar DTOs separados quando a única diferença for o campo `id`.

### Caso 2 - Contratos diferentes

Quando criação e edição possuem campos distintos, regras distintas ou representam operações diferentes, criar DTOs específicos.

Exemplo:

```text
CreateUserDto
LoadedUserDto
```

ou

```text
RegisterUserDto
LoginDto
ChangePasswordDto
```

### Critério

Criar `Create<Entity>Dto` e `Loaded<Entity>Dto` somente quando existir diferença real entre os contratos.

Não criar DTOs separados apenas para acomodar a presença do `id`.

## DTO único

Preferir:

```text
ContaDto
ContaFilterDto
```

em vez de:

```text
CreateContaDto
LoadedContaDto
```

quando os campos forem equivalentes.

## DTOs separados

Utilizar:

```text
Create<Entity>Dto
Loaded<Entity>Dto
```

somente quando necessário.

## Não fazer

* Services
* Repositories
* UseCases
* HTTP
* Estado de UI
* Widgets

## Template

```dart
class ExampleDto {
  String? id;

  String field;

  ExampleDto({
    this.id,
    this.field = '',
  });

  void setField(String field) {
    this.field = field;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'field': field,
      };

  factory ExampleDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExampleDto(
      id: json['id'],
      field: json['field'] ?? '',
    );
  }
}
```
