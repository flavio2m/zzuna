import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/orcamento/get_orcamento_comparativo_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

void main() {
  late GetOrcamentoComparativoUseCase useCase;

  setUp(() {
    useCase = GetOrcamentoComparativoUseCase();
  });

  const catAlimentacaoPai = Categoria(
    id: 'cat-alim',
    descricao: 'Alimentação',
    natureza: CategoriaNatureza.saida,
    percentualOrcamento: 30, // 30% de 5000 = 1500
    cor: '#0084FF',
    ativo: true,
  );

  const catAlimentacaoDetailsPai = CategoriaDetails(
    id: 'cat-alim',
    descricao: 'Alimentação',
    natureza: CategoriaNatureza.saida,
    percentualOrcamento: 30,
    cor: '#0084FF',
    ativo: true,
    categoriaPai: null,
    subcategorias: [],
  );

  const catSupermercadoFilha = CategoriaDetails(
    id: 'cat-super',
    descricao: 'Supermercado',
    natureza: CategoriaNatureza.saida,
    categoriaPai: catAlimentacaoDetailsPai,
    ativo: true,
    subcategorias: [],
  );

  const catLazerPai = Categoria(
    id: 'cat-lazer',
    descricao: 'Lazer',
    natureza: CategoriaNatureza.saida,
    percentualOrcamento: 10, // 10% de 5000 = 500
    cor: '#FF6B00',
    ativo: true,
  );

  const catLazerDetailsPai = CategoriaDetails(
    id: 'cat-lazer',
    descricao: 'Lazer',
    natureza: CategoriaNatureza.saida,
    percentualOrcamento: 10,
    cor: '#FF6B00',
    ativo: true,
    categoriaPai: null,
    subcategorias: [],
  );

  const catSemOrcamento = Categoria(
    id: 'cat-outros',
    descricao: 'Outros',
    natureza: CategoriaNatureza.saida,
    cor: '#64748B',
    ativo: true,
  );

  const catSemOrcamentoDetails = CategoriaDetails(
    id: 'cat-outros',
    descricao: 'Outros',
    natureza: CategoriaNatureza.saida,
    cor: '#64748B',
    ativo: true,
    categoriaPai: null,
    subcategorias: [],
  );

  const centroCusto = CentroCustoDetails(
    id: 'cc-1',
    descricao: 'Pessoal',
    ativo: true,
  );

  final contaDetails = ContaDetails(
    id: 'c1',
    descricao: 'BC Banco do Brasil',
    banco: Bancos.bySigla('BB').getOrThrow(),
    ativo: true,
    dataInicial: DateTime(2026, 1, 1),
  );

  final extratoDetails = ExtratoFaturaDetails(
    id: 'ef1',
    ano: 2026,
    mes: Mes.outubro,
    dataInicio: DateTime(2026, 10, 1),
    dataFim: DateTime(2026, 10, 31),
    origem: LancamentoOrigemContaDetail(conta: contaDetails),
    saldoInicial: 1000.0,
    saldoFinal: 5000.0,
    fechado: false,
  );

  test('calcula comparativo de orçamento previsto vs real corretamente', () {
    final lancamentos = [
      // Despesa 1: R$ 600 na subcategoria Supermercado (deve somar na Alimentação)
      LancamentoDetails(
        id: 'l-1',
        descricao: 'Mercado',
        tipo: LancamentoTipo.despesa,
        extratoFatura: extratoDetails,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        conciliado: true,
        anoMes: 202610,
        data: DateTime(2026, 10, 5),
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            valor: 600.0,
            categoria: catSupermercadoFilha,
            centroCusto: centroCusto,
          ),
        ],
      ),
      // Despesa 2: R$ 400 diretamente na Categoria Alimentação
      LancamentoDetails(
        id: 'l-2',
        descricao: 'Restaurante',
        tipo: LancamentoTipo.despesa,
        extratoFatura: extratoDetails,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        conciliado: true,
        anoMes: 202610,
        data: DateTime(2026, 10, 10),
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            valor: 400.0,
            categoria: catAlimentacaoDetailsPai,
            centroCusto: centroCusto,
          ),
        ],
      ),
      // Despesa 3: R$ 600 no Lazer (estourou orçamento: 600 > 500)
      LancamentoDetails(
        id: 'l-3',
        descricao: 'Cinema e Viagem',
        tipo: LancamentoTipo.despesa,
        extratoFatura: extratoDetails,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        conciliado: true,
        anoMes: 202610,
        data: DateTime(2026, 10, 12),
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            valor: 600.0,
            categoria: catLazerDetailsPai,
            centroCusto: centroCusto,
          ),
        ],
      ),
      // Despesa 4: R$ 200 fora do orçamento
      LancamentoDetails(
        id: 'l-4',
        descricao: 'Diversos',
        tipo: LancamentoTipo.despesa,
        extratoFatura: extratoDetails,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        conciliado: true,
        anoMes: 202610,
        data: DateTime(2026, 10, 15),
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            valor: 200.0,
            categoria: catSemOrcamentoDetails,
            centroCusto: centroCusto,
          ),
        ],
      ),
      // Receita: não deve interferir no orçamento de despesas
      LancamentoDetails(
        id: 'l-5',
        descricao: 'Salário',
        tipo: LancamentoTipo.receita,
        extratoFatura: extratoDetails,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        conciliado: true,
        anoMes: 202610,
        data: DateTime(2026, 10, 1),
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            valor: 5000.0,
            categoria: catSemOrcamentoDetails,
            centroCusto: centroCusto,
          ),
        ],
      ),
    ];

    final result = useCase.execute(
      rendaReferencia: 5000.0,
      categoriasPai: const [catAlimentacaoPai, catLazerPai, catSemOrcamento],
      lancamentos: lancamentos,
    );

    expect(result.rendaReferencia, 5000.0);
    expect(result.totalPrevisto, 2000.0); // 1500 + 500
    expect(result.totalReal, 1600.0); // 1000 + 600
    expect(result.saldoTotal, 400.0); // 2000 - 1600
    expect(result.percentualGeralUtilizado, 80.0); // (1600 / 2000) * 100
    expect(result.estourouGeral, isFalse);
    expect(result.totalDespesasForaOrcamento, 200.0);
    expect(result.categorias.length, 2);

    // Categoria Alimentação
    final alim = result.categorias.firstWhere(
      (c) => c.categoria.id == 'cat-alim',
    );
    expect(alim.valorPrevisto, 1500.0);
    expect(alim.valorReal, 1000.0);
    expect(alim.saldoRestante, 500.0);
    expect(alim.estourou, isFalse);
    expect(alim.valorExcedente, 0.0);
    expect(alim.percentualUtilizado, closeTo(66.66, 0.01));
    expect(alim.subcategorias.length, 2);
    expect(alim.subcategorias[0].categoria.descricao, 'Supermercado');
    expect(alim.subcategorias[0].valor, 600.0);
    expect(alim.subcategorias[1].categoria.descricao, 'Alimentação');
    expect(alim.subcategorias[1].valor, 400.0);

    // Categoria Lazer
    final lazer = result.categorias.firstWhere(
      (c) => c.categoria.id == 'cat-lazer',
    );
    expect(lazer.valorPrevisto, 500.0);
    expect(lazer.valorReal, 600.0);
    expect(lazer.saldoRestante, -100.0);
    expect(lazer.estourou, isTrue);
    expect(lazer.valorExcedente, 100.0);
    expect(lazer.percentualUtilizado, 120.0);
  });
}
