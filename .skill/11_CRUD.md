# CRUD FEATURE

## Objetivo

Criar uma feature CRUD completa seguindo o padrão utilizado no projeto.

Utilizar Cartão como implementação de referência.

---

# Estrutura UI

Toda feature CRUD deve possuir:

```text
ui/<feature>/
├─ create/
│   ├─ viewModels/
│   │   └─ <feature>_create_viewmodel.dart
│   └─ widgets/
│       └─ <feature>_create_modal.dart
│
├─ delete/
│   ├─ viewModel/
│   │   └─ <feature>_delete_viewmodel.dart
│   └─ widgets/
│       └─ <feature>_delete_button.dart
│
├─ list/
│   ├─ <feature>_list_page.dart
│   ├─ viewmodels/
│   │   └─ <feature>_list_viewmodel.dart
│   └─ widgets/
│       ├─ <feature>_filter_bar.dart
│       ├─ <feature>_list_item.dart
│       └─ <feature>_list_view.dart
│
└─ update/
    ├─ viewmodels/
    │   └─ <feature>_update_viewmodel.dart
    └─ widgets/
        └─ <feature>_update_modal.dart
```

---

# Repository

Toda feature CRUD deve possuir:

```text
data/repositories/<feature>/
```

Implementando:

```dart
create()
update()
delete()
getAll()
getById()
search()
findByDescricao()
observer()
dispose()
```

---

# DTOs

Criar:

```text
domain/dtos/<feature>/
```

Arquivos mínimos:

```text
<feature>_dto.dart
<feature>_filter_dto.dart
```

Criar DTOs específicos somente quando existir diferença real entre criação e edição.

---

# Validator

Criar:

```text
domain/validators/
```

Validator compatível com:

```dart
validator.validate(dto)
validator.byField(dto, 'campo')
```

---

# ViewModels

Criar:

```text
create/viewmodels
update/viewmodels
delete/viewmodel
list/viewmodels
```

Seguir padrão da feature Cartão.

---

# UI

Criar:

```text
Create Modal
Update Modal
Delete Button
List Page
List View
List Item
Filter Bar
```

---

# Providers

Registrar todos os providers necessários em:

```text
config/providers.dart
```

---

# Menu

Atualizar:

```text
lib/ui/home/widgets/home_top_bar.dart
lib/ui/home/home_page.dart
lib/main.route.dart
```

quando a feature for navegável.

---

# Componentes Compartilhados

Priorizar:

```text
AppForm
AppTextFormField
AppDropdownFormField
AppStatusDropdown
AppSwitchField
AppTag
AppFilterCard
ButtonAdd
ButtonFind
ButtonSave
ButtonCancel
```

Não recriar componentes existentes.

---

# Referência

Utilizar sempre a feature Cartão como implementação de referência.
