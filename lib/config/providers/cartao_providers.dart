part of '../providers.dart';

final cartaoRepositoryProvider = Provider<CartaoRepository>((ref) {
  final repository = CartaoRepository(ref.watch(cartaoStorageProvider));

  ref.onDispose(repository.dispose);

  return repository;
});

// CARTAO
final cartaoListViewModelProvider = Provider.autoDispose<CartaoListViewModel>((
  ref,
) {
  final vm = CartaoListViewModel(ref.watch(cartaoRepositoryProvider));

  ref.onDispose(vm.dispose);

  return vm;
});

final cartaoCreateViewModelProvider = Provider<CartaoCreateViewModel>(
  (ref) => CartaoCreateViewModel(ref.watch(cartaoRepositoryProvider)),
);

final cartaoUpdateViewModelProvider = Provider<CartaoUpdateViewModel>(
  (ref) => CartaoUpdateViewModel(ref.watch(cartaoRepositoryProvider)),
);

final cartaoDeleteViewModelProvider = Provider<CartaoDeleteViewModel>(
  (ref) => CartaoDeleteViewModel(ref.watch(cartaoRepositoryProvider)),
);

