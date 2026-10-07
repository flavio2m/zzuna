import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';
import 'package:zzuna/domain/statics/banco/banco_regiao.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transaction_row.dart';

void main() {
  final extratoFake = ExtratoFaturaDetails(
    id: 'ef-1',
    origem: LancamentoOrigemContaDetail(
      conta: ContaDetails(
        id: 'c-1',
        descricao: 'Conta 1',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
        banco: const Banco(
          descricao: 'Banco 1',
          sigla: 'B1',
          icon: BancoIcon.outros,
          regiao: RegiaoBanco.brasil,
        ),
      ),
    ),
    ano: 2026,
    mes: Mes.janeiro,
    dataInicio: DateTime(2026, 1, 1),
    dataFim: DateTime(2026, 1, 31),
    saldoInicial: 0.0,
    saldoFinal: 0.0,
    fechado: false,
  );

  final contaOrigem = LancamentoOrigemContaDetail(
    conta: ContaDetails(
      id: 'c-1',
      descricao: 'BC Novo Banco',
      ativo: true,
      dataInicial: DateTime(2026, 1, 1),
      banco: const Banco(
        descricao: 'Novo Banco',
        sigla: 'NB',
        icon: BancoIcon.outros,
        regiao: RegiaoBanco.brasil,
      ),
    ),
  );

  const centroCusto = CentroCustoDetails(
    id: 'cc-1',
    descricao: 'Moradia',
    ativo: true,
  );

  const categoriaPai = CategoriaDetails(
    id: 'cat-pai',
    descricao: 'Transporte',
    ativo: true,
    categoriaPai: null,
    subcategorias: [],
    cor: '#0084FF',
    natureza: CategoriaNatureza.saida,
  );

  const categoriaFilha = CategoriaDetails(
    id: 'cat-filha',
    descricao: 'Combustível',
    ativo: true,
    categoriaPai: categoriaPai,
    subcategorias: [],
    cor: null, // Herda a cor do pai (#0084FF)
    natureza: CategoriaNatureza.saida,
  );

  const categoriaFilha2 = CategoriaDetails(
    id: 'cat-filha-2',
    descricao: 'Manutenção',
    ativo: true,
    categoriaPai: categoriaPai,
    subcategorias: [],
    cor: '#F43F85',
    natureza: CategoriaNatureza.saida,
  );

  Widget createWidget(LancamentoDetails lancamento) {
    return MaterialApp(
      home: Scaffold(
        body: TransactionRow(
          lancamentoId: lancamento.id,
          description: lancamento.descricao,
          origem: lancamento.origem,
          value: '60,00',
          reconcileButton: const SizedBox.shrink(),
          lancamento: lancamento,
        ),
      ),
    );
  }

  testWidgets(
    'exibe a categoria filha em formato de tag e omite centro de custo',
    (tester) async {
      final lancamento = LancamentoDetails(
        id: 'l-1',
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 1, 15),
        descricao: 'Combustível - 3',
        extratoFatura: extratoFake,
        origem: contaOrigem,
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            centroCusto: centroCusto,
            categoria: categoriaFilha,
            valor: 60.0,
          ),
        ],
        conciliado: false,
        anoMes: 202601,
      );

      await tester.pumpWidget(createWidget(lancamento));

      // Deve exibir o nome da categoria filha na tag
      expect(find.text('Combustível'), findsOneWidget);

      // Deve exibir Tooltip com o valor do item da categoria
      expect(
        find.byWidgetPredicate((w) => w is Tooltip && w.message == 'R\$ 60,00'),
        findsOneWidget,
      );

      // NÃO deve exibir o caminho hierárquico "Transporte > Combustível"
      expect(find.textContaining('Transporte > Combustível'), findsNothing);

      // NÃO deve exibir o Centro de Custo
      expect(find.textContaining('CC:'), findsNothing);
      expect(find.textContaining('Moradia'), findsNothing);
    },
  );

  testWidgets(
    'exibe multiplas tags quando o lancamento possui itens com categorias distintas',
    (tester) async {
      final lancamento = LancamentoDetails(
        id: 'l-2',
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 1, 15),
        descricao: 'Despesa Múltipla',
        extratoFatura: extratoFake,
        origem: contaOrigem,
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            centroCusto: centroCusto,
            categoria: categoriaFilha,
            valor: 25.0,
          ),
          LancamentoItemDetailsStandard(
            numero: 2,
            centroCusto: centroCusto,
            categoria: categoriaFilha2,
            valor: 35.0,
          ),
        ],
        conciliado: false,
        anoMes: 202601,
      );

      await tester.pumpWidget(createWidget(lancamento));

      // Deve exibir tags para ambas as categorias
      expect(find.text('Combustível'), findsOneWidget);
      expect(find.text('Manutenção'), findsOneWidget);

      // Deve exibir Tooltip com os valores de cada item nas tags
      expect(
        find.byWidgetPredicate((w) => w is Tooltip && w.message == 'R\$ 25,00'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is Tooltip && w.message == 'R\$ 35,00'),
        findsOneWidget,
      );
      expect(find.textContaining('CC:'), findsNothing);
    },
  );

  testWidgets('exibe Sem categoria quando o lancamento nao possui itens', (
    tester,
  ) async {
    final lancamento = LancamentoDetails(
      id: 'l-3',
      tipo: LancamentoTipo.despesa,
      data: DateTime(2026, 1, 15),
      descricao: 'Sem itens',
      extratoFatura: extratoFake,
      origem: contaOrigem,
      itens: const [],
      conciliado: false,
      anoMes: 202601,
    );

    await tester.pumpWidget(createWidget(lancamento));

    expect(find.text('Sem categoria'), findsOneWidget);
  });

  testWidgets(
    'exibe icone de observacao com tooltip quando houver observacao',
    (tester) async {
      final lancamento = LancamentoDetails(
        id: 'l-4',
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 1, 15),
        descricao: 'Combustível com obs',
        extratoFatura: extratoFake,
        origem: contaOrigem,
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            centroCusto: centroCusto,
            categoria: categoriaFilha,
            valor: 50.0,
          ),
        ],
        conciliado: false,
        anoMes: 202601,
        observacao: 'Abastecido no posto Shell com desconto',
      );

      await tester.pumpWidget(createWidget(lancamento));

      // Deve exibir o ícone de observação
      expect(find.byIcon(Icons.sticky_note_2_outlined), findsOneWidget);

      // Deve exibir o Tooltip com a mensagem da observação
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Tooltip &&
              w.message == 'Abastecido no posto Shell com desconto',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'nao exibe icone de observacao quando observacao for nula ou vazia',
    (tester) async {
      final lancamentoSemObs = LancamentoDetails(
        id: 'l-5',
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 1, 15),
        descricao: 'Sem observacao',
        extratoFatura: extratoFake,
        origem: contaOrigem,
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            centroCusto: centroCusto,
            categoria: categoriaFilha,
            valor: 50.0,
          ),
        ],
        conciliado: false,
        anoMes: 202601,
        observacao: null,
      );

      await tester.pumpWidget(createWidget(lancamentoSemObs));

      expect(find.byIcon(Icons.sticky_note_2_outlined), findsNothing);
    },
  );
}
