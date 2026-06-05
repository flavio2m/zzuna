# REPOSITORIES

## Use quando

* Acessar APIs
* Acessar Storage
* Orquestrar dados
* Emitir eventos para reatividade

## Regras

* Nome termina com `Repository`
* Retornar `AsyncResult<T>`
* Chamar Services/Clients
* Validar DTOs quando necessário
* Emitir eventos com `StreamController.broadcast()`
* Expor `observer()`
* Implementar `dispose()`
* Criar em `data/repositories`

## Padrão

```dart
final _streamController = StreamController<Event>.broadcast();

Stream<Event> observer() {
  return _streamController.stream;
}

void dispose() {
  _streamController.close();
}
```

Para operações com sucesso:

```dart
result.onSuccess(_streamController.add);
```

Para validação:

```dart
validator
    .validateResult(dto)
    .flatMap(client.method);
```

## Não fazer

* HTTP direto na ViewModel
* HTTP direto na UI
* Widgets
* Estado de UI
* Navegação
* Regras de apresentação

## Template

```dart
import 'dart:async';
import 'package:result_dart/result_dart.dart';

class ExampleRepository {
  final ExampleClient _client;

  final _streamController =
      StreamController<ExampleEvent>.broadcast();

  ExampleRepository(this._client);

  AsyncResult<Example> execute(
    ExampleDto dto,
  ) {
    return _client
        .execute(dto)
        .onSuccess(_streamController.add);
  }

  Stream<ExampleEvent> observer() {
    return _streamController.stream;
  }

  void dispose() {
    _streamController.close();
  }
}
```
