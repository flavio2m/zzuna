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
* Implementar `BaseRepository`
* Retornar `AsyncResult<T>`
* Utilizar Services ou Storages
* Deve utilizar Exceptions da camada de dados
* Nunca acessar HTTP diretamente
* Pode possuir consultas específicas além do CRUD
* Pode realizar validações relacionadas à persistência
* Deve emitir eventos através de `StreamController.broadcast()`
* Deve implementar `observer()`
* Deve implementar `dispose()`
* DTOs são convertidos para Entities dentro do Repository
* Repositories persistem Entities, nunca DTOs

---

## Interface

A assinatura da interface deve refletir a necessidade real da entidade.

### DTO único

Quando a entidade utiliza um único DTO:

```dart
BaseRepository<
  Conta,
  ContaDto,
  ContaFilterDto
>
```

Exemplo:

```dart
AsyncResult<Conta> create(
  ContaDto dto,
)

AsyncResult<Conta> update(
  ContaDto dto,
)

AsyncResult<List<Conta>> search(
  ContaFilterDto filter,
)
```

### DTOs distintos

Quando criação e edição possuem contratos diferentes:

```dart
BaseRepository<
  User,
  CreateUserDto,
  LoadedUserDto,
  UserFilterDto
>
```

Exemplo:

```dart
AsyncResult<User> create(
  CreateUserDto dto,
)

AsyncResult<User> update(
  LoadedUserDto dto,
)
```

Criar DTOs distintos somente quando houver diferença real entre os contratos.

---

## Eventos

Todo Repository deve emitir eventos utilizando:

```dart
final _streamController =
    StreamController<
      RepositoryEvent<T>
    >.broadcast();
```

### Criação

```dart
.onSuccess((model) {
  _streamController.add(
    RepositoryCreated(model),
  );
});
```

### Atualização

```dart
.onSuccess((model) {
  _streamController.add(
    RepositoryUpdated(model),
  );
});
```

### Remoção

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

## Conversão DTO → Entity

O Repository é responsável por converter DTOs para Entities.

Exemplo:

```dart
final conta = Conta(
  id: dto.id ?? const Uuid().v4(),
  descricao: dto.descricao,
  bancoSigla: dto.bancoSigla,
  ativo: dto.ativo,
);
```

Persistir sempre a Entity.

---

## Consultas específicas

Repositories podem expor métodos específicos.

Exemplo:

```dart
AsyncResult<User> findByEmail(
  String email,
)
```

Utilizando:

```dart
_storage.searchByFields(...)
```

---

## Seed de dados

Quando necessário para desenvolvimento local, é permitido criar métodos privados de seed.

Exemplo:

```dart
Future<void> _seedContas()
```

Esses métodos devem ser temporários e marcados com comentário indicando uso apenas para testes.

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
    implements BaseRepository<
      Example,
      ExampleDto,
      ExampleFilterDto
    > {

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
    ExampleDto dto,
  ) async {
    final entity = Example(
      id: dto.id ?? const Uuid().v4(),
    );

    return _storage
        .create(entity)
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
```
