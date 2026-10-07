import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_filter_usecase.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/ui/categoria/list/viewmodels/categoria_list_viewmodel.dart';

import '../../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository repository;
  late CategoriaListViewModel viewModel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = CategoriaRepository(createTestCategoriaStorage());
    viewModel = CategoriaListViewModel(
      repository,
      CategoriaFilterUseCase(),
      CategoriaTreeUseCase(),
    );
  });

  tearDown(() {
    viewModel.dispose();
    repository.dispose();
  });

  group('CategoriaListViewModel', () {
    test(
      'atualiza percentual pontualmente em memória sem disparar loadCommand',
      () async {
        // Cria categoria pai
        final catResult = await repository.create(
          CategoriaDto(
            descricao: 'Custos Fixos',
            natureza: CategoriaNatureza.saida,
            percentualOrcamento: 40,
            cor: '#0084FF',
          ),
        );
        final cat = catResult.getOrThrow();

        // Carga inicial
        await viewModel.loadCommand.execute();
        expect(viewModel.categoriasPai.first.percentualOrcamento, equals(40));
        expect(viewModel.categorias.first.percentualOrcamento, equals(40));

        var notifiedCount = 0;
        viewModel.addListener(() {
          notifiedCount++;
        });

        var loadCommandTriggered = false;
        viewModel.loadCommand.addListener(() {
          loadCommandTriggered = true;
        });

        // Atualiza apenas o percentual da categoria
        final updateResult = await repository.update(
          CategoriaDto(
            id: cat.id,
            descricao: cat.descricao,
            categoriaPaiId: cat.categoriaPaiId,
            ativo: cat.ativo,
            percentualOrcamento: 55,
            natureza: cat.natureza,
            cor: cat.cor,
          ),
        );
        expect(updateResult.isSuccess(), isTrue);

        // Aguarda a propagação de stream
        await Future.delayed(const Duration(milliseconds: 50));

        // Deve ter notificado os listeners do ViewModel
        expect(notifiedCount, greaterThan(0));

        // Não deve ter disparado o loadCommand novamente
        expect(loadCommandTriggered, isFalse);

        // Os valores em memória foram atualizados pontualmente
        expect(viewModel.categoriasPai.first.percentualOrcamento, equals(55));
        expect(viewModel.categorias.first.percentualOrcamento, equals(55));
      },
    );
  });
}
