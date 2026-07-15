import 'package:freezed_annotation/freezed_annotation.dart';

part 'centro_custo_entity.freezed.dart';
part 'centro_custo_entity.g.dart';

@freezed
sealed class CentroCusto with _$CentroCusto {
  const factory CentroCusto({
    required String id,
    required String descricao,
    required bool ativo,
    @Default(false) bool padrao,
  }) = _CentroCusto;

  factory CentroCusto //
  .fromJson(Map<String, dynamic> json) => _$CentroCustoFromJson(json);
}

@freezed
sealed class CentroCustoDetails with _$CentroCustoDetails {
  const factory CentroCustoDetails({
    required String id,
    required String descricao,
    required bool ativo,
    @Default(false) bool padrao,
  }) = _CentroCustoDetails;

  factory CentroCustoDetails //
  .fromJson(Map<String, dynamic> json) => _$CentroCustoDetailsFromJson(json);
}
