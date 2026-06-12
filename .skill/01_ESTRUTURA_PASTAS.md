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
Storage / Service
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
Storage
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

# config/

Configuração global da aplicação.

```text
config/
└── providers.dart
```

Responsável por:

* Providers Riverpod
* Injeção de dependência
* Registro de Storages
* Registro de Repositories
* Registro de ViewModels

---

# domain/

Contém modelos e contratos do domínio.

```text
domain/
├── dtos/
├── entities/
├── statics/
└── validators/
```

---

## domain/dtos

DTOs organizados por entidade.

Exemplo:

```text
domain/dtos/
├── cartao/
├── conta/
├── centro_custo/
└── user/
```

Exemplos:

```text
cartao_dto.dart
cartao_filter_dto.dart

conta_dto.dart
conta_filter_dto.dart
```

---

## domain/entities

Entidades de domínio.

Exemplo:

```text
cartao_entity.dart
conta_entity.dart
user_entity.dart
```

Quando necessário, a Entity pode possuir uma versão Details.

Exemplo:

```dart
Conta
ContaDetails
```

---

## domain/statics

Dados estáticos compartilhados pelo sistema.

Exemplo:

```text
domain/statics/
└── banco/
```

---

## domain/validators

Validators baseados em LucidValidation.

Exemplos:

```text
cartao_validator.dart
conta_validator.dart
credentials_validator.dart
```

---

# data/

Responsável pelo acesso aos dados.

```text
data/
├── exception/
├── repositories/
└── services/
```

---

## data/repositories

Organizados por entidade.

Exemplo:

```text
repositories/
├── auth/
├── cartao/
├── conta/
├── centro_custo/
└── user/
```

Responsabilidades:

* CRUD
* Pesquisa
* Conversão DTO → Entity
* Emissão de eventos
* Orquestração de persistência

---

## data/services

Serviços de infraestrutura.

```text
services/
├── auth/
└── storage/
```

Exemplo:

```text
services/auth/local
services/storage/local
```

---

## data/exception

Exceções da camada de dados.

Exemplos:

```text
repository_exception.dart
local_storage_exception.dart
local_auth_exception.dart
```

---

# ui/

Camada de apresentação.

Organizada por feature.

Exemplo:

```text
ui/
├── auth/
├── cartao/
├── conta/
├── centro_custo/
├── home/
├── lancamentos/
├── relatorios/
└── shared/
```

---

## Estrutura padrão de CRUD

Toda entidade deve seguir preferencialmente:

```text
feature/
├── create/
│   ├── viewmodels/
│   └── widgets/
├── update/
│   ├── viewmodels/
│   └── widgets/
├── delete/
│   ├── viewmodels/
│   └── widgets/
└── list/
    ├── viewmodels/
    └── widgets/
```

Exemplo:

```text
cartao/
conta/
centro_custo/
```

---

## ViewModels

Sempre dentro da feature correspondente.

Exemplo:

```text
ui/cartao/list/viewmodels/
ui/cartao/create/viewmodels/
ui/cartao/update/viewmodels/
```

---

## Widgets

Sempre dentro da feature correspondente.

Exemplo:

```text
ui/cartao/list/widgets/
ui/cartao/create/widgets/
```

---

# ui/shared

Componentes reutilizáveis.

```text
shared/
├── feedback/
├── mappers/
├── theme/
└── widgets/
```

---

## shared/feedback

Componentes de feedback.

Exemplo:

```text
app_dialog.dart
app_snackbar.dart
```

---

## shared/mappers

Conversões de apresentação.

Exemplo:

```text
status_mapper.dart
```

---

## shared/theme

Tema e cores da aplicação.

Exemplo:

```text
app_colors.dart
```

---

## shared/widgets

Componentes visuais reutilizáveis.

```text
widgets/
├── buttons/
│   └── icons_buttons/
├── cards/
├── forms/
├── layout/
├── tags/
└── texts/
```

### buttons

Botões reutilizáveis.

Exemplo:

```text
button_add.dart
button_find.dart
button_save.dart
button_cancel.dart
```

### buttons/icons_buttons

Botões de ação baseados em ícones.

Exemplo:

```text
icon_editar_button.dart
icon_delete_button.dart
```

### cards

Cards reutilizáveis.

Exemplo:

```text
app_filter_card.dart
```

### forms

Campos e componentes de formulário.

Exemplo:

```text
app_text_form_field.dart
app_currency_form_field.dart
app_integer_form_field.dart
app_status_dropdown.dart
app_banco_dropdown.dart
app_switch_field.dart
```

### layout

Componentes de layout.

Exemplo:

```text
app_spacing.dart
```

### tags

Etiquetas visuais.

Exemplo:

```text
app_tag.dart
```

### texts

Componentes de texto.

Exemplo:

```text
app_text.dart
```

---

# utils/

Utilitários compartilhados.

```text
utils/
├── exceptions/
└── extensions/
```

---

## extensions

Extensões utilitárias.

Exemplo:

```text
command_state_extension.dart
lucid_validator_extension.dart
```

---

# Regras

Ao criar novos arquivos:

* DTO → `domain/dtos/[feature]`
* Entity → `domain/entities`
* Validator → `domain/validators`
* Repository → `data/repositories/[feature]`
* Storage → `data/services/storage`
* ViewModel → `ui/[feature]/[acao]/viewmodels`
* Widget → `ui/[feature]/[acao]/widgets`
* Shared Widget → `ui/shared/widgets`
* Provider → `config/providers.dart`

---

# Não fazer

* Criar lógica de negócio na UI
* Acessar Storage diretamente da UI
* Acessar Storage diretamente do ViewModel
* Criar Providers fora de `config/providers.dart`
* Criar widgets compartilhados dentro de features
* Duplicar componentes já existentes em `shared`
* Misturar responsabilidades entre camadas
