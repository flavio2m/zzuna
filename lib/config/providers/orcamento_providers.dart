part of '../providers.dart';

final getOrcamentoComparativoUseCaseProvider =
    Provider<GetOrcamentoComparativoUseCase>((ref) {
      return GetOrcamentoComparativoUseCase();
    });

final orcamentoComparativoViewModelProvider =
    ChangeNotifierProvider<OrcamentoComparativoViewModel>((ref) {
      return OrcamentoComparativoViewModel(
        ref.watch(getOrcamentoComparativoUseCaseProvider),
      );
    });

final orcamentoComparativoModelProvider =
    Provider<OrcamentoMensalComparativoModel>((ref) {
      final lancamentosVm = ref.watch(lancamentosListViewModelProvider);
      final categoriasVm = ref.watch(categoriaListViewModelProvider);
      final user =
          ref.watch(userProvider).valueOrNull ?? const User.notLogged();
      final useCase = ref.watch(getOrcamentoComparativoUseCaseProvider);

      return useCase.execute(
        lancamentos: lancamentosVm.lancamentos,
        categoriasPai: categoriasVm.categoriasPai,
        rendaReferencia: user.orcamentoValor,
      );
    });
