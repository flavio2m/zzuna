import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';

part 'cartao_entity.freezed.dart';
part 'cartao_entity.g.dart';

@freezed
sealed class Cartao with _$Cartao {
  const factory Cartao({
    required String id,
    required String descricao,
    required double limite,
    required String bancoSigla,
    required bool ativo,
    required int diaFechamento,
    required DateTime dataInicial,
  }) = _Cartao;

  factory Cartao.fromJson(Map<String, dynamic> json) => _$CartaoFromJson(json);
}

@freezed
sealed class CartaoDetails with _$CartaoDetails {
  const factory CartaoDetails({
    required String id,
    required String descricao,
    required double limite,
    required Banco banco,
    required bool ativo,
    required int diaFechamento,
    required DateTime dataInicial,
  }) = _CartaoDetails;
}
