import 'package:zzuna/domain/enums/mes.dart';

class ListaComprasFilterDto {
  final int ano;
  final Mes mes;

  const ListaComprasFilterDto({
    required this.ano,
    required this.mes,
  });

  int get periodo => ano * 100 + mes.numero;

  ListaComprasFilterDto copyWith({
    int? ano,
    Mes? mes,
  }) {
    return ListaComprasFilterDto(
      ano: ano ?? this.ano,
      mes: mes ?? this.mes,
    );
  }
}
