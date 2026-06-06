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
* DTO é utilizado em formulários de criação e edição
* DTO não representa persistência
* DTO pode conter `id` opcional quando utilizado para edição
* Todo DTO deve possuir um Validator correspondente
* DTOs devem ser criados em `domain/dtos`

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
  String field;

  ExampleDto({
    this.field = '',
  });

  void setField(String name) {
    this.name = name;
  }

  Map<String, dynamic> toJson() => {
        'field': field,
      };

  factory ExampleDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExampleDto(
      field: json['field'] ?? '',
    );
  }
}
```
