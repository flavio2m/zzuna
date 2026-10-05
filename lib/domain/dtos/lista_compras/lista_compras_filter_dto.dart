import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';

const _sentinel = Object();

class ListaComprasFilterDto {
  final int ano;
  final Mes mes;
  final ItemCompraSituacao? situacao;
  final String? supermercado;
  final DateTime? data;

  const ListaComprasFilterDto({
    required this.ano,
    required this.mes,
    this.situacao,
    this.supermercado,
    this.data,
  });

  int get periodo => ano * 100 + mes.numero;

  ListaComprasFilterDto copyWith({
    int? ano,
    Mes? mes,
    Object? situacao = _sentinel,
    Object? supermercado = _sentinel,
    Object? data = _sentinel,
  }) {
    return ListaComprasFilterDto(
      ano: ano ?? this.ano,
      mes: mes ?? this.mes,
      situacao: situacao == _sentinel
          ? this.situacao
          : (situacao as ItemCompraSituacao?),
      supermercado: supermercado == _sentinel
          ? this.supermercado
          : (supermercado as String?),
      data: data == _sentinel ? this.data : (data as DateTime?),
    );
  }
}
