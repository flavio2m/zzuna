import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/orcamento/get_orcamento_comparativo_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/viewmodels/orcamento_comparativo_viewmodel.dart';

import '../../../../helpers/test_storage.dart';

void main() {
  late GetOrcamentoComparativoUseCase useCase;
  late CategoriaRepository categoriaRepository;
  late OrcamentoComparativoViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    categoriaRepository = CategoriaRepository(createTestCategoriaStorage());
    useCase = GetOrcamentoComparativoUseCase();
    viewModel = OrcamentoComparativoViewModel(useCase, categoriaRepository);
  });

  tearDown(() {
    viewModel.dispose();
    categoriaRepository.dispose();
  });

  test(
    'calcular delegates execution to GetOrcamentoComparativoUseCase',
    () async {
      final catMoradiaResult = await categoriaRepository.create(
        CategoriaDto(
          descricao: 'Moradia',
          ativo: true,
          natureza: CategoriaNatureza.saida,
          percentualOrcamento: 30.0,
        ),
      );
      final catMoradia = catMoradiaResult.getOrThrow();
      await viewModel.loadCategorias();

      final catMoradiaDetails = CategoriaDetails(
        id: catMoradia.id,
        descricao: 'Moradia',
        ativo: true,
        natureza: CategoriaNatureza.saida,
        categoriaPai: null,
        subcategorias: [],
      );

      final contaDetails = ContaDetails(
        id: 'c1',
        descricao: 'Conta Corrente',
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

      const centroCusto = CentroCustoDetails(
        id: 'cc-1',
        descricao: 'Pessoal',
        ativo: true,
      );

      final lancamento = LancamentoDetails(
        id: 'lanc-1',
        descricao: 'Aluguel',
        data: DateTime(2026, 10, 5),
        anoMes: 202610,
        origem: LancamentoOrigemContaDetail(conta: contaDetails),
        extratoFatura: extratoDetails,
        tipo: LancamentoTipo.despesa,
        conciliado: true,
        itens: [
          LancamentoItemDetailsStandard(
            numero: 1,
            categoria: catMoradiaDetails,
            centroCusto: centroCusto,
            valor: 1200.0,
          ),
        ],
      );

      final result = viewModel.calcular(
        lancamentos: [lancamento],
        rendaReferencia: 5000.0,
      );

      expect(result, isA<OrcamentoMensalComparativoModel>());
      expect(result.rendaReferencia, 5000.0);
      expect(result.totalPrevisto, 1500.0); // 30% of 5000
      expect(result.totalReal, 1200.0);
      expect(result.saldoTotal, 300.0);
      expect(result.percentualGeralUtilizado, 80.0);
      expect(result.estourouGeral, false);
      expect(result.categorias.length, 1);
      expect(result.categorias.first.categoria.descricao, 'Moradia');
      expect(result.categorias.first.valorPrevisto, 1500.0);
      expect(result.categorias.first.valorReal, 1200.0);
      expect(result.categorias.first.saldoRestante, 300.0);
      expect(result.categorias.first.percentualUtilizado, 80.0);
    },
  );
}
