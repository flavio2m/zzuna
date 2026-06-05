# ENTITIES

## Use quando

* Representar estados do domínio
* Retornar dados dos Repositories
* Compartilhar modelos de negócio entre camadas

## Regras

* Criar em `domain/entities`
* Utilizar `Freezed`
* Utilizar `@freezed`
* Utilizar `sealed class`
* Entidades são imutáveis
* Implementar `fromJson()`
* Gerar arquivos `.freezed.dart` e `.g.dart`
* Pode conter estados especializados usando factories

## Não fazer

* Widgets
* Providers
* ViewModels
* Repositories
* Services
* HTTP
* Estado de UI

## Template

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_entity.freezed.dart';
part 'example_entity.g.dart';

@freezed
sealed class ExampleEntity with _$ExampleEntity {
  const factory ExampleEntity({
    required String id,
  }) = LoadedExampleEntity;

  factory ExampleEntity.fromJson(
    Map<String, dynamic> json,
  ) => _$ExampleEntityFromJson(json);
}
```

## Exemplo

```dart
@freezed
sealed class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = LoadedUser;

  const factory User.notLogged() =
      NotLoggedUser;

  const factory User.logged({
    required String id,
    required String name,
    required String email,
    required String token,
    required String refreshToken,
  }) = LoggedUser;

  factory User.fromJson(
    Map<String, dynamic> json,
  ) => _$UserFromJson(json);
}
```
