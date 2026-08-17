import 'package:zzuna/domain/enums/mes.dart';

class RelatorioFilterState {
  final Mes mes;
  final int ano;

  RelatorioFilterState({required this.mes, required this.ano});

  factory RelatorioFilterState.initial() {
    final now = DateTime.now();
    return RelatorioFilterState(mes: Mes.fromDate(now), ano: now.year);
  }

  RelatorioFilterState copyWith({Mes? mes, int? ano}) {
    return RelatorioFilterState(mes: mes ?? this.mes, ano: ano ?? this.ano);
  }
}
