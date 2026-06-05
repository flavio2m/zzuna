# ESTRUTURA DO PROJETO

## Arquitetura

O projeto segue MVVM com separação por camadas:

```text
UI
↓
ViewModel
↓
Repository
↓
Service
↓
Fonte de Dados
```

Fluxo de validação:

```text
DTO
↓
Validator
↓
Repository
↓
Service
```

---

## Estrutura

```text
lib/
├── config/
├── data/
├── domain/
├── ui/
├── utils/
```

---

## config/

Configuração global da aplicação.

```text
config/
└── providers.dart
```

Responsável por:

* Providers Riverpod
* Injeção de dependência
* Registro de Services
* Registro de Repositories
* Registro de ViewModels

---

## domain/

Contém regras e modelos de domínio.

```text
domain/
├── dtos/
├── entities/
└── validators/
```

### dtos/

Objetos de transferência de dados.

Exemplos:

```text
credentials.dart
register_user_dto.dart
update_user_dto.dart
```

### entities/

Modelos de domínio.

Exemplos:

```text
user_entity.dart
```

### validators/

Validação de DTOs.

Exemplos:

```text
credentials_validator.dart
register_user_dto_validator.dart
```

---

## data/

Contém acesso a dados e integrações.

```text
data/
├── repositories/
├── services/
└── exception/
```

### repositories/

Orquestram acesso aos dados.

Exemplos:

```text
auth_repository.dart
user_repository.dart
```

### services/

Integrações externas.

Exemplos:

```text
auth/
storage/
shared_preferences_service.dart
```

### exception/

Exceções específicas da camada de dados.

---

## ui/

Camada de apresentação.

Organizada por feature.

```text
ui/
├── auth/
├── home/
└── shared/
```

### Estrutura de Feature

Página:

```text
feature/
├── feature_page.dart
└── viewmodels/
    └── feature_viewmodel.dart
```

Widget reutilizável:

```text
feature/
├── viewmodels/
│   └── feature_viewmodel.dart
└── widgets/
    └── feature_widget.dart
```

Exemplos:

```text
auth/login/
auth/logout/
auth/register/
```

### shared/

Componentes compartilhados.

Exemplo:

```text
snackbar_base.dart
```

---

## utils/

Utilitários compartilhados.

```text
utils/
├── exceptions/
└── extensions/
```

Exemplos:

```text
command_state_extension.dart
lucid_validator_extension.dart
```

---

## test/

Testes seguem a mesma estrutura da aplicação.

```text
test/
├── data/
├── helpers/
└── utils/
```

---

## Regras

Ao criar novos arquivos:

* DTO → `domain/dtos`
* Entity → `domain/entities`
* Validator → `domain/validators`
* Service → `data/services`
* Repository → `data/repositories`
* ViewModel → `ui/[feature]/viewmodels`
* Widget → `ui/[feature]/widgets`
* Page → `ui/[feature]`
* Provider → `config/providers.dart`

---

## Não fazer

* Criar lógica de negócio na UI
* Acessar Services diretamente da UI
* Acessar Services diretamente do ViewModel
* Criar Providers fora de `config/providers.dart`
* Misturar responsabilidades entre camadas

