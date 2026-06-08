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
* Toda Entity deve possuir no mínimo dois DTOs:
  * `Create<Entity>Dto`
  * `Loaded<Entity>Dto`
* `CreateDto` representa dados para criação de registros
* `LoadedDto` representa registros já existentes
* `CreateDto` pode possuir `id` opcional
* `LoadedDto` deve possuir `id`
* Não utilizar herança entre DTOs
* DTOs devem ser independentes, mesmo quando possuírem os mesmos campos
* Duplicação de campos entre DTOs é aceitável para manter clareza e simplicidade

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

  void setField(String field) {
    this.field = field;
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