import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';

const _sentinel = Object();

class ListaComprasFilterDto {
  final int ano;
  final Mes mes;
  final ItemCompraSituacao? situacao;
  final String? supermercado;

  const ListaComprasFilterDto({
    required this.ano,
    required this.mes,
    this.situacao,
    this.supermercado,
  });

  int get periodo => ano * 100 + mes.numero;

  ListaComprasFilterDto copyWith({
    int? ano,
    Mes? mes,
    Object? situacao = _sentinel,
    Object? supermercado = _sentinel,
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
    );
  }
}
