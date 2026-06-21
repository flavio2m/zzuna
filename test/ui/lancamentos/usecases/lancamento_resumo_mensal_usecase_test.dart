import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
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
      banco: const Banco(descricao: 'Banco 1', sigla: 'B1', icon: BancoIcon.outros),
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
            id: 'item-$id',
            centroCusto: const CentroCustoDetails(id: 'cc-1', descricao: 'CC 1', ativo: true),
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
      );
    }

    test('calculates correct monthly totals for receipts, expenses and investments', () {
      final list = [
        buildLancamento(id: '1', tipo: LancamentoTipo.receita, data: DateTime(2026, 6, 15), valor: 1000.0),
        buildLancamento(id: '2', tipo: LancamentoTipo.receita, data: DateTime(2026, 6, 16), valor: 500.0),
        buildLancamento(id: '3', tipo: LancamentoTipo.despesa, data: DateTime(2026, 6, 17), valor: 300.0),
        buildLancamento(id: '4', tipo: LancamentoTipo.investimento, data: DateTime(2026, 6, 18), valor: 200.0),
        buildLancamento(id: '5', tipo: LancamentoTipo.transferencia, data: DateTime(2026, 6, 19), valor: 100.0),
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
      expect(result.investimentos, 200.0);
      expect(result.mes, Mes.junho);
      expect(result.ano, 2026);
    });

    test('correctly groups and sorts lancamentos by day and calculates daily balance', () {
      final list = [
        buildLancamento(id: '1', tipo: LancamentoTipo.receita, data: DateTime(2026, 6, 15, 10, 0), valor: 1000.0),
        buildLancamento(id: '2', tipo: LancamentoTipo.despesa, data: DateTime(2026, 6, 15, 14, 0), valor: 200.0),
        buildLancamento(id: '3', tipo: LancamentoTipo.receita, data: DateTime(2026, 6, 16, 09, 0), valor: 500.0),
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
      expect(firstDay.lancamentos.length, 1);

      final secondDay = result.dias[1];
      expect(secondDay.data, DateTime(2026, 6, 15));
      expect(secondDay.saldo, 800.0); // 1000 (receita) - 200 (despesa)
      expect(secondDay.lancamentos.length, 2);
    });

    test('handles empty list gracefully by returning empty days and current month/year', () {
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
      expect(result.investimentos, 0.0);
      expect(result.dias, isEmpty);
      expect(result.mes, currentMes);
      expect(result.ano, currentAno);
    });
  });
}
