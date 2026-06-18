import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';

part 'fatura_entity.freezed.dart';
part 'fatura_entity.g.dart';

@freezed
sealed class Fatura with _$Fatura {
  const factory Fatura({
    required String id,
    required String cartaoId,
    required int ano,
    required Mes mes,
    required DateTime dataInicio,
    required DateTime dataFim,
    required bool fechada,
  }) = _Fatura;

  factory Fatura.fromJson(Map<String, dynamic> json) => _$FaturaFromJson(json);
}

@freezed
sealed class FaturaDetails with _$FaturaDetails {
  const factory FaturaDetails({
    required String id,
    required CartaoDetails cartao,
    required int ano,
    required Mes mes,
    required DateTime dataInicio,
    required DateTime dataFim,
    required bool fechada,
  }) = _FaturaDetails;
}
