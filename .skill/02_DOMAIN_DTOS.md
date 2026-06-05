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
* Sempre definr set para todos os atributos
* Implementar `toJson()` para requests
* Implementar `fromJson()` para responses
* Criar Validator correspondente

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
