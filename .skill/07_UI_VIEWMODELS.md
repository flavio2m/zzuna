# VIEWMODELS

## Use quando

* Conectar UI aos Repositories
* Expor ações para a View
* Gerenciar estados assíncronos com Commands

## Regras

* Nome termina com `ViewModel`
* Injetar Repository pelo construtor
* Usar `result_command`
* Expor ações via Commands
* Método do Command deve ser privado (`_`)
* Retornar `AsyncResult<T>`
* Criar em `ui/[feature]/viewmodels`

## Commands

### Sem parâmetros

```dart
late final logoutCommand =
    Command0(_logout);
```

### Um parâmetro

```dart
late final loginCommand =
    Command1(_login);
```

### Dois parâmetros

```dart
late final updateCommand =
    Command2(_update);
```

## Não fazer

* Widgets
* BuildContext
* Navegação
* SnackBars
* Estado visual
* HTTP direto
* Acesso direto a Services

## Template

```dart
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ExampleViewModel {
  final ExampleRepository _repository;

  ExampleViewModel(this._repository);

  late final executeCommand =
      Command1(_execute);

  AsyncResult<ResultType> _execute(
    InputDto dto,
  ) {
    return _repository.execute(dto);
  }
}
```

## Exemplo

```dart
class LoginViewModel {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  late final loginCommand =
      Command1(_login);

  AsyncResult<LoggedUser> _login(
    CredentialsDto credentials,
  ) {
    return _authRepository.login(
      credentials,
    );
  }
}
```
