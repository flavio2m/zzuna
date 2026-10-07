import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamento_usecase.dart';
import 'package:zzuna/ui/lancamentos/update/individual/viewmodels/lancamento_update_viewmodel.dart';

import '../../../../helpers/test_storage.dart';

class FakeUpdateLancamentoUseCase implements UpdateLancamentoUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CategoriaRepository categoriaRepository;
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late CentroCustoRepository centroCustoRepository;
  late LancamentoUpdateViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    categoriaRepository = CategoriaRepository(createTestCategoriaStorage());
    contaRepository = ContaRepository(createTestContaStorage());
    cartaoRepository = CartaoRepository(createTestCartaoStorage());
    centroCustoRepository = CentroCustoRepository(
      createTestCentroCustoStorage(),
    );

    viewModel = LancamentoUpdateViewModel(
      FakeUpdateLancamentoUseCase(),
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

  group('LancamentoUpdateViewModel - Filtro de Categorias e Itens', () {
    test('load deve trazer apenas categorias ativas por padrão', () async {
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
          descricao: 'Metrô',
          categoriaPaiId: transporteId,
          ativo: false,
        ),
      );

      // 3. Categoria pai ativa com filha inativa
      final catEducacao = await categoriaRepository.create(
        CategoriaDto(descricao: 'Educação', ativo: true),
      );
      final educacaoId = catEducacao.getOrThrow().id;
      await categoriaRepository.create(
        CategoriaDto(
          descricao: 'Cursos Antigos',
          categoriaPaiId: educacaoId,
          ativo: false,
        ),
      );

      await viewModel.load();

      final descricoesRaiz = viewModel.categorias
          .map((c) => c.descricao)
          .toList();
      expect(descricoesRaiz, contains('Alimentação'));
      expect(descricoesRaiz, contains('Educação'));
      expect(descricoesRaiz, isNot(contains('Transporte')));

      final alimentacaoNode = viewModel.categorias.firstWhere(
        (c) => c.descricao == 'Alimentação',
      );
      expect(alimentacaoNode.subcategorias.map((c) => c.descricao), [
        'Restaurante',
      ]);

      final educacaoNode = viewModel.categorias.firstWhere(
        (c) => c.descricao == 'Educação',
      );
      expect(educacaoNode.subcategorias, isEmpty);
    });

    test(
      'load com includeCategoriaIds deve incluir categoria inativa e sua hierarquia',
      () async {
        final catPai = await categoriaRepository.create(
          CategoriaDto(descricao: 'Lazer Antigo', ativo: false),
        );
        final paiId = catPai.getOrThrow().id;

        final catFilha = await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Cinema',
            categoriaPaiId: paiId,
            ativo: false,
          ),
        );
        final filhaId = catFilha.getOrThrow().id;

        await viewModel.load(includeCategoriaIds: [filhaId]);

        final lazerNode = viewModel.categorias.firstWhere((c) => c.id == paiId);
        expect(lazerNode.ativo, isFalse);
        expect(lazerNode.subcategorias.length, 1);
        expect(lazerNode.subcategorias.first.id, filhaId);
        expect(lazerNode.subcategorias.first.ativo, isFalse);
      },
    );

    test(
      'load com includeCentroCustoIds inclui centro de custo inativo',
      () async {
        final ccInativo = await centroCustoRepository.create(
          CentroCustoDto(descricao: 'CC Desativado', ativo: false),
        );
        final ccId = ccInativo.getOrThrow().id;

        await viewModel.load(includeCentroCustoIds: [ccId]);

        expect(viewModel.centros.any((c) => c.id == ccId), isTrue);
      },
    );

    test(
      'ao desativar uma categoria pai no repositório, ela é mantida se estiver em includeCategoriaIds',
      () async {
        final catPai = await categoriaRepository.create(
          CategoriaDto(descricao: 'Investimentos', ativo: true),
        );
        final paiId = catPai.getOrThrow().id;

        await viewModel.load(includeCategoriaIds: [paiId]);
        expect(
          viewModel.categorias.any((c) => c.descricao == 'Investimentos'),
          isTrue,
        );

        // Desativa a categoria pai
        await categoriaRepository.update(
          CategoriaDto(id: paiId, descricao: 'Investimentos', ativo: false),
        );

        await pumpEventQueue();

        // Deve continuar presente porque está em includeCategoriaIds
        expect(viewModel.categorias.any((c) => c.id == paiId), isTrue);
      },
    );
  });
}
