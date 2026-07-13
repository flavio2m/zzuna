part of '../providers.dart';

final centroCustoRepositoryProvider = Provider<CentroCustoRepository>((ref) {
  final repository = CentroCustoRepository(
    ref.watch(centroCustoStorageProvider),
  );

  ref.onDispose(repository.dispose);

  return repository;
});

// ============================================================================
// CENTRO DE CUSTO
// ============================================================================

final centroCustoListViewModelProvider =
    Provider.autoDispose<CentroCustoListViewModel>((ref) {
      final vm = CentroCustoListViewModel(
        ref.watch(centroCustoRepositoryProvider),
      );

      ref.onDispose(vm.dispose);

      return vm;
    });

final centroCustoCreateViewModelProvider = Provider<CentroCustoCreateViewModel>(
  (ref) => CentroCustoCreateViewModel(ref.watch(centroCustoRepositoryProvider)),
);

final centroCustoUpdateViewModelProvider = Provider<CentroCustoUpdateViewModel>(
  (ref) => CentroCustoUpdateViewModel(ref.watch(centroCustoRepositoryProvider)),
);

final centroCustoDeleteViewModelProvider = Provider<CentroCustoDeleteViewModel>(
  (ref) => CentroCustoDeleteViewModel(ref.watch(centroCustoRepositoryProvider)),
);

