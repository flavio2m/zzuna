import 'package:freezed_annotation/freezed_annotation.dart';

part 'registro_compra_entity.freezed.dart';
part 'registro_compra_entity.g.dart';

@freezed
sealed class RegistroCompra with _$RegistroCompra {
  const RegistroCompra._();

  const factory RegistroCompra({
    required DateTime data,
    required double quantidade,
    @Default(0.0) double precoReal,
    String? supermercadoId,
  }) = _RegistroCompra;

  String? get supermercadoNome => supermercadoId;

  double get valorTotal => quantidade * precoReal;

  static DateTime truncateDate(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  factory RegistroCompra.fromJson(Map<String, dynamic> json) =>
      _$RegistroCompraFromJson(json);
}

typedef RegistroCompraEntity = RegistroCompra;
