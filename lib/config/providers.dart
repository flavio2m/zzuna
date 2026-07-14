import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/user/user_repository.dart';
import 'package:zzuna/data/services/storage/providers/centro_custo_storage_provider.dart';
import 'package:zzuna/ui/centro_custo/delete/viewmodel/centro_custo_delete_viewmodel.dart';
import 'package:zzuna/ui/centro_custo/list/viewmodels/centro_custo_list_viewmodel.dart';
import 'package:zzuna/data/services/auth/auth_client_base.dart';
import 'package:zzuna/data/services/auth/firebase/auth_firebase_client.dart';
import 'package:zzuna/data/services/auth/local/auth_local_client.dart';
import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/providers/cartao_storage_provider.dart';
import 'package:zzuna/data/services/storage/providers/categoria_storage_provider.dart';
import 'package:zzuna/data/services/storage/providers/conta_storage_provider.dart';
import 'package:zzuna/data/services/storage/providers/user_storage_provider.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zzuna/ui/conta/update/viewmodels/conta_update_viewmodel.dart';

import 'package:zzuna/domain/usecases/categoria/categoria_filter_usecase.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';

import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/services/storage/providers/extrato_fatura_storage_provider.dart';
import 'package:zzuna/data/services/storage/providers/lancamento_storage_provider.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/ui/lancamentos/list/viewmodels/lancamentos_list_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_resumo_mensal_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/fechar_mes_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/reabrir_mes_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/reconcile_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/ui/lancamentos/create/viewmodels/lancamento_create_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/update/individual/viewmodels/lancamento_update_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/reconcile/viewmodels/lancamento_reconcile_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_data/viewmodels/lancamento_update_data_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_grupo_usecase.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_data_grupo/viewmodels/lancamentos_update_data_grupo_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_metadata_usecase.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_metadata/viewmodels/lancamento_update_metadata_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_itens_grupo_usecase.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_valor_grupo/viewmodels/lancamentos_update_valor_grupo_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_origem_grupo_usecase.dart';
import 'package:zzuna/ui/lancamentos/update/por_grupo/update_origem_grupo/viewmodels/lancamentos_update_origem_grupo_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_origem_usecase.dart';
import 'package:zzuna/ui/lancamentos/update/por_selecao/update_origem/viewmodels/lancamentos_update_origem_viewmodel.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';
import 'package:zzuna/domain/usecases/lancamento/create_transferencia_usecase.dart';
import 'package:zzuna/ui/lancamentos/transferencia/viewmodels/transferencia_create_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/update_transferencia_usecase.dart';
import 'package:zzuna/ui/lancamentos/transferencia/viewmodels/transferencia_update_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/criar_recorrencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/finalizar_recorrencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/reativar_recorrencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/atualizar_data_recorrencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/atualizar_sequencia_recorrencia_usecase.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/criar/viewmodels/lancamentos_criar_recorrencia_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/finalizar/viewmodels/lancamentos_finalizar_recorrencia_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/reativar/viewmodels/lancamentos_reativar_recorrencia_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/recorrencia/atualizar_data/viewmodels/lancamentos_atualizar_data_recorrencia_viewmodel.dart';
import 'package:zzuna/domain/usecases/lancamento/sync_recorrencias_mes_usecase.dart';

part 'providers/conta_providers.dart';
part 'providers/cartao_providers.dart';
part 'providers/categoria_providers.dart';
part 'providers/centro_custo_providers.dart';
part 'providers/extrato_fatura_providers.dart';
part 'providers/lancamento_providers.dart';

// ============================================================================
// SERVICES - Camada de Infraestrutura
// ============================================================================

/// Provider para instância do Dio (HTTP Client)
// final dioProvider = Provider<Dio>((ref) => Dio());

/// Provider para cliente de autenticação local
final authLocalClientProvider = Provider<AuthLocalClient>(
  (ref) => AuthLocalClient(ref.watch(userLocalStorageProvider)), //
);

/// Provider para cliente de autenticação Firebase
final authFirebaseClientProvider = Provider<AuthFirebaseClient>(
  (ref) => AuthFirebaseClient(ref.watch(userLocalStorageProvider)), //
);

/// Provider condicional de autenticação
final authClientProvider = Provider<AuthClientBase>((ref) {
  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    return ref.watch(authLocalClientProvider);
  } else {
    return ref.watch(authFirebaseClientProvider);
  }
});

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
    ref.watch(authClientProvider),
    ref.watch(userRepositoryProvider), //
  );

  ref.onDispose(repository.dispose);

  return repository;
});

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
