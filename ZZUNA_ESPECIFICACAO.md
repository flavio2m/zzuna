## ✨ Melhorias
| Status | Item |
|--------|------|
| OK | Refatorar a injeção de dependência por feature |
| OK | Ao fazer um novo lançamento, se tiver marcado uma única Conta ou um único
      Cartão, deve preencher esse campo automaticamente no formulário. |
| OK | Colocar uma opção para inverter contas na transferencia |
| OK | Padronizar loading no botão **Salvar** de todos os CRUDs. |
| OK | Implementar navegação entre campos do formulário ao pressionar **Enter**
      (FocusNode / nextFocus). |
| OK | Desabilitar o botão **Salvar** no Create/Update de Lançamento enquanto o 
      formulário estiver inválido. |
| OK | Alterar botão Adicionar para + Entrada e + Despesa |
| OK | Colocar um loading em Lancamentos quando mudar o mês/ano |
| OK | Implementar o fechamento do mês |
| OK | No lançamento recorrente, colocar o número de lançamento sendo sequência
      1, 2, 3, etc. No momento de criar o lançamento, deve inserir a sequência
      tabém no final da descrição (LancamentoGrupoRecorrencia.sequencia)
      (ex: Recorrência Aluguel - 1, Recorrência Aluguel - 2, etc.)
      - Criar opção para alterar a sequência: o usuário poderar criar uma recorrência
      será 1, mas em ações poderá definir que aquela é a 20, por exemplo, o 
      próximo a ser gerado será o 21.
| OK | Ajustar para que o lançamento em Cartão de Crédito observe a data de
      fechamento da fatura, ou seja, se a fatura fecha dia 10, o lançamento
      deve ser lançado no dia 11 para entrar no próximo mês.
| OK | Implementar o sobre com data de compilação
| ☐ | Implementar opção para Excluir dados
| ☐ | Criar uma opção para exportar lançamentos no formato XLS (lançamentos do mês) 
| ☐ | Ciar opção para importar lançamentos (entradas/saídas) de uma planilha XLS
---
| ☐ | Analisar viabilidade e implementar cache local (APÓS IMPLEMENTAR FIREBASE):
      - CRUD Simples: Centro de Custo, Categoria e Conta/Cartão
      - CRUD Complexos: Lançamento e ExtratoFatura|
flavio2m@gmail.com
---

## 🚀 Funcionalidades
| Status | Item |
|--------|------|
| OK | Implementar Transferência de lançamentos. |
| OK | Alterar descrição e observação para aplicar automaticamente ao grupo do
       lançamentos (parcelamento, replicação e transferência). |
| OK | Alterar data para todo o grupo de lançamentos. |
| OK | Alterar Centro de Custo, Categoria e Valor para todo o grupo de lançamentos. |
| OK | Alterar Conta/Cartão para todo o grupo de lançamentos. |
| OK | Alterar Conta/Cartão para todos os lançamentos selecionados. |
| OK | Implementar Lançamentos por Recorrência. |
```
