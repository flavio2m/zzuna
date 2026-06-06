# SERVICES

## Use quando

* Integrar fontes externas
* Consumir APIs
* Persistir dados
* Acessar serviços de terceiros
* Adaptar infraestrutura para a aplicação

## Regras

* Criar em `data/services`
* Retornar `AsyncResult<T>`
* Focar apenas na integração externa
* Ser reutilizável por Repositories
* Pode possuir interfaces quando necessário

## Não fazer

* Regras de negócio
* Validators
* Commands
* ViewModels
* Widgets
* BuildContext
* Navegação
* Estado de UI
* StreamController

## Responsabilidade

Services executam operações de infraestrutura.

Exemplos:

* Autenticação
* Storage
* APIs REST
* Firebase
* Supabase
* SharedPreferences
* Banco local

## Template

```dart
abstract class ExampleService {
  AsyncResult<ResultType> execute(
    InputDto dto,
  );
}
```

## Exemplos do projeto

* AuthLocalClient
* LocalStorage<T>
* SharedPreferencesService

```
```
