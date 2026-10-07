import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/ui/lancamentos/create/viewmodels/lancamento_create_viewmodel.dart';

import '../../../../helpers/test_storage.dart';

class FakeCreateLancamentoUseCase implements CreateLancamentoUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCreateLancamentosUseCase implements CreateLancamentosUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CategoriaRepository categoriaRepository;
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late CentroCustoRepository centroCustoRepository;
  late LancamentoCreateViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    categoriaRepository = CategoriaRepository(createTestCategoriaStorage());
    contaRepository = ContaRepository(createTestContaStorage());
    cartaoRepository = CartaoRepository(createTestCartaoStorage());
    centroCustoRepository = CentroCustoRepository(
      createTestCentroCustoStorage(),
    );

    viewModel = LancamentoCreateViewModel(
      FakeCreateLancamentoUseCase(),
      FakeCreateLancamentosUseCase(),
      contaRepository,
      cartaoRepository,
      categoriaRepository,
      centroCustoRepository,
      CategoriaTreeUseCase(),
    );
  });

  tearDown(() {
    viewModel.dispose();
    categoriaRepository.dispose();
    contaRepository.dispose();
    cartaoRepository.dispose();
    centroCustoRepository.dispose();
  });

  group('LancamentoCreateViewModel - Filtro de Categorias Ativas', () {
    test(
      'load deve trazer apenas categorias ativas (excluindo pai inativo, filhas de pai inativo e filhas inativas)',
      () async {
        // 1. Categoria pai ativa com filha ativa
        final catAlimentacao = await categoriaRepository.create(
          CategoriaDto(descricao: 'Alimentação', ativo: true),
        );
        final alimentacaoId = catAlimentacao.getOrThrow().id;
        await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Restaurante',
            categoriaPaiId: alimentacaoId,
            ativo: true,
          ),
        );

        // 2. Categoria pai inativa com filha
        final catTransporte = await categoriaRepository.create(
          CategoriaDto(descricao: 'Transporte', ativo: false),
        );
        final transporteId = catTransporte.getOrThrow().id;
        await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Ônibus',
            categoriaPaiId: transporteId,
            ativo: false,
          ),
        );

        // 3. Categoria pai ativa com filha inativa
        final catLazer = await categoriaRepository.create(
          CategoriaDto(descricao: 'Lazer', ativo: true),
        );
        final lazerId = catLazer.getOrThrow().id;
        await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Cinema',
            categoriaPaiId: lazerId,
            ativo: false,
          ),
        );

        await viewModel.load();

        // Categorias raiz carregadas devem ser apenas as ativas
        final descricoesRaiz = viewModel.categorias
            .map((c) => c.descricao)
            .toList();
        expect(descricoesRaiz, contains('Alimentação'));
        expect(descricoesRaiz, contains('Lazer'));
        expect(descricoesRaiz, isNot(contains('Transporte')));

        // Na categoria Alimentação, apenas a filha ativa deve constar
        final alimentacaoNode = viewModel.categorias.firstWhere(
          (c) => c.descricao == 'Alimentação',
        );
        expect(alimentacaoNode.subcategorias.map((c) => c.descricao), [
          'Restaurante',
        ]);

        // Na categoria Lazer, a filha inativa 'Cinema' não deve constar
        final lazerNode = viewModel.categorias.firstWhere(
          (c) => c.descricao == 'Lazer',
        );
        expect(lazerNode.subcategorias, isEmpty);
      },
    );

    test(
      'ao desativar uma categoria pai no repositório, ela e suas filhas são removidas do viewModel',
      () async {
        final catPai = await categoriaRepository.create(
          CategoriaDto(descricao: 'Moradia', ativo: true),
        );
        final paiId = catPai.getOrThrow().id;
        await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Aluguel',
            categoriaPaiId: paiId,
            ativo: true,
          ),
        );

        await viewModel.load();
        expect(
          viewModel.categorias.any((c) => c.descricao == 'Moradia'),
          isTrue,
        );

        // Desativa a categoria pai
        await categoriaRepository.update(
          CategoriaDto(id: paiId, descricao: 'Moradia', ativo: false),
        );

        // Aguarda os eventos de stream do repositório
        await pumpEventQueue();

        expect(
          viewModel.categorias.any((c) => c.descricao == 'Moradia'),
          isFalse,
        );
      },
    );
  });
}
