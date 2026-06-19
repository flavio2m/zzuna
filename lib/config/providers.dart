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
import 'package:zzuna/ui/lancamentos/models/lancamentos_sidebar_notifier.dart';
import 'package:zzuna/ui/lancamentos/models/lancamentos_sidebar_state.dart';
import 'package:zzuna/ui/lancamentos/viewmodels/lancamentos_sidebar_viewmodel.dart';
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

import 'package:zzuna/data/repositories/lancamento/extrato_repository.dart';
import 'package:zzuna/data/repositories/lancamento/fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/services/storage/local/extrato_storage_provider.dart';
import 'package:zzuna/data/services/storage/local/fatura_storage_provider.dart';
import 'package:zzuna/data/services/storage/local/lancamento_storage_provider.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/ui/lancamentos/viewmodels/lancamentos_list_viewmodel.dart';

// ============================================================================
// SERVICES - Camada de Infraestrutura
// ============================================================================

/// Provider para instância do Dio (HTTP Client)
// final dioProvider = Provider<Dio>((ref) => Dio());

/// Provider para cliente de autenticação local
final authLocalClientProvider = Provider<AuthLocalClient>(
  (ref) => AuthLocalClient(ref.watch(userLocalStorageProvider)), //
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

final lancamentoRepositoryProvider = Provider<LancamentoRepository>((ref) {
  final repository = LancamentoRepository(ref.watch(lancamentoStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final faturaRepositoryProvider = Provider<FaturaRepository>((ref) {
  final repository = FaturaRepository(ref.watch(faturaStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final extratoRepositoryProvider = Provider<ExtratoRepository>((ref) {
  final repository = ExtratoRepository(ref.watch(extratoStorageProvider));
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
    ref.watch(faturaRepositoryProvider),
    ref.watch(extratoRepositoryProvider),
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

final lancamentosSidebarStateProvider = StateNotifierProvider.autoDispose<LancamentosSidebarNotifier, LancamentosSidebarState>(
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

final lancamentosListViewModelProvider =
    Provider.autoDispose<LancamentosListViewModel>((ref) {
  final vm = LancamentosListViewModel(
    ref.watch(lancamentoDetailsUseCaseProvider),
    ref.watch(lancamentoFilterUseCaseProvider),
    ref.watch(lancamentoRepositoryProvider),
  );
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
