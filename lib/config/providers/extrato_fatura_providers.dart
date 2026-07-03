part of '../providers.dart';

final extratoFaturaRepositoryProvider = Provider<ExtratoFaturaRepository>((
  ref,
) {
  final repository = ExtratoFaturaRepository(
    ref.watch(extratoFaturaStorageProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
});
