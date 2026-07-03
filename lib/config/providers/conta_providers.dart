part of '../providers.dart';

final contaRepositoryProvider = Provider<ContaRepository>((ref) {
  final repository = ContaRepository(ref.watch(contaStorageProvider));

  ref.onDispose(repository.dispose);

  return repository;
});

// CONTA
final contaListViewModelProvider = Provider.autoDispose<ContaListViewModel>((
  ref,
) {
  final vm = ContaListViewModel(ref.watch(contaRepositoryProvider));

  ref.onDispose(vm.dispose);

  return vm;
});

final contaCreateViewModelProvider = Provider<ContaCreateViewModel>(
  (ref) => ContaCreateViewModel(ref.watch(contaRepositoryProvider)),
);

final contaUpdateViewModelProvider = Provider<ContaUpdateViewModel>(
  (ref) => ContaUpdateViewModel(ref.watch(contaRepositoryProvider)),
);

final contaDeleteViewModelProvider = Provider<ContaDeleteViewModel>(
  (ref) => ContaDeleteViewModel(ref.watch(contaRepositoryProvider)),
);

