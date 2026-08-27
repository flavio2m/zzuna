import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';
import 'package:zzuna/domain/statics/banco/banco_regiao.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_resumo_mensal_usecase.dart';

void main() {
  group('LancamentoResumoMensalUseCase Tests', () {
    late LancamentoResumoMensalUseCase useCase;

    setUp(() {
      useCase = LancamentoResumoMensalUseCase();
    });

    final contaDetails = ContaDetails(
      id: 'conta-1',
      descricao: 'Conta 1',
      ativo: true,
      banco: const Banco(
        descricao: 'Banco 1',
        sigla: 'B1',
        icon: BancoIcon.outros,
        regiao: RegiaoBanco.brasil,
      ),
      dataInicial: DateTime(2026, 1, 1),
    );

    LancamentoDetails buildLancamento({
      required String id,
      required LancamentoTipo tipo,
      required DateTime data,
      required double valor,
    }) {
      return LancamentoDetails(
        id: id,
        tipo: tipo,
        data: data,
        descricao: 'Test $id',
        extratoFatura: ExtratoFaturaDetails(
          id: 'ef-1',
          origem: LancamentoOrigemContaDetail(conta: contaDetails),
          ano: 2026,
          mes: Mes.junho,
          dataInicio: DateTime(2026, 6, 1),
          dataFim: DateTime(2026, 6, 30),
          saldoInicial: 0.0,
          saldoFinal: 0.0,
          fechado: false,
        ),
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        itens: [
          LancamentoItemDetails(
            numero: 1,
            centroCusto: const CentroCustoDetails(
              id: 'cc-1',
              descricao: 'CC 1',
              ativo: true,
            ),
            categoria: const CategoriaDetails(
              id: 'cat-1',
              descricao: 'Cat 1',
              ativo: true,
              categoriaPai: null,
              subcategorias: [],
            ),
            valor: valor,
          ),
        ],
        conciliado: true,
        anoMes: 202606,
      );
    }

    test(
      'calculates correct monthly totals for receipts, expenses and transfers',
      () {
        final list = [
          buildLancamento(
            id: '1',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 15),
            valor: 1000.0,
          ),
          buildLancamento(
            id: '2',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 16),
            valor: 500.0,
          ),
          buildLancamento(
            id: '3',
            tipo: LancamentoTipo.despesa,
            data: DateTime(2026, 6, 17),
            valor: 300.0,
          ),
          buildLancamento(
            id: '5',
            tipo: LancamentoTipo.transferencia,
            data: DateTime(2026, 6, 19),
            valor: 100.0,
          ),
        ];

        final result = useCase.execute(
          list,
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
        );

        expect(result.receitas, 1500.0);
        expect(result.despesas, 300.0);
        expect(result.transferencias, 100.0);
        expect(result.mes, Mes.junho);
        expect(result.ano, 2026);
      },
    );

    test(
      'correctly groups and sorts lancamentos by day and calculates daily balance',
      () {
        final list = [
          buildLancamento(
            id: '1',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 15, 10, 0),
            valor: 1000.0,
          ),
          buildLancamento(
            id: '2',
            tipo: LancamentoTipo.despesa,
            data: DateTime(2026, 6, 15, 14, 0),
            valor: 200.0,
          ),
          buildLancamento(
            id: '3',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 16, 09, 0),
            valor: 500.0,
          ),
        ];

        final result = useCase.execute(
          list,
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
        );

        expect(result.dias.length, 2);

        // Days should be sorted descending: 16th June first, then 15th June
        final firstDay = result.dias[0];
        expect(firstDay.data, DateTime(2026, 6, 16));
        expect(firstDay.saldo, 500.0);
        expect(
          firstDay.saldoExtrato,
          1300.0,
        ); // 800 (from 15th) + 500 (from 16th)
        expect(firstDay.lancamentos.length, 1);

        final secondDay = result.dias[1];
        expect(secondDay.data, DateTime(2026, 6, 15));
        expect(secondDay.saldo, 800.0); // 1000 (receita) - 200 (despesa)
        expect(secondDay.saldoExtrato, 800.0); // 0 (initial) + 800
        expect(secondDay.lancamentos.length, 2);
      },
    );

    test(
      'calculates and propagates accumulated extract balance starting from non-zero initial extract balance',
      () {
        final extrato = ExtratoFatura(
          id: 'ef-1',
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          ano: 2026,
          mes: Mes.junho,
          dataInicio: DateTime(2026, 6, 1),
          dataFim: DateTime(2026, 6, 30),
          saldoInicial: 1000.0,
          saldoFinal: 2500.0,
          fechado: false,
          periodo: 202606,
          origemKey: 'conta_conta-1',
        );

        final list = [
          buildLancamento(
            id: '1',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 5),
            valor: 500.0,
          ),
          buildLancamento(
            id: '2',
            tipo: LancamentoTipo.despesa,
            data: DateTime(2026, 6, 10),
            valor: 200.0,
          ),
          buildLancamento(
            id: '3',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 12),
            valor: 300.0,
          ),
        ];

        final result = useCase.execute(
          list,
          extratos: [extrato],
          contasSelecionadas: {'conta-1'},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
        );

        expect(result.dias.length, 3);

        // Days in descending order: 12th, 10th, 5th
        // Chronological calculations:
        // Start: 1000.0
        // 5th: +500 -> 1500.0
        // 10th: -200 -> 1300.0
        // 12th: +300 -> 1600.0

        final day12 = result.dias[0];
        expect(day12.data, DateTime(2026, 6, 12));
        expect(day12.saldo, 300.0);
        expect(day12.saldoExtrato, 1600.0);

        final day10 = result.dias[1];
        expect(day10.data, DateTime(2026, 6, 10));
        expect(day10.saldo, -200.0);
        expect(day10.saldoExtrato, 1300.0);

        final day5 = result.dias[2];
        expect(day5.data, DateTime(2026, 6, 5));
        expect(day5.saldo, 500.0);
        expect(day5.saldoExtrato, 1500.0);
      },
    );

    test(
      'recalculates daily balances cascading from 0 when incluirSaldoInicial is false',
      () {
        final extrato = ExtratoFatura(
          id: 'ef-1',
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          ano: 2026,
          mes: Mes.junho,
          dataInicio: DateTime(2026, 6, 1),
          dataFim: DateTime(2026, 6, 30),
          saldoInicial: 1000.0,
          saldoFinal: 2500.0,
          fechado: false,
          periodo: 202606,
          origemKey: 'conta_conta-1',
        );

        final list = [
          buildLancamento(
            id: '1',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 5),
            valor: 500.0,
          ),
          buildLancamento(
            id: '2',
            tipo: LancamentoTipo.despesa,
            data: DateTime(2026, 6, 10),
            valor: 200.0,
          ),
          buildLancamento(
            id: '3',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 12),
            valor: 300.0,
          ),
        ];

        final result = useCase.execute(
          list,
          extratos: [extrato],
          contasSelecionadas: {'conta-1'},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
          incluirSaldoInicial: false,
        );

        expect(result.saldoInicial, 0.0);
        expect(result.saldoInicialReal, 1000.0);
        expect(result.saldoFinalReal, 2500.0);
        expect(result.saldoFinal, 1500.0); // 2500 - 1000

        // Chronological calculations starting from 0.0:
        // 5th: +500 -> 500.0
        // 10th: -200 -> 300.0
        // 12th: +300 -> 600.0

        expect(result.dias[0].saldoExtrato, 600.0);
        expect(result.dias[1].saldoExtrato, 300.0);
        expect(result.dias[2].saldoExtrato, 500.0);
      },
    );

    test(
      'handles empty list gracefully by returning empty days and current month/year',
      () {
        final now = DateTime.now();
        final currentMes = Mes.fromDate(now);
        final currentAno = now.year;

        final result = useCase.execute(
          [],
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: currentMes,
          ano: currentAno,
        );

        expect(result.receitas, 0.0);
        expect(result.despesas, 0.0);
        expect(result.dias, isEmpty);
        expect(result.mes, currentMes);
        expect(result.ano, currentAno);
      },
    );

    test(
      'omits lancamentosDesconsiderados from totals and daily balance calculations while retaining them in day items',
      () {
        final list = [
          buildLancamento(
            id: '1',
            tipo: LancamentoTipo.receita,
            data: DateTime(2026, 6, 10),
            valor: 1050.0,
          ),
          buildLancamento(
            id: '2',
            tipo: LancamentoTipo.despesa,
            data: DateTime(2026, 6, 10),
            valor: 122.20,
          ),
        ];

        final resultWithBoth = useCase.execute(
          list,
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
        );

        expect(resultWithBoth.receitas, 1050.0);
        expect(resultWithBoth.despesas, 122.20);
        expect(resultWithBoth.dias.first.saldo, 927.80);
        expect(resultWithBoth.dias.first.lancamentos.length, 2);

        final resultIgnoringReceita = useCase.execute(
          list,
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
          lancamentosDesconsiderados: {'1'},
        );

        expect(resultIgnoringReceita.receitas, 0.0);
        expect(resultIgnoringReceita.despesas, 122.20);
        expect(resultIgnoringReceita.dias.first.saldo, -122.20);
        // The day card still includes both items in its list
        expect(resultIgnoringReceita.dias.first.lancamentos.length, 2);
      },
    );

    test(
      'calculates totals by item when category filter is active in multi-item transaction',
      () {
        final catAlimentacao = const CategoriaDetails(
          id: 'cat-alimentacao',
          descricao: 'Alimentação',
          ativo: true,
          categoriaPai: null,
          subcategorias: [],
        );

        final catHigiene = const CategoriaDetails(
          id: 'cat-higiene',
          descricao: 'Higiene e Beleza',
          ativo: true,
          categoriaPai: null,
          subcategorias: [],
        );

        final ccGeral = const CentroCustoDetails(
          id: 'cc-1',
          descricao: 'CC 1',
          ativo: true,
        );

        final multiItemLancamento = LancamentoDetails(
          id: 'multi-1',
          tipo: LancamentoTipo.despesa,
          data: DateTime(2026, 6, 11),
          descricao: 'Compra Mercadona diversos',
          extratoFatura: ExtratoFaturaDetails(
            id: 'ef-1',
            origem: LancamentoOrigemContaDetail(conta: contaDetails),
            ano: 2026,
            mes: Mes.junho,
            dataInicio: DateTime(2026, 6, 1),
            dataFim: DateTime(2026, 6, 30),
            saldoInicial: 0.0,
            saldoFinal: 0.0,
            fechado: false,
          ),
          origem: LancamentoOrigemContaDetail(conta: contaDetails),
          itens: [
            LancamentoItemDetails(
              numero: 1,
              centroCusto: ccGeral,
              categoria: catAlimentacao,
              valor: 10.45,
            ),
            LancamentoItemDetails(
              numero: 2,
              centroCusto: ccGeral,
              categoria: catHigiene,
              valor: 63.50,
            ),
          ],
          conciliado: true,
          anoMes: 202606,
        );

        final resultNoFilter = useCase.execute(
          [multiItemLancamento],
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: false,
          mes: Mes.junho,
          ano: 2026,
        );

        expect(resultNoFilter.despesas, 73.95);
        expect(resultNoFilter.dias.first.saldo, -73.95);

        final resultAlimentacaoFilter = useCase.execute(
          [multiItemLancamento],
          extratos: [],
          contasSelecionadas: {},
          cartoesSelecionados: {},
          temFiltroRestritivo: true,
          mes: Mes.junho,
          ano: 2026,
          categoriasSelecionadas: {'cat-alimentacao'},
        );

        expect(resultAlimentacaoFilter.despesas, 10.45);
        expect(resultAlimentacaoFilter.dias.first.saldo, -10.45);
      },
    );
  });
}
