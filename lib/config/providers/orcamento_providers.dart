part of '../providers.dart';

final getOrcamentoComparativoUseCaseProvider =
    Provider<GetOrcamentoComparativoUseCase>((ref) {
      return GetOrcamentoComparativoUseCase();
    });

final orcamentoComparativoViewModelProvider =
    ChangeNotifierProvider<OrcamentoComparativoViewModel>((ref) {
      return OrcamentoComparativoViewModel(
        ref.watch(getOrcamentoComparativoUseCaseProvider),
        ref.watch(categoriaRepositoryProvider),
      );
    });

final orcamentoComparativoModelProvider =
    Provider<OrcamentoMensalComparativoModel>((ref) {
      final lancamentosVm = ref.watch(lancamentosListViewModelProvider);
      final orcamentoVm = ref.watch(orcamentoComparativoViewModelProvider);
      final user =
          ref.watch(userProvider).valueOrNull ?? const User.notLogged();

      return orcamentoVm.calcular(
        lancamentos: lancamentosVm.lancamentos,
        rendaReferencia: user.orcamentoValor,
      );
    });
