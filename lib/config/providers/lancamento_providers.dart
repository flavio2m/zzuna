part of '../providers.dart';

final recalculateExtratoFaturaBalanceUseCaseProvider =
    Provider<RecalculateExtratoFaturaBalanceUseCase>((ref) {
      return RecalculateExtratoFaturaBalanceUseCase(
        ref.watch(extratoFaturaRepositoryProvider),
        ref.watch(lancamentoRepositoryProvider),
      );
    });

final resolveExtratoFaturaUseCaseProvider =
    Provider<ResolveExtratoFaturaUseCase>((ref) {
      return ResolveExtratoFaturaUseCase(
        ref.watch(extratoFaturaRepositoryProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
        applyRecorrenciasUseCase: ref.watch(applyRecorrenciasUseCaseProvider),
      );
    });

final resolveExtratoFaturasUseCaseProvider =
    Provider<ResolveExtratoFaturasUseCase>((ref) {
      return ResolveExtratoFaturasUseCase(
        ref.watch(extratoFaturaRepositoryProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
        applyRecorrenciasUseCase: ref.watch(applyRecorrenciasUseCaseProvider),
      );
    });

final applyRecorrenciasUseCaseProvider = Provider<ApplyRecorrenciasUseCase>((
  ref,
) {
  return ApplyRecorrenciasUseCase(
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
  );
});

final criarRecorrenciaUseCaseProvider = Provider<CriarRecorrenciaUseCase>((
  ref,
) {
  return CriarRecorrenciaUseCase(
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
  );
});

final finalizarRecorrenciaUseCaseProvider =
    Provider<FinalizarRecorrenciaUseCase>((ref) {
      return FinalizarRecorrenciaUseCase(
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
      );
    });

final reativarRecorrenciaUseCaseProvider = Provider<ReativarRecorrenciaUseCase>(
  (ref) {
    return ReativarRecorrenciaUseCase(
      ref.watch(lancamentoRepositoryProvider),
      ref.watch(extratoFaturaRepositoryProvider),
      ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
    );
  },
);

final atualizarDataRecorrenciaUseCaseProvider =
    Provider<AtualizarDataRecorrenciaUseCase>((ref) {
      return AtualizarDataRecorrenciaUseCase(
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
      );
    });

final atualizarSequenciaRecorrenciaUseCaseProvider =
    Provider<AtualizarSequenciaRecorrenciaUseCase>((ref) {
      return AtualizarSequenciaRecorrenciaUseCase(
        ref.watch(lancamentoRepositoryProvider),
      );
    });

final lancamentosCriarRecorrenciaViewModelProvider =
    ChangeNotifierProvider<LancamentosCriarRecorrenciaViewModel>((ref) {
      return LancamentosCriarRecorrenciaViewModel(
        ref.read(criarRecorrenciaUseCaseProvider),
      );
    });

final lancamentosFinalizarRecorrenciaViewModelProvider =
    ChangeNotifierProvider<LancamentosFinalizarRecorrenciaViewModel>((ref) {
      return LancamentosFinalizarRecorrenciaViewModel(
        ref.read(finalizarRecorrenciaUseCaseProvider),
      );
    });

final lancamentosReativarRecorrenciaViewModelProvider =
    ChangeNotifierProvider<LancamentosReativarRecorrenciaViewModel>((ref) {
      return LancamentosReativarRecorrenciaViewModel(
        ref.read(reativarRecorrenciaUseCaseProvider),
      );
    });

final lancamentosAtualizarDataRecorrenciaViewModelProvider =
    ChangeNotifierProvider<LancamentosAtualizarDataRecorrenciaViewModel>((ref) {
      return LancamentosAtualizarDataRecorrenciaViewModel(
        ref.read(atualizarDataRecorrenciaUseCaseProvider),
      );
    });

final lancamentoRepositoryProvider = Provider<LancamentoRepository>((ref) {
  final repository = LancamentoRepository(ref.watch(lancamentoStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final createLancamentoUseCaseProvider = Provider<CreateLancamentoUseCase>((
  ref,
) {
  return CreateLancamentoUseCase(
    ref.watch(resolveExtratoFaturaUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    LancamentoValidator(),
  );
});

final createLancamentosUseCaseProvider = Provider<CreateLancamentosUseCase>((
  ref,
) {
  return CreateLancamentosUseCase(
    ref.watch(resolveExtratoFaturasUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    LancamentoValidator(),
  );
});

final lancamentoCreateViewModelProvider = Provider<LancamentoCreateViewModel>(
  (ref) => LancamentoCreateViewModel(
    ref.watch(createLancamentoUseCaseProvider),
    ref.watch(createLancamentosUseCaseProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
    ref.watch(categoriaRepositoryProvider),
    ref.watch(centroCustoRepositoryProvider),
    ref.watch(categoriaTreeUseCaseProvider),
  ),
);

final updateLancamentoUseCaseProvider = Provider<UpdateLancamentoUseCase>((
  ref,
) {
  return UpdateLancamentoUseCase(
    ref.watch(resolveExtratoFaturaUseCaseProvider),
    ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    LancamentoValidator(),
  );
});

final lancamentoUpdateViewModelProvider = Provider<LancamentoUpdateViewModel>(
  (ref) => LancamentoUpdateViewModel(
    ref.watch(updateLancamentoUseCaseProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
    ref.watch(categoriaRepositoryProvider),
    ref.watch(centroCustoRepositoryProvider),
    ref.watch(categoriaTreeUseCaseProvider),
  ),
);

final reconcileLancamentosUseCaseProvider =
    Provider<ReconcileLancamentosUseCase>((ref) {
      return ReconcileLancamentosUseCase(
        ref.watch(lancamentoRepositoryProvider),
      );
    });

final lancamentoReconcileViewModelProvider =
    ChangeNotifierProvider<LancamentoReconcileViewModel>(
      (ref) => LancamentoReconcileViewModel(
        ref.watch(reconcileLancamentosUseCaseProvider),
      ),
    );

final updateLancamentosDataUseCaseProvider =
    Provider<UpdateLancamentosDataUseCase>((ref) {
      return UpdateLancamentosDataUseCase(
        ref.watch(resolveExtratoFaturaUseCaseProvider),
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(extratoFaturaRepositoryProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
      );
    });

final lancamentoUpdateDataViewModelProvider =
    ChangeNotifierProvider<LancamentoUpdateDataViewModel>(
      (ref) => LancamentoUpdateDataViewModel(
        ref.watch(updateLancamentosDataUseCaseProvider),
      ),
    );

final updateLancamentosDataGrupoUseCaseProvider =
    Provider<UpdateLancamentosDataGrupoUseCase>((ref) {
      return UpdateLancamentosDataGrupoUseCase(
        ref.watch(resolveExtratoFaturaUseCaseProvider),
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(extratoFaturaRepositoryProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
      );
    });

final lancamentosUpdateDataGrupoViewModelProvider =
    ChangeNotifierProvider<LancamentosUpdateDataGrupoViewModel>(
      (ref) => LancamentosUpdateDataGrupoViewModel(
        ref.watch(updateLancamentosDataGrupoUseCaseProvider),
      ),
    );

final updateLancamentosMetadataUseCaseProvider =
    Provider<UpdateLancamentosMetadataUseCase>((ref) {
      return UpdateLancamentosMetadataUseCase(
        ref.watch(lancamentoRepositoryProvider),
      );
    });

final lancamentoUpdateMetadataViewModelProvider =
    ChangeNotifierProvider<LancamentoUpdateMetadataViewModel>(
      (ref) => LancamentoUpdateMetadataViewModel(
        ref.watch(updateLancamentosMetadataUseCaseProvider),
      ),
    );

final updateLancamentosItensGrupoUseCaseProvider =
    Provider<UpdateLancamentosItensGrupoUseCase>((ref) {
      return UpdateLancamentosItensGrupoUseCase(
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(extratoFaturaRepositoryProvider),
      );
    });

final lancamentosUpdateValorGrupoViewModelProvider =
    ChangeNotifierProvider<LancamentosUpdateValorGrupoViewModel>(
      (ref) => LancamentosUpdateValorGrupoViewModel(
        ref.watch(updateLancamentosItensGrupoUseCaseProvider),
        ref.watch(categoriaTreeUseCaseProvider),
        ref.watch(centroCustoRepositoryProvider),
        ref.watch(categoriaRepositoryProvider),
      ),
    );

final updateLancamentosOrigemGrupoUseCaseProvider =
    Provider<UpdateLancamentosOrigemGrupoUseCase>((ref) {
      return UpdateLancamentosOrigemGrupoUseCase(
        ref.watch(resolveExtratoFaturaUseCaseProvider),
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(extratoFaturaRepositoryProvider),
      );
    });

final lancamentosUpdateOrigemGrupoViewModelProvider =
    ChangeNotifierProvider<LancamentosUpdateOrigemGrupoViewModel>(
      (ref) => LancamentosUpdateOrigemGrupoViewModel(
        ref.watch(updateLancamentosOrigemGrupoUseCaseProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
      ),
    );

final updateLancamentosOrigemUseCaseProvider =
    Provider<UpdateLancamentosOrigemUseCase>((ref) {
      return UpdateLancamentosOrigemUseCase(
        ref.watch(resolveExtratoFaturaUseCaseProvider),
        ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(extratoFaturaRepositoryProvider),
      );
    });

final lancamentosUpdateOrigemViewModelProvider =
    ChangeNotifierProvider<LancamentosUpdateOrigemViewModel>(
      (ref) => LancamentosUpdateOrigemViewModel(
        ref.watch(updateLancamentosOrigemUseCaseProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
      ),
    );

final createTransferenciaUseCaseProvider = Provider<CreateTransferenciaUseCase>(
  (ref) {
    return CreateTransferenciaUseCase(
      ref.watch(createLancamentosUseCaseProvider),
      TransferenciaValidator(),
    );
  },
);

final transferenciaCreateViewModelProvider =
    ChangeNotifierProvider<TransferenciaCreateViewModel>(
      (ref) => TransferenciaCreateViewModel(
        ref.watch(createTransferenciaUseCaseProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
      ),
    );

final updateTransferenciaUseCaseProvider = Provider<UpdateTransferenciaUseCase>(
  (ref) {
    return UpdateTransferenciaUseCase(
      ref.watch(resolveExtratoFaturasUseCaseProvider),
      ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
      ref.watch(lancamentoRepositoryProvider),
      ref.watch(extratoFaturaRepositoryProvider),
      TransferenciaValidator(),
    );
  },
);

final transferenciaUpdateViewModelProvider =
    ChangeNotifierProvider.family<TransferenciaUpdateViewModel, String>(
      (ref, grupoId) => TransferenciaUpdateViewModel(
        ref.watch(updateTransferenciaUseCaseProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
        ref.watch(lancamentoRepositoryProvider),
        grupoId,
      ),
    );

final lancamentoDetailsUseCaseProvider = Provider<LancamentoDetailsUseCase>((
  ref,
) {
  return LancamentoDetailsUseCase(
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
    ref.watch(categoriaRepositoryProvider),
    ref.watch(centroCustoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(categoriaTreeUseCaseProvider),
  );
});

final lancamentoFilterUseCaseProvider = Provider<LancamentoFilterUseCase>((
  ref,
) {
  return LancamentoFilterUseCase();
});

final lancamentosSidebarStateProvider =
    StateNotifierProvider.autoDispose<
      LancamentosSidebarNotifier,
      LancamentosSidebarState
    >((ref) => LancamentosSidebarNotifier());

final lancamentosSidebarViewModelProvider =
    Provider.autoDispose<LancamentosSidebarViewModel>((ref) {
      final vm = LancamentosSidebarViewModel(
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
        ref.watch(centroCustoRepositoryProvider),
        ref.watch(categoriaRepositoryProvider),
        ref.watch(categoriaTreeUseCaseProvider),
      );
      ref.onDispose(vm.dispose);
      return vm;
    });

final lancamentoFilterProvider =
    StateNotifierProvider<LancamentoFilterNotifier, LancamentoFilterState>((
      ref,
    ) {
      return LancamentoFilterNotifier();
    });

final lancamentoResumoMensalUseCaseProvider =
    Provider<LancamentoResumoMensalUseCase>((ref) {
      return LancamentoResumoMensalUseCase();
    });

final syncRecorrenciasMesUseCaseProvider = Provider<SyncRecorrenciasMesUseCase>(
  (ref) {
    return SyncRecorrenciasMesUseCase(
      ref.watch(contaRepositoryProvider),
      ref.watch(cartaoRepositoryProvider),
      ref.watch(extratoFaturaRepositoryProvider),
      ref.watch(lancamentoRepositoryProvider),
      ref.watch(applyRecorrenciasUseCaseProvider),
    );
  },
);

final fecharMesUseCaseProvider = Provider<FecharMesUseCase>((ref) {
  return FecharMesUseCase(
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(lancamentoRepositoryProvider),
  );
});

final reabrirMesUseCaseProvider = Provider<ReabrirMesUseCase>((ref) {
  return ReabrirMesUseCase(
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
  );
});

final lancamentosListViewModelProvider =
    ChangeNotifierProvider.autoDispose<LancamentosListViewModel>((ref) {
      final vm = LancamentosListViewModel(
        ref.watch(lancamentoDetailsUseCaseProvider),
        ref.watch(lancamentoFilterUseCaseProvider),
        ref.watch(lancamentoResumoMensalUseCaseProvider),
        ref.watch(lancamentoRepositoryProvider),
        ref.watch(extratoFaturaRepositoryProvider),
        ref.watch(contaRepositoryProvider),
        ref.watch(cartaoRepositoryProvider),
        ref.watch(syncRecorrenciasMesUseCaseProvider),
        ref.watch(fecharMesUseCaseProvider),
        ref.watch(reabrirMesUseCaseProvider),
      );
      ref.listen(lancamentoFilterProvider, (previous, next) {
        vm.updateFilter(next);
      });
      vm.updateFilter(ref.read(lancamentoFilterProvider));
      return vm;
    });
