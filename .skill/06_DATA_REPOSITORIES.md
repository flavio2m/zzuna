# REPOSITORIES

## Use quando

* Acessar APIs
* Acessar Storage
* Persistir entidades
* Consultar entidades
* Orquestrar dados
* Emitir eventos para reatividade

---

## Regras

* Nome termina com `Repository`
* Criar em `data/repositories`
* Implementar `BaseRepository<T>`
* Retornar `AsyncResult<T>`
* Utilizar Services ou Storages
* Deve utilizar a exception RepositoryException
* Nunca acessar HTTP diretamente
* Pode possuir consultas específicas além do CRUD
* Pode realizar validações relacionadas à persistência
* Deve emitir eventos através de `StreamController.broadcast()`
* Deve implementar `observer()`
* Deve implementar `dispose()`

---

## Eventos

Todo Repository deve emitir eventos utilizando:

```dart
final _streamController =
    StreamController<RepositoryEvent<T>>.broadcast();
```

Para criação:

```dart
.onSuccess((model) {
  _streamController.add(
    RepositoryCreated(model),
  );
});
```

Para atualização:

```dart
.onSuccess((model) {
  _streamController.add(
    RepositoryUpdated(model),
  );
});
```

Para remoção:

```dart
.onSuccess((_) {
  _streamController.add(
    RepositoryDeleted(id),
  );
});
```

---

## Storage

Repositories devem utilizar uma abstração de Storage.

Exemplo:

```dart
final BaseStorage<Conta> _storage;
```

Injeção:

```dart
ContaRepository(
  LocalStorage<Conta> storage,
) : _storage = storage;
```

---

## Consultas específicas

Repositories podem expor métodos específicos.

Exemplo:

```dart
AsyncResult<User> findUserByEmail(
  String email,
)
```

Utilizando:

```dart
_storage.searchByFields(...)
```

---

## Não fazer

* Widgets
* Providers
* ViewModels
* Navegação
* Estado de UI
* Regras de apresentação
* HTTP direto

---

## Template

```dart
class ExampleRepository
    implements BaseRepository<Example> {

  final BaseStorage<Example> _storage;

  final _streamController =
      StreamController<
        RepositoryEvent<Example>
      >.broadcast();

  ExampleRepository(
    LocalStorage<Example> storage,
  ) : _storage = storage;

  @override
  AsyncResult<Example> create(
    Example model,
  ) async {
    return _storage
        .create(model)
        .onSuccess((result) {
      _streamController.add(
        RepositoryCreated(result),
      );
    });
  }

  @override
  Stream<RepositoryEvent<Example>>
      observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}

