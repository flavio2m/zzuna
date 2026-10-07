import 'package:flutter_test/flutter_test.dart';
import 'package:result_command/result_command.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/statics/categoria/categoria_cores.dart';
import 'package:zzuna/ui/categoria/orcamento/update_percentual/viewmodels/categoria_percentual_viewmodel.dart';

import '../../../../../helpers/test_storage.dart';

void main() {
  late CategoriaRepository categoriaRepository;
  late CategoriaPercentualViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final categoriaStorage = createTestCategoriaStorage();
    categoriaRepository = CategoriaRepository(categoriaStorage);
    viewModel = CategoriaPercentualViewModel(categoriaRepository);
  });

  tearDown(() {
    categoriaRepository.dispose();
  });

  group('CategoriaPercentualViewModel', () {
    test(
      'updatePercentualCommand updates category percentage and preserves color',
      () async {
        final catResult = await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Moradia',
            natureza: CategoriaNatureza.saida,
            percentualOrcamento: 25,
            cor: CategoriaCores.azulCustosFixos,
          ),
        );
        expect(catResult.isSuccess(), isTrue);
        final cat = catResult.getOrThrow();
        expect(cat.percentualOrcamento, 25);
        expect(cat.cor, CategoriaCores.azulCustosFixos);

        await viewModel.updatePercentualCommand.execute((
          categoria: cat,
          percentual: 30,
        ));

        expect(viewModel.updatePercentualCommand.value.isSuccess, isTrue);
        final updatedCat =
            (viewModel.updatePercentualCommand.value
                    as SuccessCommand<Categoria>)
                .value;
        expect(updatedCat.percentualOrcamento, 30);
        expect(updatedCat.natureza, CategoriaNatureza.saida);
        expect(updatedCat.cor, CategoriaCores.azulCustosFixos);
      },
    );

    test(
      'updatePercentualCommand updates category percentage with decimal value',
      () async {
        final catResult = await categoriaRepository.create(
          CategoriaDto(
            descricao: 'Lazer',
            natureza: CategoriaNatureza.saida,
            percentualOrcamento: 15.0,
            cor: CategoriaCores.amareloConhecimento,
          ),
        );
        expect(catResult.isSuccess(), isTrue);
        final cat = catResult.getOrThrow();

        await viewModel.updatePercentualCommand.execute((
          categoria: cat,
          percentual: 12.75,
        ));

        expect(viewModel.updatePercentualCommand.value.isSuccess, isTrue);
        final updatedCat =
            (viewModel.updatePercentualCommand.value
                    as SuccessCommand<Categoria>)
                .value;
        expect(updatedCat.percentualOrcamento, 12.75);
      },
    );
  });
}
