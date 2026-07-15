import 'package:firebase_auth/firebase_auth.dart';
import 'package:zzuna/data/exception/firebase_auth_exception.dart';
import 'package:zzuna/data/services/auth/auth_client_base.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

class AuthFirebaseClient implements AuthClientBase {
  final BaseStorage<LoadedUser> _userStorage;
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseClient(this._userStorage, {FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  AsyncResult<LoggedUser> login(Credentials credentials) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return Failure(
          FirebaseAuthClientException('Usuário retornado do Firebase nulo.'),
        );
      }

      // Buscar as informações completas do usuário (como o nome) no Storage
      final userResult = await _userStorage.getById(firebaseUser.uid);
      if (userResult.isError()) {
        return Failure(userResult.exceptionOrNull()!);
      }

      final loadedUser = userResult.getOrThrow();

      // Obter o token
      final token = await firebaseUser.getIdToken() ?? '';

      return Success(
        LoggedUser(
          id: loadedUser.id,
          name: loadedUser.name,
          email: loadedUser.email,
          token: token,
          refreshToken: firebaseUser.refreshToken ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Failure(
        FirebaseAuthClientException(_mapFirebaseAuthExceptionMessage(e.code)),
      );
    } catch (e) {
      return Failure(FirebaseAuthClientException(e.toString()));
    }
  }

  @override
  AsyncResult<Unit> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(unit);
    } catch (e) {
      return Failure(FirebaseAuthClientException(e.toString()));
    }
  }

  @override
  AsyncResult<LoggedUser> registerUser(RegisterUserDto dto) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return Failure(
          FirebaseAuthClientException('Usuário criado no Firebase está nulo.'),
        );
      }

      final uid = firebaseUser.uid;

      final token = await firebaseUser.getIdToken() ?? '';

      return Success(
        LoggedUser(
          id: uid,
          name: dto.name,
          email: dto.email,
          token: token,
          refreshToken: firebaseUser.refreshToken ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Failure(
        FirebaseAuthClientException(_mapFirebaseAuthExceptionMessage(e.code)),
      );
    } catch (e) {
      return Failure(FirebaseAuthClientException(e.toString()));
    }
  }

  @override
  AsyncResult<LoggedUser> updateUser(LoadedUserDto dto) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Failure(
          FirebaseAuthClientException(
            'Nenhum usuário autenticado no Firebase.',
          ),
        );
      }

      final token = await currentUser.getIdToken() ?? '';

      return Success(
        LoggedUser(
          id: dto.id,
          name: dto.name,
          email: dto.email,
          token: token,
          refreshToken: currentUser.refreshToken ?? '',
        ),
      );
    } catch (e) {
      return Failure(FirebaseAuthClientException(e.toString()));
    }
  }

  @override
  Stream<LoggedUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final userResult = await _userStorage.getById(firebaseUser.uid);
      if (userResult.isSuccess()) {
        final loadedUser = userResult.getOrThrow();
        final token = await firebaseUser.getIdToken() ?? '';
        return LoggedUser(
          id: loadedUser.id,
          name: loadedUser.name,
          email: loadedUser.email,
          token: token,
          refreshToken: firebaseUser.refreshToken ?? '',
        );
      }
      return null;
    });
  }

  String _mapFirebaseAuthExceptionMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'operation-not-allowed':
        return 'Autenticação por email/senha desabilitada no console.';
      case 'invalid-credential':
        return 'E-mail ou senha inválidos.';
      default:
        return 'Ocorreu um erro na autenticação ($code).';
    }
  }
}
