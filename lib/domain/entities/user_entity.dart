import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    @Default(0.0) double orcamento,
  }) = LoadedUser;

  const factory User.notLogged() = NotLoggedUser;

  const factory User.logged({
    required String id,
    required String name,
    required String email,
    required String token,
    required String refreshToken,
    @Default(0.0) double orcamento,
  }) = LoggedUser;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserExtension on User {
  double get orcamentoValor => switch (this) {
    LoadedUser(:final orcamento) => orcamento,
    LoggedUser(:final orcamento) => orcamento,
    NotLoggedUser() => 0.0,
  };

  String? get currentId => switch (this) {
    LoadedUser(:final id) => id,
    LoggedUser(:final id) => id,
    NotLoggedUser() => null,
  };

  String? get currentName => switch (this) {
    LoadedUser(:final name) => name,
    LoggedUser(:final name) => name,
    NotLoggedUser() => null,
  };

  String? get currentEmail => switch (this) {
    LoadedUser(:final email) => email,
    LoggedUser(:final email) => email,
    NotLoggedUser() => null,
  };
}
