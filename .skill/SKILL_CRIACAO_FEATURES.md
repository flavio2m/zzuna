# 🎯 SKILL: Padrão para Criação de Features (UI)

## 📋 Análise da Implementação Atual

Baseado na análise das features **Login** e **Logout** implementadas no projeto:

### **Estrutura Login (Page completa):**
```
ui/auth/login/
├── login_page.dart              # Página completa (StatefulWidget)
└── viewmodels/
    └── login_viewmodel.dart     # Lógica de negócio
```

### **Estrutura Logout (Widget reutilizável):**
```
ui/auth/logout/
├── viewmodels/
│   └── logout_viewmodel.dart    # Lógica de negócio
└── widgets/
    └── logout_button.dart       # Widget que usa o ViewModel
```

---

## 🏗️ Padrão de Estrutura de Pastas

### **Regra 1: Feature com Página Dedicada**
**Quando:** A feature representa uma **tela completa** (ex: Login, Cadastro, Perfil)

```
ui/
└── [feature_name]/
    ├── [feature_name]_page.dart       # Página principal
    ├── viewmodels/
    │   └── [feature_name]_viewmodel.dart
    └── widgets/                        # (Opcional) Widgets específicos
        └── [component]_widget.dart
```

**Exemplo Real (Login):**
```
ui/auth/login/
├── login_page.dart                    # Tela de login completa
└── viewmodels/
    └── login_viewmodel.dart           # Comando: loginCommand
```

---

### **Regra 2: Feature como Componente Reutilizável**
**Quando:** A feature é um **componente/widget** usado em outras telas (ex: Logout Button)

```
ui/
└── [feature_name]/
    ├── viewmodels/
    │   └── [feature_name]_viewmodel.dart
    └── widgets/
        └── [feature_name]_[component].dart
```

**Exemplo Real (Logout):**
```
ui/auth/logout/
├── viewmodels/
│   └── logout_viewmodel.dart          # Comando: logoutCommand
└── widgets/
    └── logout_button.dart             # Botão que executa logout
```

---

### **Regra 3: Feature com Múltiplas Ações**
**Quando:** A feature agrupa **várias ações relacionadas** (ex: Auth = Login + Logout + Register)

```
ui/
└── [domain]/
    ├── [action1]/
    │   ├── [action1]_page.dart
    │   └── viewmodels/
    │       └── [action1]_viewmodel.dart
    ├── [action2]/
    │   ├── viewmodels/
    │   │   └── [action2]_viewmodel.dart
    │   └── widgets/
    │       └── [action2]_button.dart
    └── [action3]/
        └── ...
```

**Exemplo Real (Auth):**
```
ui/auth/
├── login/                             # Ação 1: Login (página)
│   ├── login_page.dart
│   └── viewmodels/
│       └── login_viewmodel.dart
├── logout/                            # Ação 2: Logout (widget)
│   ├── viewmodels/
│   │   └── logout_viewmodel.dart
│   └── widgets/
│       └── logout_button.dart
└── register/                          # Ação 3: Register (página)
    ├── register_page.dart
    └── viewmodels/
        └── register_viewmodel.dart
```

---

## 📝 Template de Implementação

### **1. ViewModel (Sempre necessário)**

```dart
// lib/ui/[feature]/viewmodels/[feature]_viewmodel.dart
import 'package:zzuna/data/repositories/[domain]/[domain]_repository.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class [Feature]ViewModel {
  final [Domain]Repository _repository;

  [Feature]ViewModel(this._repository);

  // Command0: Sem parâmetros (ex: logout)
  late final [action]Command = Command0(_[action]);

  // Command1: Com 1 parâmetro (ex: login)
  // late final [action]Command = Command1<[InputType], [OutputType]>(_[action]);

  AsyncResult<[ReturnType]> _[action]([InputType? input]) {
    return _repository.[method]([input]);
  }
}
```

**Exemplo Real (LoginViewModel):**
```dart
class LoginViewModel {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  late final loginCommand = Command1(_login);

  AsyncResult<LoggedUser> _login(Credentials credentials) {
    return _authRepository.login(credentials);
  }
}
```

---

### **2. Page (Para features com tela completa)**

```dart
// lib/ui/[feature]/[feature]_page.dart
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/[feature]/viewmodels/[feature]_viewmodel.dart';
import 'package:zzuna/ui/shared/snackbar_base.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class [Feature]Page extends ConsumerStatefulWidget {
  const [Feature]Page({super.key});

  @override
  ConsumerState<[Feature]Page> createState() => _[Feature]PageState();
}

class _[Feature]PageState extends ConsumerState<[Feature]Page> {
  late final [Feature]ViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read([feature]ViewModelProvider);
    viewModel.[action]Command.addListener(_commandListener);
  }

  void _commandListener() {
    final commandValue = viewModel.[action]Command.value;
    
    // Tratar sucesso
    commandValue.onSuccess((result) {
      SnackBarBase.showSuccess(context, 'Ação realizada com sucesso!');
    });
    
    // Tratar erro
    commandValue.onFailure((exception) {
      SnackBarBase.showError(context, exception?.toString() ?? 'Erro');
    });
  }

  @override
  void dispose() {
    viewModel.[action]Command.removeListener(_commandListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('[Feature]')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Seus widgets aqui
            ListenableBuilder(
              listenable: viewModel.[action]Command,
              builder: (context, _) {
                return ElevatedButton(
                  onPressed: viewModel.[action]Command.value.isRunning
                      ? null
                      : () => viewModel.[action]Command.execute([params]),
                  child: Text('[Action]'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### **3. Widget (Para features como componentes)**

```dart
// lib/ui/[feature]/widgets/[feature]_[component].dart
import 'package:zzuna/config/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class [Feature][Component] extends ConsumerWidget {
  const [Feature][Component]({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch([feature]ViewModelProvider);

    return ElevatedButton(
      onPressed: viewModel.[action]Command.execute,
      child: const Text('[Action]'),
    );
  }
}
```

**Exemplo Real (LogoutButton):**
```dart
class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(logoutViewModelProvider);

    return ElevatedButton(
      onPressed: viewModel.logoutCommand.execute,
      child: const Text('Logout'),
    );
  }
}
```

---

### **4. Provider (Sempre necessário em `config/providers.dart`)**

```dart
// lib/config/providers.dart

// ============================================================================
// VIEWMODELS - Camada de Apresentação
// ============================================================================

/// Provider para [Feature]ViewModel
final [feature]ViewModelProvider = Provider<[Feature]ViewModel>(
  (ref) => [Feature]ViewModel(ref.watch([domain]RepositoryProvider)),
);
```

**Exemplo Real:**
```dart
final loginViewModelProvider = Provider<LoginViewModel>(
  (ref) => LoginViewModel(ref.watch(authRepositoryProvider)),
);

final logoutViewModelProvider = Provider<LogoutViewModel>(
  (ref) => LogoutViewModel(ref.watch(authRepositoryProvider)),
);
```

---

## 🎯 Checklist para Nova Feature

### **Antes de Começar:**
- [ ] Definir se é **página completa** ou **widget reutilizável**
- [ ] Verificar se já existe um **Repository** para o domínio
- [ ] Verificar se já existe um **Provider** para o Repository

### **Implementação:**
- [ ] Criar pasta `ui/[feature]/` ou `ui/[domain]/[action]/`
- [ ] Criar `viewmodels/[feature]_viewmodel.dart`
- [ ] Criar `Command` apropriado (`Command0`, `Command1`, etc.)
- [ ] Criar `[feature]_page.dart` OU `widgets/[feature]_widget.dart`
- [ ] Adicionar `Provider` em `config/providers.dart`
- [ ] Implementar listeners com `CommandStateExtension`
- [ ] Usar `SnackBarBase` para feedback visual

### **Validação:**
- [ ] Rodar `flutter analyze` (sem erros)
- [ ] Testar navegação (se for página)
- [ ] Testar loading state (`isRunning`)
- [ ] Testar tratamento de erro
- [ ] Testar tratamento de sucesso

---

## 📚 Exemplos de Nomenclatura

### **Páginas:**
| Feature | Pasta | Arquivo | ViewModel |
|---------|-------|---------|-----------|
| Login | `ui/auth/login/` | `login_page.dart` | `login_viewmodel.dart` |
| Cadastro | `ui/auth/register/` | `register_page.dart` | `register_viewmodel.dart` |
| Perfil | `ui/profile/` | `profile_page.dart` | `profile_viewmodel.dart` |
| Produtos | `ui/products/list/` | `product_list_page.dart` | `product_list_viewmodel.dart` |

### **Widgets:**
| Feature | Pasta | Arquivo | ViewModel |
|---------|-------|---------|-----------|
| Logout | `ui/auth/logout/` | `widgets/logout_button.dart` | `logout_viewmodel.dart` |
| Avatar | `ui/profile/avatar/` | `widgets/avatar_picker.dart` | `avatar_viewmodel.dart` |
| Filtro | `ui/products/filter/` | `widgets/filter_dialog.dart` | `filter_viewmodel.dart` |

---

## 🔄 Fluxo de Dados (Padrão do Projeto)

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. USER ACTION (Botão pressionado)                             │
└────────────────────┬────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│ 2. VIEW (Page/Widget)                                           │
│    - viewModel.[action]Command.execute([params])                │
└────────────────────┬────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│ 3. VIEWMODEL                                                    │
│    - Command encapsula AsyncResult                              │
│    - Chama Repository                                           │
└────────────────────┬────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│ 4. REPOSITORY                                                   │
│    - Valida dados (se necessário)                               │
│    - Chama Service/Client                                       │
│    - Retorna AsyncResult<T>                                     │
└────────────────────┬────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│ 5. SERVICE/CLIENT                                               │
│    - Executa chamada HTTP ou Storage                            │
│    - Retorna AsyncResult<T>                                     │
└────────────────────┬────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│ 6. COMMAND (Reatividade)                                        │
│    - Atualiza estado (Running → Success/Failure)                │
│    - Notifica listeners                                         │
└────────────────────┬────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│ 7. VIEW LISTENER                                                │
│    - commandValue.onSuccess() → SnackBarBase.showSuccess()      │
│    - commandValue.onFailure() → SnackBarBase.showError()        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💡 Boas Práticas

### ✅ **FAÇA:**
- Use `ConsumerStatefulWidget` para páginas com state
- Use `ConsumerWidget` para widgets simples
- Use `CommandStateExtension` para extrair erros (`.getErrorMessage()`)
- Use `SnackBarBase` para feedback visual
- Adicione `listener` no `initState()` e remova no `dispose()`
- Use `ListenableBuilder` para reatividade no UI
- Nomeie Commands de forma descritiva (`loginCommand`, `saveProductCommand`)

### ❌ **NÃO FAÇA:**
- Não coloque lógica de negócio na View
- Não use `setState()` para gerenciar estado de Commands
- Não crie ViewModels sem Commands (use Commands para ações assíncronas)
- Não esqueça de chamar `dispose()` nos listeners
- Não use `ScaffoldMessenger` direto (use `SnackBarBase`)

---

## 🚀 Exemplo Completo: Feature "Produtos"

### **Estrutura:**
```
ui/products/
├── list/
│   ├── product_list_page.dart
│   └── viewmodels/
│       └── product_list_viewmodel.dart
├── detail/
│   ├── product_detail_page.dart
│   └── viewmodels/
│       └── product_detail_viewmodel.dart
└── add/
    ├── add_product_page.dart
    └── viewmodels/
        └── add_product_viewmodel.dart
```

### **Provider:**
```dart
// config/providers.dart
final productListViewModelProvider = Provider<ProductListViewModel>(
  (ref) => ProductListViewModel(ref.watch(productRepositoryProvider)),
);

final productDetailViewModelProvider = Provider<ProductDetailViewModel>(
  (ref) => ProductDetailViewModel(ref.watch(productRepositoryProvider)),
);

final addProductViewModelProvider = Provider<AddProductViewModel>(
  (ref) => AddProductViewModel(ref.watch(productRepositoryProvider)),
);
```

---

**Criado em:** 04/06/2026  
**Baseado em:** Análise das features Login e Logout  
**Projeto:** zzuna  

---

## 🔧 CommandStateExtension - Métodos Utilitários

O projeto possui uma extension personalizada para facilitar o trabalho com `CommandState`. 
Esta extension elimina código verboso ao lidar com resultados de Commands.

**Localização:** `lib/utils/extensions/command_state_extension.dart`

### **Métodos Disponíveis:**

#### **1. `getErrorMessage()` - Extrair Mensagem de Erro**
Extrai a mensagem de erro de forma simplificada.

```dart
// ❌ ANTES (verboso)
final errorMessage = viewModel.loginCommand.value.when<String>(
  data: (_) => '',
  failure: (exception) => exception?.toString() ?? 'Erro desconhecido',
  orElse: () => 'Erro desconhecido',
);

// ✅ DEPOIS (com extension)
final errorMessage = viewModel.loginCommand.value.getErrorMessage();

// Com mensagem padrão customizada
final errorMessage = viewModel.loginCommand.value.getErrorMessage('Ops! Algo deu errado');
```

---

#### **2. `onFailure()` - Executar Ação em Caso de Erro**
Executa um callback apenas se o comando falhou.

```dart
void _commandListener() {
  viewModel.loginCommand.value.onFailure((exception) {
    SnackBarBase.showError(
      context,
      exception?.toString() ?? 'Erro ao fazer login',
    );
  });
}
```

**Quando usar:**
- Exibir mensagens de erro
- Logar exceções
- Executar rollback de operações

---

#### **3. `onSuccess()` - Executar Ação em Caso de Sucesso**
Executa um callback apenas se o comando foi bem-sucedido.

```dart
void _commandListener() {
  viewModel.registerCommand.value.onSuccess((user) {
    Navigator.of(context).pop(); // Fecha modal
    SnackBarBase.showSuccess(
      context,
      'Cadastro realizado com sucesso! Bem-vindo, ${user.name}!',
    );
  });
}
```

**Quando usar:**
- Navegar para outra tela após sucesso
- Fechar modais/diálogos
- Exibir mensagens de sucesso
- Atualizar UI com dados retornados

---

#### **4. Combinando `onSuccess()` e `onFailure()` (Padrão Recomendado)**

**Exemplo Real (RegisterModal):**
```dart
void _commandListener() {
  final commandValue = viewModel.registerCommand.value;
  
  // Tratar sucesso
  commandValue.onSuccess((user) {
    Navigator.of(context).pop(); // Fecha o modal
    SnackBarBase.showSuccess(
      context,
      'Cadastro realizado com sucesso! Bem-vindo, ${user.name}!',
    );
  });
  
  // Tratar erro
  commandValue.onFailure((exception) {
    SnackBarBase.showError(
      context,
      exception?.toString() ?? 'Erro ao realizar cadastro',
    );
  });
}
```

**Vantagens:**
- ✅ Código limpo e legível
- ✅ Separação clara de responsabilidades
- ✅ Não executa código se não houver mudança de estado
- ✅ Type-safe (o compilador garante os tipos)

---

#### **5. `getValueOrNull()` - Obter Valor ou Null**
Retorna o valor de sucesso ou `null`.

```dart
final user = viewModel.loginCommand.value.getValueOrNull();
if (user != null) {
  print('Usuário logado: ${user.name}');
}
```

**Quando usar:**
- Verificar se há valor disponível
- Acessar dados sem precisar de `when()`

---

#### **6. `getExceptionOrNull()` - Obter Exceção ou Null**
Retorna a exceção ou `null`.

```dart
final exception = viewModel.loginCommand.value.getExceptionOrNull();
if (exception != null) {
  logger.error(exception.toString());
}
```

**Quando usar:**
- Logging de erros
- Analytics
- Debugging

---

### **Comparação: Antes vs Depois**

#### **Cenário 1: Extrair Mensagem de Erro**

```dart
// ❌ SEM Extension (7 linhas)
if (viewModel.loginCommand.value.isFailure) {
  final errorMessage = viewModel.loginCommand.value.when<String>(
    data: (_) => '',
    failure: (exception) => exception?.toString() ?? 'Erro desconhecido',
    orElse: () => 'Erro desconhecido',
  );
  SnackBarBase.showError(context, errorMessage);
}

// ✅ COM Extension (3 linhas)
viewModel.loginCommand.value.onFailure((exception) {
  SnackBarBase.showError(context, exception?.toString() ?? 'Erro');
});
```

---

#### **Cenário 2: Tratar Sucesso e Erro**

```dart
// ❌ SEM Extension (16 linhas)
if (viewModel.saveCommand.value.isSuccess) {
  final result = viewModel.saveCommand.value.when(
    data: (value) => value,
    failure: (_) => null,
    orElse: () => null,
  );
  if (result != null) {
    Navigator.pop(context);
    SnackBarBase.showSuccess(context, 'Salvo com sucesso!');
  }
} else if (viewModel.saveCommand.value.isFailure) {
  final error = viewModel.saveCommand.value.when(
    data: (_) => null,
    failure: (e) => e,
    orElse: () => null,
  );
  SnackBarBase.showError(context, error?.toString() ?? 'Erro');
}

// ✅ COM Extension (11 linhas)
final commandValue = viewModel.saveCommand.value;

commandValue.onSuccess((result) {
  Navigator.pop(context);
  SnackBarBase.showSuccess(context, 'Salvo com sucesso!');
});

commandValue.onFailure((exception) {
  SnackBarBase.showError(context, exception?.toString() ?? 'Erro');
});
```

---

### **Template Completo de Listener (Padrão Recomendado)**

```dart
void _commandListener() {
  final commandValue = viewModel.[action]Command.value;
  
  // Tratar sucesso
  commandValue.onSuccess((result) {
    // Ações após sucesso:
    // - Navegar para outra tela
    // - Fechar modal
    // - Exibir mensagem de sucesso
    // - Atualizar UI local
    
    SnackBarBase.showSuccess(context, 'Operação realizada com sucesso!');
  });
  
  // Tratar erro
  commandValue.onFailure((exception) {
    // Ações após erro:
    // - Exibir mensagem de erro
    // - Logar exceção
    // - Reverter mudanças locais
    
    SnackBarBase.showError(
      context,
      exception?.toString() ?? 'Erro ao realizar operação',
    );
  });
}
```

---

### **Quando NÃO usar CommandStateExtension:**

Se você precisa de lógica mais complexa no `when()`, use o método nativo:

```dart
// Caso complexo: diferentes ações para diferentes estados
viewModel.command.value.when(
  data: (result) {
    if (result.isEmpty) {
      SnackBarBase.showWarning(context, 'Nenhum resultado encontrado');
    } else {
      SnackBarBase.showSuccess(context, '${result.length} itens carregados');
    }
    return null;
  },
  failure: (e) {
    logger.error('Erro crítico: $e');
    SnackBarBase.showError(context, 'Erro ao carregar dados');
    return null;
  },
  running: () {
    // Ação durante loading
    return null;
  },
  cancelled: () {
    SnackBarBase.showInfo(context, 'Operação cancelada');
    return null;
  },
  orElse: () => null,
);
```

---

## 📊 Resumo: Quando Usar Cada Método

| Método | Caso de Uso | Exemplo |
|--------|-------------|---------|
| `getErrorMessage()` | Exibir erro simples | `SnackBarBase.showError(context, command.value.getErrorMessage())` |
| `onFailure()` | Executar ação após erro | `command.value.onFailure((e) => log(e))` |
| `onSuccess()` | Executar ação após sucesso | `command.value.onSuccess((user) => navigate())` |
| `getValueOrNull()` | Acessar valor sem callback | `final user = command.value.getValueOrNull()` |
| `getExceptionOrNull()` | Logging/Analytics | `logger.error(command.value.getExceptionOrNull())` |

---

**Atualizado em:** 04/06/2026  
**Nova seção:** CommandStateExtension - Métodos Utilitários
