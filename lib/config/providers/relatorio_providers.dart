import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/usecases/relatorio/get_relatorio_mensal_usecase.dart';
import 'package:zzuna/ui/relatorios/viewmodels/relatorios_viewmodel.dart';

final getRelatorioMensalUseCaseProvider = Provider<GetRelatorioMensalUseCase>((
  ref,
) {
  return GetRelatorioMensalUseCase();
});

final relatoriosViewModelProvider =
    ChangeNotifierProvider.autoDispose<RelatoriosViewModel>((ref) {
      final detailsUseCase = ref.watch(lancamentoDetailsUseCaseProvider);
      final getRelatorioUseCase = ref.watch(getRelatorioMensalUseCaseProvider);
      final repository = ref.watch(lancamentoRepositoryProvider);

      final viewModel = RelatoriosViewModel(
        detailsUseCase,
        getRelatorioUseCase,
        repository,
      );

      viewModel.loadCommand.execute();
      return viewModel;
    });
