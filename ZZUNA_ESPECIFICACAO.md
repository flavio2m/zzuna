📱 ESPECIFICAÇÃO FINAL – ZZuna (PRONTA PARA IA)
1. OBJETIVO DO APP
Aplicativo de controle financeiro pessoal onde:
o Lançamento é a entidade central
suporta:
cartão de crédito (com fatura)
conta (com extrato)
parcelamento
rateio
relatórios futuros
A linguagem utilizada será Flutter com arquitetura padrão recomendada na documentação do flutter, visando uma estrutura simples de se manter (aplicativo de pequeno porte). 
Gerenciamento de estado deve ser utilizado o Riverpod. 
Inicialmente será uma aplicação web, futuramente será criado um APP. 


🧱 2. MODELO CONCEITUAL (BASE PARA IMPLEMENTAÇÃO)
2.1 Entidades principais
Lançamento
Representa uma transação financeira.
Campos obrigatórios:
id
data
descricao
tipo: RECEITA | DESPESA | TRANSFERENCIA
valorTotal
tipoOrigem: CONTA | CARTAO
origemId
documentoId (fatura ou extrato)
status: PENDENTE | CONSOLIDADO
grupoId (nullable)
tipoGrupo: PARCELAMENTO | TRANSFERENCIA | REPLICACAO | NULL
parcelaNumero (nullable)
totalParcelas (nullable)
observacao

Item do Lançamento (RATEIO)
Campos:
id
lancamentoId
categoriaId
centroCustoId
valor
📌 REGRA:
todo lançamento tem pelo menos 1 item

Documento (Fatura / Extrato)
Campos:
id
tipo: FATURA | EXTRATO
origemId (conta ou cartão)
dataInicio
dataFim
mesReferencia
anoReferencia
status: ABERTA | FECHADA

⚙️ 3. REGRAS DE NEGÓCIO (DOMÍNIO)
3.1 Determinar documento automaticamente
Cartão:
usar diaFechamento
calcular intervalo
encontrar fatura correspondente
Conta:
usar mês da data
extrato mensal fixo (1 → último dia)

3.2 Grupo de Lançamentos
grupoId agrupa lançamentos relacionados
usado para:
parcelamento
replicação
transferência

3.3 Rateio
1 lançamento → N itens
soma dos itens = valorTotal

3.4 Parcelamento
gera N lançamentos
todos com mesmo grupoId
cada um com:
parcelaNumero
totalParcelas

3.5 Transferência
gera 2 lançamentos:
saída (DESPESA)
entrada (RECEITA)
ambos com mesmo grupoId

🎯 4. CASOS DE USO (AÇÃO DO USUÁRIO)
Agora vem a parte MAIS IMPORTANTE para IA.

🧾 4.1 Criar lançamento (cartão à vista)
Fluxo:
Usuário clica em “Adicionar lançamento”
Seleciona:
Tipo: Despesa
Origem: Cartão
Preenche:
Data
Descrição
Categoria
Centro de custo
Valor
Sistema:
identifica fatura automaticamente
cria 1 lançamento
cria 1 item

💳 4.2 Compra parcelada (dividir valor)
Entrada:
valor: 75
parcelas: 7
Fluxo:
Usuário ativa opção “Dividir”
Informa quantidade de parcelas
Sistema:
calcula valores:
parcela 1: 10,74
demais: 10,71
gera grupoId
cria 7 lançamentos:
cada um com parcelaNumero
cada um em sua fatura correta
cada lançamento cria 1 item

🔁 4.3 Replicar parcelas
Entrada:
valor: 100
parcela inicial: 5
parcela final: 10
Sistema:
gera 5 lançamentos
todos com mesmo valor
grupoId igual

✂️ 4.4 Rateio (MULTI-CATEGORIA)
Entrada:
valor total: 1000
Fluxo:
Usuário clica “Detalhar”
adiciona linhas:
Categoria A → 300
Categoria B → 700
Sistema:
cria 1 lançamento
cria 2 itens:
item A = 300
item B = 700

🔄 4.5 Editar lançamento
Se NÃO tem grupo:
altera normalmente
Se tem grupo:
mostrar opções:
editar apenas este
editar a partir deste
editar todos

🚫 4.6 Validações
não permitir lançamento em fatura fechada
confirmar lançamento > 30 dias futuro
soma do rateio deve bater com total
não permitir conta/cartão inativo

🏦 4.7 Lançamento em conta
Mesmo fluxo do cartão, porém:
documento = extrato
não usa lógica de fechamento

🗄️ 5. ESTRUTURA NO FIREBASE (Realtime Database)
{
 "lancamentos": {
   "id_1": { ... }
 },
 "itens": {
   "id_1": { ... }
 },
 "contas": {},
 "cartoes": {},
 "documentos": {},
 "categorias": {},
 "centroCustos": {}
}

📊 6. REGRAS PARA RELATÓRIOS (IMPORTANTE PARA IA)
REGRA GLOBAL:
👉 usar ITENS, não apenas lançamentos

Exemplos:
Total por categoria
somar itens por categoriaId
Total por centro de custo
somar itens por centroCustoId
Total da fatura
somar valorTotal dos lançamentos

🧠 7. DECISÕES IMPORTANTES (PARA O AGENTE DE IA)
NÃO criar entidade Grupo separada
usar grupoId dentro do lançamento
SEMPRE criar item (mesmo sem rateio)
separar claramente:
lançamento (evento)
item (classificação financeira)


Deve utilizar a lingu
Crie uma tela Flutter para um aplicativo de controle financeiro pessoal chamado ZZuna.

A arquitetura deve seguir a arquitetura da documentação do flutter, na medida do possível, tornarndo mais simples possível (use case, por exemplo, somente para coisas complexas.

--------------------------------------------------
LAYOUT GERAL
--------------------------------------------------

A tela principal deve ser composta por 3 áreas:

1. Sidebar esquerda fixa
2. Topbar (filtros e ações)
3. Lista principal de lançamentos

Utilizar Row no nível principal:
- esquerda: sidebar (largura fixa ~280px)
- direita: conteúdo expandido

--------------------------------------------------
SIDEBAR (FILTROS)
--------------------------------------------------

Criar um widget Sidebar com:

Seções:
- Contas
- Busca rápida
- Categorias (hierárquico)

Categorias devem ser exibidas como árvore:
- suporte a expansão/recolhimento
- checkbox por item
- até 3 níveis

Cada item:
- ícone de expandir
- label
- checkbox

Estado:
- múltipla seleção
- influencia lista principal (filtro)

--------------------------------------------------
TOPBAR
--------------------------------------------------

Na parte superior da área principal:

Componentes:
- Dropdown de mês/ano (ex: Março/2026)
- Dropdown de filtro (ex: "Todas as transações")
- Botões:
- Adicionar transação
- Confirmar
- Excluir
- Alterar categoria
- Exportar

Layout horizontal com espaçamento

--------------------------------------------------
LISTA DE LANÇAMENTOS
--------------------------------------------------

Lista deve ser agrupada por DATA

Estrutura:
ListView -> grupos -> itens

Cada grupo contém:
- Cabeçalho com:
- Data (ex: 01/03/2026, Domingo)
- Saldo do dia (direita)

Itens abaixo do cabeçalho

--------------------------------------------------
ITEM DE LANÇAMENTO
--------------------------------------------------

Cada item deve conter:

- Checkbox (seleção)
- Descrição (ex: "Compra Magalu (3/10)")
- Categoria
- Conta
- Valor (formatado em R$)
- Indicador visual:
- Verde para receita
- Vermelho para despesa

Se for parcelado:
- mostrar "(parcelaAtual/totalParcelas)"

Se fizer parte de grupo:
- manter consistência visual

--------------------------------------------------
COMPORTAMENTO
--------------------------------------------------

- Clique no item → abrir edição
- Checkbox → seleção múltipla
- Seleção ativa → habilita ações em lote

--------------------------------------------------
DADOS (IMPORTANTE)
--------------------------------------------------

A lista deve ser baseada nas seguintes entidades:

Lançamento:
- id
- data
- descricao
- tipo (RECEITA, DESPESA)
- valorTotal
- grupoId
- parcelaNumero
- totalParcelas

Item do Lançamento:
- categoriaId
- centroCustoId
- valor

Categoria:
- estrutura hierárquica

Conta:
- nome da conta

--------------------------------------------------
REGRAS IMPORTANTES
--------------------------------------------------

- Agrupar por data do lançamento
- Ordenar por data desc
- Mostrar saldo do dia
- Formatar valores:
- Receita: verde (+)
- Despesa: vermelho (-)

--------------------------------------------------
ESTILO VISUAL
--------------------------------------------------

- Layout semelhante a sistemas financeiros (tipo "Minhas Economias")
- Linhas com hover
- Separadores leves
- Tipografia simples
- Fundo claro

--------------------------------------------------
ESTRUTURA DE WIDGETS
--------------------------------------------------

Criar componentes separados:

- MainScreen
- SidebarWidget
- TopbarWidget
- TransactionList
- TransactionGroup
- TransactionItem

--------------------------------------------------
EXTRA (IMPORTANTE)
--------------------------------------------------

- Código deve ser limpo e organizado
- Separar widgets em arquivos
- Preparado para integração com backend (Firebase)
APP ZZuna - Controle Financeiro Pessoal


ZZuna é um aplicativo para controle financeiro pessoal.
Tecnologias utilizadas:
Flutter
Realtime Database
Segue a arquitetura oficial do Flutter disponível em https://docs.flutter.dev/app-architecture/concepts 




Funcionalidades:
1. Cadastro de Contas: a conta tem uma Descrição, Saldo, Banco e Status (Ativo/Inativo)
O banco será um cadastro simples dos principais bancos, tendo uma Descrição (nome do banco), uma Sigla, uma Ícone e situação (Ativo e Inativo).

Bancos:
Descrição
Sigla
Link Ícone
Banco do Brasil
BB


Bradesco
BRA


Itaú
ITA


Caixa Econômica Federal
CEF


Santander
SAN


Nubank
NUB


Sicoob
SCO


Inter
INT


Banco do Nordeste
BNB


Sicredi
SIC


C6
C6


Outros
OUT






2. Cadastro de Cartão de Crédito: o  Cartão de Crédito tem uma Descrição, Saldo, Banco e Status (Ativo/Inativo) (semelhante a uma conta), mas tem o dia de fechamento da fatura.

3. Faturas/Extratos: as faturas/extratos estarão relacionadas com um Cartão de Crédito ou com uma Conta e terão uma data de início, data fim, um mês (uma lista dos meses de Janeiro a Dezembro, pode utilizar tuplas 1=Janeiro, 2=Fevereiro, etc) e uma situação Aberta/Fechado (pode ser booleano).
Ao cadastrar um cartão de crédito ou uma conta será necessário informar o mês da primeira Fatura ou ao cadastrar uma conta será necessário informar o mês do primeiro Extrato.
A Fatura será o termo utilizado para Cartão de Crédito e Extrato o termo utilizado para para Conta.
A data de início da Fatura será gerada com base no Dia de Fechamento da fatura cadastrado no Cartão de Crédito e no caso do Extrato sempre será do primeiro dia ao último dia do mês.
A Fatura terá uma característica diferente do extrato no sentido de que a Fatura do mês vai, na maioria das vezes, contemplar compras do mês anterior:
No Cartão de Crédito está cadastrado Data de Fechamento da Fatura dia 25: ao gerar uma fatura de Janeiro, terá data de início dia 26/11 a 25/12. Ao gerar a fatura de Fevereiro, terá data de início dia 26/12 a 25/01 e assim por diante. 

A lista de meses será para definir ao qual mês pertence a fatura futuramente, por exemplo: se no cartão estiver cadastrado que as compras do dia 20/01 a 19/02 pertence à fatura de Março;

4. Cadastro de Categoria de Lançamento (Despesas e Receitas): a Categoria de Lançamento tem uma Descrição, uma Categoria de Lançamento (aninhado) e uma situação (Ativo e Inativo).
As Categorias principais não terão uma Categoria selecionada (raiz) e dentro de cada Categoria principal terão as subcategorias. Para não prejudicar o layout, uma Categoria poderá ter até três níveis (Categoria Raiz > Categoria Subcategoria nível 1 >  Categoria Subcategoria nível 2).

5. Centro de Custo: o Centro de Custo terá uma Descrição e uma Situação Ativo/Inativo
  
6. Lançamento: o lançamento será o cadastro principal, tudo estará relacionado ao Lançamento. 
O Lançamento terá os seguintes dados:
Data: data que ocorreu a transação (compra, pagamento, transferência, etc)
Descrição
Tipo: Receita, Despesa, Transferência (transferência de uma conta para outra)
Categoria: Categoria de Lançamento
Centro de Custo
Conta ou Cartão de Crédito (um dos dois, nunca ambos)
Fatura ou Extrato (um dos dois, nunca ambos)
Valor
Recorrente: campo booleano para identificar um lançamento que foi gerado de forma recorrente
Lançamento: relação com outro lançamento, por exemplo, quando houver uma compra parcelada, todos os lançamentos terão definido esse campo igual.
Parcela: utilizado para identificar a parcela quando for um lançamento parcelado (compra parcelada)
Status: Consolidado/Pendente
Observação

6.1 Lançamento de compra com cartão a vista
Ao adicionar uma nova compra será apresentado ao usuário a opção para definir a data que ocorreu a compra, na descrição irá colocar a descrição (Compra no IG), tipo será automaticamente definido como Despesa (porque é uma compra no cartão), irá selecionar a Categoria (Alimentação), irá selecionar o Centro de Curso (Geral), irá selecionar o cartão (se já tiver exibindo lançamentos do cartão irá ser preenchido automaticamente) e irá definir um valor. Será definido automaticamente a qual fatura pertence o lançamento com base na data. 
Ao editar o lançamento será exibido opção para alterar os mesmos dados
Validações: 
1 Se for lançamento retroativo e a Fatura estiver fechada deve exibir mensagem dizendo que não é possível inserir novos lançamentos em uma fatura já fechada.
2 Se o lançamento for para além de 30 dias deve exibir uma mensagem pedindo confirmação para lançamento futuro

6.2 Lançamento de compra com cartão parcelada
Ao adicionar uma nova compra será apresentado ao usuário a opção para definir a data que ocorreu a compra, na descrição irá colocar a descrição (Riachuelo Blusa de Frio), tipo será automaticamente definido como Despesa (porque é uma compra no cartão), irá selecionar a Categoria (Roupas), irá selecionar o Centro de Curso (Marcos), irá selecionar o cartão (se já tiver exibindo lançamentos do cartão irá ser preenchido automaticamente) e irá definir um valor total 75,00, em seguida irá clicar na opção Dividir, será exibido uma opção para informar Quantas parcelas (7 parcelas), o sistema deve dividir o valor total por 7 sendo que os valores fracionados menores que 1 centavo deve ser adicionados na primeira parcela: Parcela 1: 10,74  Parcela 2…7: 10,71.
Será definido automaticamente a qual fatura pertence o lançamento com base na data. 
Será gerados 7 lançamentos de forma automática cada um com seu número de parcela e será necessário criar uma relação entre esses lançamentos.
Ao editar um dos 7 lançamentos (por exemplo, o primeiro), será exibido as opções para editar os dados como no caso 6.1, porém terá uma opção para Aplicar Alterações a partir deste, ou seja, se alterar a descrição ou o valor e aplicar nos demais, todos os outros 6 lançamentos devem ser alterados conforme o primeiro, com excessão do número de parcelas que sempre será fixo. 

6.3 Lançamento de compra parcelada com cartão replicando parcelas
Ao adicionar uma nova compra será apresentado ao usuário a opção para definir a data que ocorreu a compra, na descrição irá colocar a descrição (Riachuelo Blusa de Frio), tipo será automaticamente definido como Despesa (porque é uma compra no cartão), irá selecionar a Categoria (Roupas), irá selecionar o Centro de Curso (Marcos), irá selecionar o cartão (se já tiver exibindo lançamentos do cartão irá ser preenchido automaticamente) e irá definir um valor total 100,00, em seguida irá clicar na opção Replicar Parcelas, será exibido uma opção para informar a parcela inicial (exemplo 5) e a parcela final (exemplo 10), o sistema deve exibir de alguma forma o valor total final de todas as parcelas 500,00. 
Será definido automaticamente a qual fatura pertence o lançamento com base na data. 
será gerado os 5 lançamentos no valor de 100,00 cada um iniciando as parcelas em 5 e terminando em 10 e será necessário criar uma relação entre esses lançamentos.
Ao editar um dos 5 lançamentos (por exemplo, o primeiro), será exibido as opções para editar os dados como no caso 6.1, porém terá uma opção para Aplicar Alterações a partir deste, ou seja, se alterar a descrição ou o valor e aplicar nos demais, todos os outros 4 demais lançamentos devem ser alterados conforme o primeiro, com excessão do número de parcelas que sempre será fixo. 


6.4 Lançamento de compra com rateio
Ao adicionar uma nova compra será apresentado ao usuário a opção para definir a data que ocorreu a compra, na descrição irá colocar a descrição (Supermercado Gonçalves), tipo será automaticamente definido como Despesa (porque é uma compra no cartão), irá  definir um valor total 1.000,00 e irá clicar em detalhar.
Ao clicar em detalhar será exibido duas linhas para o usuário inserir:
a descrição para A e B (opcionais)
o Centro de Custo A e B, 
a Categoria A e B
opção para preencher o valor de A e B ou opção para preencher o percentual de A ou B. Se optado por percentual, ao preencher 30, 30% do valor total vai ser definido para o A e o restante (70%) para o B
O usuário pode adicionar mais linhas para ratear o valor criando a opção C
No final, a soma dos valores A, B, n, etc deve ser igual ao valor do lançamento.
A fatura e demais campos será preenchido de forma automática, conforme exemplos anteriores. 
O recurso de rateio é muito importante e deve ser possível para qualquer tipo de lançamento, portanto, internamento sempre terá que gerar esse detalhamento.


6.5 Lançamento na conta
Segue o mesmo princípio do cartão de crédito.


RECOMENDAÇÃO PARA CRIAR
Minha recomendação

A sequência que considero mais segura e alinhada ao padrão simples que você vem adotando é:

Entidades (Lancamento, LancamentoItem, Documento).
DTOs de criação, atualização e filtro.
Repository com CRUD e seeds.
Testes do Repository para validar a persistência e as regras básicas.
CRUD simples da tela de Lançamentos (sempre criando um único Lancamento e um único LancamentoItem).
Adicionar as regras de negócio complexas em etapas (documento automático, parcelamento, replicação, rateio e transferência).

Essa abordagem reduz muito a chance de o LLM gerar código difícil de manter e permite validar o domínio antes de adicionar comportamentos mais sofisticados. Além disso, ela combina com a arquitetura simples que você já consolidou nas demais features do projeto.


```md
# Backlog - ZZuna Finance

## 🐞 Correções
| Status | Item |
|--------|------|
| OK |  Corrigir cálculo do saldo inicial e saldo final do resumo financeiro
        (considerar todas as contas/cartões selecionados, mesmo sem lançamentos). |

---

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
| ☐ | Implementar o fechamento do mês |
| ☐ | Colocar um loading em Lancamentos quando mudar o mês/ano |
| ☐ | Analisar viabilidade e implementar cache local:
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
