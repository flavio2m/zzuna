# PROVIDERS

## Use quando

* Registrar Services
* Registrar Repositories
* Registrar ViewModels
* Expor estado reativo

## Regras

* Criar em `config/providers.dart`
* Nome termina com `Provider`
* Injetar dependências com `ref.watch()`
* Usar `ref.onDispose()` para classes com `dispose()`
* Agrupar por camada:

  * Services
  * Repositories
  * ViewModels
  * State Providers

## Padrões

### Provider

```dart
final exampleProvider =
    Provider<Example>((ref) {

  return Example(
    ref.watch(dependencyProvider),
  );
});
```

### Provider com dispose

```dart
final exampleRepositoryProvider =
    Provider<ExampleRepository>((ref) {

  final repository = ExampleRepository(
    ref.watch(clientProvider),
  );

  ref.onDispose(repository.dispose);

  return repository;
});
```

### StreamProvider

```dart
final exampleProvider =
    StreamProvider<Example>((ref) async* {

  yield* ref
      .watch(repositoryProvider)
      .observer();
});
```

## Uso

### build()

```dart
final viewModel =
    ref.watch(loginViewModelProvider);
```

### initState() / callbacks

```dart
final viewModel =
    ref.read(loginViewModelProvider);
```

### Escutar mudanças

```dart
ref.listen(userProvider, (_, next) {
  // reação ao estado
});
```

## Não fazer

* Instanciar dependências manualmente
* Criar providers fora de `config/providers.dart`
* Usar `ref.read()` dentro de `build()`
* Usar `ref.watch()` dentro de `initState()`

## Exemplo

```dart
final authRepositoryProvider =
    Provider<AuthRepository>((ref) {

  final repository = AuthRepository(
    ref.watch(authClientProvider),
    ref.watch(userRepositoryProvider),
  );

  ref.onDispose(repository.dispose);

  return repository;
});

final loginViewModelProvider =
    Provider<LoginViewModel>(
  (ref) => LoginViewModel(
    ref.watch(authRepositoryProvider),
  ),
);

final userProvider =
    StreamProvider<User>((ref) async* {

  yield const User.notLogged();

  yield* ref
      .watch(authRepositoryProvider)
      .userObserver();
});
```
