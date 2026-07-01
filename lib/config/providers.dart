import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/data/services/storage/local/centro_custo_storage_provider.dart';
import 'package:zzuna/ui/centro_custo/delete/viewmodel/centro_custo_delete_viewmodel.dart';
import 'package:zzuna/ui/centro_custo/list/viewmodels/centro_custo_list_viewmodel.dart';
import 'package:zzuna/data/services/auth/local/auth_local_client.dart';
import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/local/cartao_storage_provider.dart';
import 'package:zzuna/data/services/storage/local/categoria_storage_provider.dart';
import 'package:zzuna/data/services/storage/local/conta_storage_provider.dart';
import 'package:zzuna/data/services/storage/local/user_storage_provider.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/ui/auth/login/viewmodels/login_viewmodel.dart';
import 'package:zzuna/ui/auth/logout/viewmodels/logout_viewmodel.dart';
import 'package:zzuna/ui/auth/register/viewmodels/register_viewmodel.dart';
import 'package:zzuna/ui/categoria/create/viewModels/categoria_create_viewmodel.dart';
import 'package:zzuna/ui/categoria/delete/viewModel/categoria_delete_viewmodel.dart';
import 'package:zzuna/ui/categoria/list/viewmodels/categoria_list_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/sidebar/models/lancamentos_sidebar_notifier.dart';
import 'package:zzuna/ui/lancamentos/sidebar/models/lancamentos_sidebar_state.dart';
import 'package:zzuna/ui/lancamentos/sidebar/viewmodels/lancamentos_sidebar_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_state.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_notifier.dart';
import 'package:zzuna/ui/categoria/update/viewmodels/categoria_update_viewmodel.dart';
import 'package:zzuna/ui/conta/create/viewModels/conta_create_viewmodel.dart';
import 'package:zzuna/ui/conta/delete/viewModel/conta_delete_viewmodel.dart';
import 'package:zzuna/ui/centro_custo/create/viewmodels/centro_custo_create_viewmodel.dart';
import 'package:zzuna/ui/cartao/create/viewModels/cartao_create_viewmodel.dart';
import 'package:zzuna/ui/cartao/delete/viewModel/cartao_delete_viewmodel.dart';
import 'package:zzuna/ui/cartao/list/viewmodels/cartao_list_viewmodel.dart';
import 'package:zzuna/ui/cartao/update/viewmodels/cartao_update_viewmodel.dart';
import 'package:zzuna/ui/centro_custo/update/viewmodels/centro_custo_update_viewmodel.dart';
import 'package:zzuna/ui/conta/list/viewmodels/conta_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/ui/conta/update/viewmodels/conta_update_viewmodel.dart';

import 'package:zzuna/domain/usecases/categoria/categoria_filter_usecase.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';

import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/services/storage/local/extrato_fatura_storage_provider.dart';
import 'package:zzuna/data/services/storage/local/lancamento_storage_provider.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/ui/lancamentos/list/viewmodels/lancamentos_list_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_resumo_mensal_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/reconcile_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/ui/lancamentos/create/viewmodels/lancamento_create_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/update/viewmodels/lancamento_update_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/reconcile/viewmodels/lancamento_reconcile_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/update_data/viewmodels/lancamento_update_data_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_grupo_usecase.dart';
import 'package:zzuna/ui/lancamentos/update_data_grupo/viewmodels/lancamentos_update_data_grupo_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_metadata_usecase.dart';
import 'package:zzuna/ui/lancamentos/update_metadata/viewmodels/lancamento_update_metadata_viewmodel.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';
import 'package:zzuna/domain/usecases/lancamento/create_transferencia_usecase.dart';
import 'package:zzuna/ui/lancamentos/transferencia/viewmodels/transferencia_create_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_transferencia_usecase.dart';
import 'package:zzuna/ui/lancamentos/transferencia/viewmodels/transferencia_update_viewmodel.dart';

// ============================================================================
// SERVICES - Camada de Infraestrutura
// ============================================================================

/// Provider para instância do Dio (HTTP Client)
// final dioProvider = Provider<Dio>((ref) => Dio());

/// Provider para cliente de autenticação local
final authLocalClientProvider = Provider<AuthLocalClient>(
  (ref) => AuthLocalClient(ref.watch(userLocalStorageProvider)), //
);

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>(
  (ref) => SharedPreferencesService(),
);

// ============================================================================
// REPOSITORIES - Camada de Dados
// ============================================================================

/// Provider para UserRepository com lifecycle gerenciado
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final repository = UserRepository(ref.watch(userLocalStorageProvider));

  ref.onDispose(repository.dispose);

  return repository;
});

/// Provider para AuthRepository com lifecycle gerenciado
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = AuthRepository(
    ref.watch(authLocalClientProvider),
    ref.watch(userRepositoryProvider), //
  );

  ref.onDispose(repository.dispose);

  return repository;
});

final contaRepositoryProvider = Provider<ContaRepository>((ref) {
  final repository = ContaRepository(ref.watch(contaStorageProvider));

  ref.onDispose(repository.dispose);

  return repository;
});

final cartaoRepositoryProvider = Provider<CartaoRepository>((ref) {
  final repository = CartaoRepository(ref.watch(cartaoStorageProvider));

  ref.onDispose(repository.dispose);

  return repository;
});

final centroCustoRepositoryProvider = Provider<CentroCustoRepository>((ref) {
  final repository = CentroCustoRepository(ref.watch(centroCustoStorageProvider));

  ref.onDispose(repository.dispose);

  return repository;
});

final categoriaRepositoryProvider = Provider<CategoriaRepository>((ref) {
  final repository = CategoriaRepository(ref.watch(categoriaStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final recalculateExtratoFaturaBalanceUseCaseProvider = Provider<RecalculateExtratoFaturaBalanceUseCase>((ref) {
  return RecalculateExtratoFaturaBalanceUseCase(
    ref.watch(extratoFaturaStorageProvider),
    ref.watch(lancamentoStorageProvider),
  );
});

final resolveExtratoFaturaUseCaseProvider = Provider<ResolveExtratoFaturaUseCase>((ref) {
  return ResolveExtratoFaturaUseCase(
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
  );
});

final resolveExtratoFaturasUseCaseProvider = Provider<ResolveExtratoFaturasUseCase>((ref) {
  return ResolveExtratoFaturasUseCase(
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
  );
});

final lancamentoRepositoryProvider = Provider<LancamentoRepository>((ref) {
  final repository = LancamentoRepository(ref.watch(lancamentoStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final createLancamentoUseCaseProvider = Provider<CreateLancamentoUseCase>((ref) {
  return CreateLancamentoUseCase(
    ref.watch(resolveExtratoFaturaUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    LancamentoValidator(),
  );
});

final createLancamentosUseCaseProvider = Provider<CreateLancamentosUseCase>((ref) {
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

final updateLancamentoUseCaseProvider = Provider<UpdateLancamentoUseCase>((ref) {
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

final reconcileLancamentosUseCaseProvider = Provider<ReconcileLancamentosUseCase>((ref) {
  return ReconcileLancamentosUseCase(
    ref.watch(lancamentoRepositoryProvider),
  );
});

final lancamentoReconcileViewModelProvider = ChangeNotifierProvider<LancamentoReconcileViewModel>(
  (ref) => LancamentoReconcileViewModel(
    ref.watch(reconcileLancamentosUseCaseProvider),
  ),
);

final updateLancamentosDataUseCaseProvider = Provider<UpdateLancamentosDataUseCase>((ref) {
  return UpdateLancamentosDataUseCase(
    ref.watch(resolveExtratoFaturaUseCaseProvider),
    ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
  );
});

final lancamentoUpdateDataViewModelProvider = ChangeNotifierProvider<LancamentoUpdateDataViewModel>(
  (ref) => LancamentoUpdateDataViewModel(
    ref.watch(updateLancamentosDataUseCaseProvider),
  ),
);

final updateLancamentosDataGrupoUseCaseProvider = Provider<UpdateLancamentosDataGrupoUseCase>((ref) {
  return UpdateLancamentosDataGrupoUseCase(
    ref.watch(resolveExtratoFaturaUseCaseProvider),
    ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
  );
});

final lancamentosUpdateDataGrupoViewModelProvider = ChangeNotifierProvider<LancamentosUpdateDataGrupoViewModel>(
  (ref) => LancamentosUpdateDataGrupoViewModel(
    ref.watch(updateLancamentosDataGrupoUseCaseProvider),
  ),
);

final updateLancamentosMetadataUseCaseProvider = Provider<UpdateLancamentosMetadataUseCase>((ref) {
  return UpdateLancamentosMetadataUseCase(
    ref.watch(lancamentoRepositoryProvider),
  );
});

final lancamentoUpdateMetadataViewModelProvider = ChangeNotifierProvider<LancamentoUpdateMetadataViewModel>(
  (ref) => LancamentoUpdateMetadataViewModel(
    ref.watch(updateLancamentosMetadataUseCaseProvider),
  ),
);

final createTransferenciaUseCaseProvider = Provider<CreateTransferenciaUseCase>((ref) {
  return CreateTransferenciaUseCase(
    ref.watch(createLancamentosUseCaseProvider),
    TransferenciaValidator(),
  );
});

final transferenciaCreateViewModelProvider = ChangeNotifierProvider<TransferenciaCreateViewModel>(
  (ref) => TransferenciaCreateViewModel(
    ref.watch(createTransferenciaUseCaseProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
  ),
);

final updateTransferenciaUseCaseProvider = Provider<UpdateTransferenciaUseCase>((ref) {
  return UpdateTransferenciaUseCase(
    ref.watch(resolveExtratoFaturasUseCaseProvider),
    ref.watch(recalculateExtratoFaturaBalanceUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
    TransferenciaValidator(),
  );
});

final transferenciaUpdateViewModelProvider = ChangeNotifierProvider.family<TransferenciaUpdateViewModel, String>(
  (ref, grupoId) => TransferenciaUpdateViewModel(
    ref.watch(updateTransferenciaUseCaseProvider),
    ref.watch(contaRepositoryProvider),
    ref.watch(cartaoRepositoryProvider),
    ref.watch(lancamentoRepositoryProvider),
    grupoId,
  ),
);

final extratoFaturaRepositoryProvider = Provider<ExtratoFaturaRepository>((ref) {
  final repository = ExtratoFaturaRepository(ref.watch(extratoFaturaStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

// ============================================================================
// USE CASES - Camada de Domínio
// ============================================================================

final categoriaFilterUseCaseProvider = Provider<CategoriaFilterUseCase>(
  (ref) => CategoriaFilterUseCase(), //
);
final categoriaTreeUseCaseProvider = Provider<CategoriaTreeUseCase>(
  (ref) => CategoriaTreeUseCase(), //
);

final lancamentoDetailsUseCaseProvider = Provider<LancamentoDetailsUseCase>((ref) {
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

final lancamentoFilterUseCaseProvider = Provider<LancamentoFilterUseCase>((ref) {
  return LancamentoFilterUseCase();
});

// ============================================================================
// VIEWMODELS - Camada de Apresentação
// ============================================================================

// AUTH
final loginViewModelProvider = Provider<LoginViewModel>(
  (ref) => LoginViewModel(ref.watch(authRepositoryProvider)), //
);

final logoutViewModelProvider = Provider<LogoutViewModel>(
  (ref) => LogoutViewModel(ref.watch(authRepositoryProvider)), //
);

final registerViewModelProvider = Provider<RegisterViewModel>(
  (ref) => RegisterViewModel(ref.watch(authRepositoryProvider)),
);

// CONTA
final contaListViewModelProvider = Provider.autoDispose<ContaListViewModel>((ref) {
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

// CARTAO
final cartaoListViewModelProvider = Provider.autoDispose<CartaoListViewModel>((ref) {
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

// ============================================================================
// CENTRO DE CUSTO
// ============================================================================

final centroCustoListViewModelProvider = Provider.autoDispose<CentroCustoListViewModel>((ref) {
  final vm = CentroCustoListViewModel(ref.watch(centroCustoRepositoryProvider));

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

// CATEGORIA
final categoriaListViewModelProvider = ChangeNotifierProvider<CategoriaListViewModel>(
  (ref) => CategoriaListViewModel(
    ref.watch(categoriaRepositoryProvider),
    ref.watch(categoriaFilterUseCaseProvider),
    ref.watch(categoriaTreeUseCaseProvider),
  ),
);

final categoriaCreateViewModelProvider = Provider<CategoriaCreateViewModel>(
  (ref) => CategoriaCreateViewModel(ref.watch(categoriaRepositoryProvider)),
);

final categoriaUpdateViewModelProvider = Provider<CategoriaUpdateViewModel>(
  (ref) => CategoriaUpdateViewModel(ref.watch(categoriaRepositoryProvider)),
);

final categoriaDeleteViewModelProvider = Provider<CategoriaDeleteViewModel>(
  (ref) => CategoriaDeleteViewModel(ref.watch(categoriaRepositoryProvider)),
);

final lancamentosSidebarStateProvider =
    StateNotifierProvider.autoDispose<LancamentosSidebarNotifier, LancamentosSidebarState>(
      (ref) => LancamentosSidebarNotifier(),
    );

final lancamentosSidebarViewModelProvider = Provider.autoDispose<LancamentosSidebarViewModel>((ref) {
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

final lancamentoFilterProvider = StateNotifierProvider<LancamentoFilterNotifier, LancamentoFilterState>((ref) {
  return LancamentoFilterNotifier();
});

final lancamentoResumoMensalUseCaseProvider = Provider<LancamentoResumoMensalUseCase>((ref) {
  return LancamentoResumoMensalUseCase();
});

final lancamentosListViewModelProvider = ChangeNotifierProvider.autoDispose<LancamentosListViewModel>((ref) {
  final vm = LancamentosListViewModel(
    ref.watch(lancamentoDetailsUseCaseProvider),
    ref.watch(lancamentoFilterUseCaseProvider),
    ref.watch(lancamentoResumoMensalUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
    ref.watch(extratoFaturaRepositoryProvider),
  );
  ref.listen(lancamentoFilterProvider, (previous, next) {
    vm.updateFilter(next);
  });
  vm.updateFilter(ref.read(lancamentoFilterProvider));
  ref.onDispose(vm.dispose);
  return vm;
});

// ============================================================================
// STATE PROVIDERS - Estado Global da Aplicação
// ============================================================================

/// Provider que emite o estado do usuário logado
/// - Inicia com User.notLogged()
/// - Escuta mudanças do AuthRepository
final userProvider = StreamProvider<User>((ref) async* {
  yield const User.notLogged();
  yield* ref.watch(authRepositoryProvider).userObserver();
});
