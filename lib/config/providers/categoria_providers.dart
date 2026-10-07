part of '../providers.dart';

final categoriaRepositoryProvider = Provider<CategoriaRepository>((ref) {
  final repository = CategoriaRepository(ref.watch(categoriaStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final categoriaFilterUseCaseProvider = Provider<CategoriaFilterUseCase>(
  (ref) => CategoriaFilterUseCase(), //
);
final categoriaTreeUseCaseProvider = Provider<CategoriaTreeUseCase>(
  (ref) => CategoriaTreeUseCase(), //
);
final categoriaSaveUseCaseProvider = Provider<CategoriaSaveUseCase>(
  (ref) => CategoriaSaveUseCase(ref.watch(categoriaRepositoryProvider)),
);

// CATEGORIA
final categoriaListViewModelProvider =
    ChangeNotifierProvider<CategoriaListViewModel>(
      (ref) => CategoriaListViewModel(
        ref.watch(categoriaRepositoryProvider),
        ref.watch(categoriaFilterUseCaseProvider),
        ref.watch(categoriaTreeUseCaseProvider),
      ),
    );

final categoriaCreateViewModelProvider = Provider<CategoriaCreateViewModel>(
  (ref) => CategoriaCreateViewModel(ref.watch(categoriaSaveUseCaseProvider)),
);

final categoriaUpdateViewModelProvider = Provider<CategoriaUpdateViewModel>(
  (ref) => CategoriaUpdateViewModel(ref.watch(categoriaSaveUseCaseProvider)),
);

final categoriaDeleteViewModelProvider = Provider<CategoriaDeleteViewModel>(
  (ref) => CategoriaDeleteViewModel(ref.watch(categoriaRepositoryProvider)),
);

final definirOrcamentoViewModelProvider = Provider<DefinirOrcamentoViewModel>(
  (ref) => DefinirOrcamentoViewModel(ref.watch(authRepositoryProvider)),
);

final categoriaPercentualViewModelProvider =
    Provider<CategoriaPercentualViewModel>(
      (ref) =>
          CategoriaPercentualViewModel(ref.watch(categoriaRepositoryProvider)),
    );
