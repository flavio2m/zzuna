import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/statics/banks/banco.dart';

part 'conta_entity.freezed.dart';
part 'conta_entity.g.dart';

@freezed
sealed class Conta with _$Conta {
  const factory Conta({
    required String id,
    required String descricao,
    required String bancoSigla,
    required bool ativo,
  }) = _Conta;

  factory Conta.fromJson(Map<String, dynamic> json) => _$ContaFromJson(json);
}

@freezed
sealed class ContaDetails with _$ContaDetails {
  const factory ContaDetails({
    required String id,
    required String descricao,
    required Banco banco,
    required bool ativo,
  }) = _ContaDetails;
}
