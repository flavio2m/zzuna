# ENTITIES

## Use quando

* Representar modelos do domínio
* Compartilhar dados entre camadas
* Retornar dados dos Repositories

---

## Regras

### Entity

Representa exatamente o que será persistido.

* Criar em `domain/entities`
* Utilizar `Freezed`
* Utilizar `@freezed`
* Utilizar `sealed class`
* Implementar `fromJson()`
* Gerar `.freezed.dart` e `.g.dart`
* Conter apenas dados persistidos
* Não conter objetos de outros domínios

### EntityDetails

Toda Entity que tiver uma relação com outra Entity (entityId)deve possuir uma versão Details.

Representa um objeto rico para utilização na UI.

* Criar no mesmo arquivo da Entity
* Utilizar `Freezed`
* Utilizar `@freezed`
* Utilizar `sealed class`
* Não implementar `fromJson()`
* Não gerar `.g.dart`
* Pode conter objetos de outros domínios já instanciados

---

## Conversões

* Entity → EntityDetails deve ocorrer em Repository, Mapper ou UseCase
* Nunca realizar conversões na UI

---

## Não fazer

* Widgets
* Providers
* ViewModels
* Services
* HTTP
* Estado de UI
* Conversões na UI

---

## Template

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_entity.freezed.dart';
part 'example_entity.g.dart';

@freezed
sealed class ExampleEntity with _$ExampleEntity {
  const factory ExampleEntity({
    required String id,
  }) = _ExampleEntity;

  factory ExampleEntity.fromJson(
    Map<String, dynamic> json,
  ) => _$ExampleEntityFromJson(json);
}

@freezed
sealed class ExampleEntityDetails
    with _$ExampleEntityDetails {
  const factory ExampleEntityDetails({
    required String id,
  }) = _ExampleEntityDetails;
}
```

---

## Exemplo

```dart
@freezed
sealed class Cartao with _$Cartao {
  const factory Cartao({
    required String id,
    required String descricao,
    required double limite,
    required String bancoSigla,
    required bool ativo,
    required int diaFechamento,
  }) = _Cartao;

  factory Cartao.fromJson(
    Map<String, dynamic> json,
  ) => _$CartaoFromJson(json);
}

@freezed
sealed class CartaoDetails
    with _$CartaoDetails {
  const factory CartaoDetails({
    required String id,
    required String descricao,
    required double limite,
    required Banco banco,
    required bool ativo,
    required int diaFechamento,
  }) = _CartaoDetails;
}
```

---

## Padrão do Projeto

Toda Entity deve possuir uma versão Details.

```text
Conta -> ContaDetails
Cartao -> CartaoDetails
Categoria -> CategoriaDetails
CentroCusto -> CentroCustoDetails
Documento -> DocumentoDetails
Lancamento -> LancamentoDetails
```