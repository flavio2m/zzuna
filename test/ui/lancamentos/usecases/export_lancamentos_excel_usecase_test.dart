import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';
import 'package:zzuna/domain/statics/banco/banco_regiao.dart';
import 'package:zzuna/domain/usecases/lancamento/export_lancamentos_excel_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

void main() {
  group('ExportLancamentosExcelUseCase Tests', () {
    late ExportLancamentosExcelUseCase useCase;

    setUp(() {
      useCase = ExportLancamentosExcelUseCase();
    });

    final contaDetails = ContaDetails(
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
    );

    final extratoFake = ExtratoFaturaDetails(
      id: 'ef-1',
      origem: LancamentoOrigemContaDetail(conta: contaDetails),
      ano: 2026,
      mes: Mes.agosto,
      dataInicio: DateTime(2026, 8, 1),
      dataFim: DateTime(2026, 8, 31),
      saldoInicial: 0.0,
      saldoFinal: 0.0,
      fechado: false,
    );

    test('generates valid Excel bytes and excludes desconsiderados', () {
      final item1 = LancamentoDetails(
        id: '1',
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 8, 12),
        descricao: 'Rosa Salário - 1',
        extratoFatura: extratoFake,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        itens: const [
          LancamentoItemDetailsStandard(
            numero: 1,
            centroCusto: CentroCustoDetails(
              id: 'cc-1',
              descricao: 'CC: Moradia',
              ativo: true,
            ),
            categoria: CategoriaDetails(
              id: 'cat-1',
              descricao: 'Salário',
              ativo: true,
              categoriaPai: CategoriaDetails(
                id: 'cat-0',
                descricao: 'Receitas',
                ativo: true,
                categoriaPai: null,
                subcategorias: [],
              ),
              subcategorias: [],
            ),
            valor: 1050.0,
          ),
        ],
        conciliado: true,
        anoMes: 202608,
      );

      final itemIgnored = LancamentoDetails(
        id: '2',
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 8, 12),
        descricao: 'Oculto',
        extratoFatura: extratoFake,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        itens: const [],
        conciliado: false,
        anoMes: 202608,
      );

      final bytes = useCase.execute(
        lancamentos: [item1, itemIgnored],
        lancamentosDesconsiderados: {'2'},
      );

      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);

      final excel = Excel.decodeBytes(bytes);
      expect(excel.tables.containsKey('Extrato Fatura'), isTrue);

      final sheet = excel['Extrato Fatura'];
      expect(sheet.maxRows, equals(2)); // Header + 1 visible item
    });
  });
}
