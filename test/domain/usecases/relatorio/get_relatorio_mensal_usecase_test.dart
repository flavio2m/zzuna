import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/relatorio/get_relatorio_mensal_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

void main() {
  late GetRelatorioMensalUseCase useCase;

  setUp(() {
    useCase = GetRelatorioMensalUseCase();
  });

  test(
    'GetRelatorioMensalUseCase groups income, expenses, categories and cost centers correctly',
    () {
      const parentAlim = CategoriaDetails(
        id: 'cat_alim',
        descricao: 'Alimentação',
        ativo: true,
        categoriaPai: null,
        subcategorias: [],
      );

      const subSuper = CategoriaDetails(
        id: 'cat_super',
        descricao: 'Supermercado',
        ativo: true,
        categoriaPai: parentAlim,
        subcategorias: [],
      );

      const parentFin = CategoriaDetails(
        id: 'cat_fin',
        descricao: 'Financeira',
        ativo: true,
        categoriaPai: null,
        subcategorias: [],
      );

      const ccCasa = CentroCustoDetails(
        id: 'cc_casa',
        descricao: 'Casa',
        ativo: true,
      );

      const ccTrabalho = CentroCustoDetails(
        id: 'cc_trabalho',
        descricao: 'Trabalho',
        ativo: true,
      );

      final contaDetails = ContaDetails(
        id: 'c1',
        descricao: 'Conta Itaú',
        banco: Bancos.bancoOutros,
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      );

      final extratoDetails = ExtratoFaturaDetails(
        id: 'ef1',
        ano: 2026,
        mes: Mes.agosto,
        dataInicio: DateTime(2026, 8, 1),
        dataFim: DateTime(2026, 8, 31),
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        saldoInicial: 1000.0,
        saldoFinal: 5000.0,
        fechado: false,
      );

      final lancamentos = [
        // Income
        LancamentoDetails(
          id: '1',
          data: DateTime(2026, 8, 1),
          descricao: 'Salário',
          tipo: LancamentoTipo.receita,
          extratoFatura: extratoDetails,
          origem: LancamentoOrigemContaDetail(conta: contaDetails),
          grupo: null,
          conciliado: true,
          anoMes: 202608,
          itens: [
            LancamentoItemDetailsStandard(
              numero: 1,
              centroCusto: ccTrabalho,
              categoria: parentFin,
              valor: 8000.0,
            ),
          ],
        ),
        // Expense 1 (Alimentação > Supermercado - Casa)
        LancamentoDetails(
          id: '2',
          data: DateTime(2026, 8, 5),
          descricao: 'Compras Mês',
          tipo: LancamentoTipo.despesa,
          extratoFatura: extratoDetails,
          origem: LancamentoOrigemContaDetail(conta: contaDetails),
          grupo: null,
          conciliado: true,
          anoMes: 202608,
          itens: const [
            LancamentoItemDetailsStandard(
              numero: 1,
              centroCusto: ccCasa,
              categoria: subSuper,
              valor: 2100.0,
            ),
          ],
        ),
        // Expense 2 (Financeira - Trabalho)
        LancamentoDetails(
          id: '3',
          data: DateTime(2026, 8, 10),
          descricao: 'Impostos',
          tipo: LancamentoTipo.despesa,
          extratoFatura: extratoDetails,
          origem: LancamentoOrigemContaDetail(conta: contaDetails),
          grupo: null,
          conciliado: true,
          anoMes: 202608,
          itens: const [
            LancamentoItemDetailsStandard(
              numero: 1,
              centroCusto: ccTrabalho,
              categoria: parentFin,
              valor: 1300.0,
            ),
          ],
        ),
      ];

      final result = useCase.execute(lancamentos);

      expect(result.totalReceitas, equals(8000.0));
      expect(result.totalDespesas, equals(3400.0));
      expect(result.saldo, equals(4600.0));

      expect(result.categoriasPai.length, equals(2));
      expect(
        result.categoriasPai[0].categoriaPai.descricao,
        equals('Alimentação'),
      );
      expect(result.categoriasPai[0].valorTotal, equals(2100.0));
      expect(result.categoriasPai[0].subcategorias.length, equals(1));
      expect(
        result.categoriasPai[0].subcategorias[0].categoria.descricao,
        equals('Supermercado'),
      );

      expect(
        result.categoriasPai[1].categoriaPai.descricao,
        equals('Financeira'),
      );
      expect(result.categoriasPai[1].valorTotal, equals(1300.0));

      expect(result.categoriasPaiReceitas.length, equals(1));
      expect(
        result.categoriasPaiReceitas[0].categoriaPai.descricao,
        equals('Financeira'),
      );
      expect(result.categoriasPaiReceitas[0].valorTotal, equals(8000.0));

      expect(result.centrosDeCusto.length, equals(2));
      expect(result.centrosDeCusto[0].centroCusto.descricao, equals('Casa'));
      expect(result.centrosDeCusto[0].valorTotal, equals(2100.0));
      expect(result.centrosDeCusto[0].categoriasPai.length, equals(1));
      expect(
        result.centrosDeCusto[0].categoriasPai[0].categoriaPai.descricao,
        equals('Alimentação'),
      );
      expect(
        result
            .centrosDeCusto[0]
            .categoriasPai[0]
            .subcategorias[0]
            .categoria
            .descricao,
        equals('Supermercado'),
      );
    },
  );
}
