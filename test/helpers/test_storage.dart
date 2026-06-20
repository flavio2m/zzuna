import 'package:zzuna/data/services/shared_preferences_service.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';

LocalStorage<LoadedUser> createTestUserStorage({String collectionName = 'users'}) {
  return LocalStorage<LoadedUser>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: LoadedUser.fromJson,
    toJson: (user) => user.toJson(),
  );
}

LoadedUser createTestUser({
  String id = 'user-1',
  String name = 'Test User',
  String email = 'test@example.com', //
}) {
  return LoadedUser(id: id, name: name, email: email);
}

RegisterUserDto createTestUserDto({
  String id = 'user-1',
  String name = 'Test User',
  String email = 'test@example.com',
  String password = 'Aa123456!',
}) {
  return RegisterUserDto(id: id, name: name, email: email, password: password);
}

RegisterUserDto createTestRegisterUserDto(LoadedUser user) {
  return RegisterUserDto(
    id: user.id,
    name: user.name,
    email: user.email,
    password: 'password123', //
  );
}

// Cria LoadedUserDto baseado em um LoadedUser
LoadedUserDto createTestLoadedUserDto(LoadedUser user) {
  return LoadedUserDto(id: user.id, name: user.name, email: user.email);
}

LocalStorage<Conta> createTestContaStorage({String collectionName = 'contas'}) {
  return LocalStorage<Conta>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: Conta.fromJson,
    toJson: (conta) => conta.toJson(),
  );
}

LocalStorage<Cartao> createTestCartaoStorage({String collectionName = 'cartoes'}) {
  return LocalStorage<Cartao>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: Cartao.fromJson,
    toJson: (cartao) => cartao.toJson(),
  );
}

LocalStorage<CentroCusto> createTestCentroCustoStorage({
  String collectionName = 'centros_custo',
}) {
  return LocalStorage<CentroCusto>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: CentroCusto.fromJson,
    toJson: (centro) => centro.toJson(),
  );
}

LocalStorage<Categoria> createTestCategoriaStorage({
  String collectionName = 'categorias',
}) {
  return LocalStorage<Categoria>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: Categoria.fromJson,
    toJson: (categoria) => categoria.toJson(),
  );
}

LocalStorage<Lancamento> createTestLancamentoStorage({
  String collectionName = 'lancamentos',
}) {
  return LocalStorage<Lancamento>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: Lancamento.fromJson,
    toJson: (lancamento) => lancamento.toJson(),
  );
}

LocalStorage<ExtratoFatura> createTestExtratoFaturaStorage({
  String collectionName = 'extrato_faturas',
}) {
  return LocalStorage<ExtratoFatura>(
    prefsService: SharedPreferencesService(),
    collectionName: collectionName,
    fromJson: ExtratoFatura.fromJson,
    toJson: (extratoFatura) => extratoFatura.toJson(),
  );
}
