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
// import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/ui/conta/update/viewmodels/conta_update_viewmodel.dart';

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

final categoriaRepositoryProvider = Provider<CategoriaRepository>((ref) {
  final repository = CategoriaRepository(ref.watch(categoriaStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

// ============================================================================
// VIEWMODELS - Camada de Apresentação
// ============================================================================

/// Provider para LoginViewModel
final loginViewModelProvider = Provider<LoginViewModel>(
  (ref) => LoginViewModel(ref.watch(authRepositoryProvider)), //
);

/// Provider para LogoutViewModel
final logoutViewModelProvider = Provider<LogoutViewModel>(
  (ref) => LogoutViewModel(ref.watch(authRepositoryProvider)), //
);

/// Provider para RegisterViewModel
final registerViewModelProvider = Provider<RegisterViewModel>(
  (ref) => RegisterViewModel(ref.watch(authRepositoryProvider)),
);

/// Provider para ContaListViewModel
final contaListViewModelProvider = ChangeNotifierProvider<ContaListViewModel>(
  (ref) => ContaListViewModel(ref.watch(contaRepositoryProvider)),
);

final cartaoListViewModelProvider = ChangeNotifierProvider<CartaoListViewModel>(
  (ref) => CartaoListViewModel(ref.watch(cartaoRepositoryProvider)),
);

final cartaoCreateViewModelProvider = Provider<CartaoCreateViewModel>(
  (ref) => CartaoCreateViewModel(ref.watch(cartaoRepositoryProvider)),
);

final cartaoUpdateViewModelProvider = Provider<CartaoUpdateViewModel>(
  (ref) => CartaoUpdateViewModel(ref.watch(cartaoRepositoryProvider)),
);

final cartaoDeleteViewModelProvider = Provider<CartaoDeleteViewModel>(
  (ref) => CartaoDeleteViewModel(ref.watch(cartaoRepositoryProvider)),
);

final contaCreateViewModelProvider = Provider<ContaCreateViewModel>(
  (ref) => ContaCreateViewModel(ref.watch(contaRepositoryProvider)),
);

final contaUpdateViewModelProvider = Provider<ContaUpdateViewModel>(
  (ref) => ContaUpdateViewModel(ref.watch(contaRepositoryProvider)),
);

final contaDeleteViewModelProvider = Provider<ContaDeleteViewModel>(
  (ref) => ContaDeleteViewModel(ref.watch(contaRepositoryProvider)),
);

// Centro de Custo
final centroCustoRepositoryProvider = Provider<CentroCustoRepository>((ref) {
  final repository = CentroCustoRepository(ref.watch(centroCustoStorageProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final centroCustoListViewModelProvider = ChangeNotifierProvider<CentroCustoListViewModel>(
  (ref) => CentroCustoListViewModel(ref.watch(centroCustoRepositoryProvider)),
);

final centroCustoCreateViewModelProvider = Provider<CentroCustoCreateViewModel>(
  (ref) => CentroCustoCreateViewModel(ref.watch(centroCustoRepositoryProvider)),
);

final centroCustoUpdateViewModelProvider = Provider<CentroCustoUpdateViewModel>(
  (ref) => CentroCustoUpdateViewModel(ref.watch(centroCustoRepositoryProvider)),
);

final centroCustoDeleteViewModelProvider = Provider<CentroCustoDeleteViewModel>(
  (ref) => CentroCustoDeleteViewModel(ref.watch(centroCustoRepositoryProvider)),
);

// Categoria
final categoriaListViewModelProvider = ChangeNotifierProvider<CategoriaListViewModel>(
  (ref) => CategoriaListViewModel(ref.watch(categoriaRepositoryProvider)),
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
