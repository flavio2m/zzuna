# USECASES

## Use quando

* Existir regra de negócio relevante
* Existir processamento de domínio
* Existir transformação de dados
* Existir agregação de informações
* Consumir múltiplos Repositories
* Construir objetos ricos (`EntityDetails`)
* O método ultrapassar aproximadamente 30 linhas
* O mesmo processamento for reutilizado por mais de uma ViewModel

---

## Não criar UseCase quando

* Apenas chamar um Repository
* Apenas executar CRUD
* Apenas delegar uma operação sem processamento
* Consumir apenas um Repository com lógica simples
* O código for simples o suficiente para permanecer na ViewModel

❌ Exemplo incorreto:

```dart
class GetContaUseCase {
  final ContaRepository repository;

  GetContaUseCase(this.repository);

  AsyncResult<Conta> call(String id) {
    return repository.getById(id);
  }
}
```

---

## Regras

* Nome termina com `UseCase`
* Criar em `domain/usecases`
* Deve possuir apenas uma responsabilidade
* Não acessar UI
* Não acessar Widgets
* Não acessar BuildContext
* Não acessar Providers
* Não acessar Commands
* Pode consumir um ou mais Repositories
* Pode consumir Services de domínio
* Deve retornar `Result<T>` ou `AsyncResult<T>`
* Método público deve ser `call()`
* Métodos auxiliares devem ser privados (`_`)

---

## EntityDetails

Objetos ricos (`EntityDetails`) devem ser criados em UseCases quando dependerem de:

* Múltiplos Repositories
* Agregação de dados
* Regras de negócio

Exemplo:

```text
Lancamento
+
Conta
+
Cartao
+
Documento
↓
LancamentoDetails
```

---

## ViewModel x UseCase

Se o enriquecimento utilizar apenas:

* Catálogos estáticos
* Enums
* Conversões simples
* Dados locais

A conversão pode ser feita diretamente na ViewModel.

Exemplo:

```text
Conta
↓
ContaDetails
```

```text
Cartao
↓
CartaoDetails
```

---

## Casos comuns

### Agregação

```text
Lancamento
+
Conta
+
Cartao
+
Documento
↓
LancamentoDetails
```

---

### Processamento

```text
Lista de Lancamentos
↓
Agrupar por data
↓
LancamentosPorDia
```

---

### Transformação

```text
Lista de Lancamentos
↓
Dados para gráfico
↓
LancamentosGrafico
```

---

### Regra de negócio

```text
Lancamento parcelado
↓
Gerar N lançamentos
↓
Mesmo grupoId
```

---

### Regra de negócio

```text
Transferência
↓
Gerar lançamento de saída
+
Gerar lançamento de entrada
↓
Mesmo grupoId
```

---

## Não fazer

* CRUD simples
* Consultas simples
* Filtros simples
* Pesquisas simples
* Acesso direto à UI
* Acesso direto a Providers
* Estado visual

---

## Template

```dart
import 'package:result_dart/result_dart.dart';

class ExampleUseCase {
  AsyncResult<Output> call(
    Input input,
  ) async {
    // processamento
  }
}
```

---

## Exemplo simples

```dart
class CreateTransferenciaUseCase {
  final LancamentoRepository repository;

  CreateTransferenciaUseCase(
    this.repository,
  );

  AsyncResult<List<Lancamento>> call(
    TransferenciaDto dto,
  ) async {
    // gera lançamento de saída
    // gera lançamento de entrada
    // persiste ambos
  }
}
```

---

## Exemplo complexo

```dart
class GetLancamentoDetailsUseCase {
  final LancamentoRepository lancamentoRepository;
  final ContaRepository contaRepository;
  final CartaoRepository cartaoRepository;
  final DocumentoRepository documentoRepository;

  GetLancamentoDetailsUseCase(
    this.lancamentoRepository,
    this.contaRepository,
    this.cartaoRepository,
    this.documentoRepository,
  );

  AsyncResult<LancamentoDetails> call(
    String id,
  ) async {
    // agregação de múltiplos repositories
  }
}
```
