import 'package:zzuna/domain/enums/mes.dart';

class FaturaFilterDto {
  Mes? mes;
  int? ano;
  bool? fechada;

  FaturaFilterDto({
    this.mes,
    this.ano,
    this.fechada,
  });

  void setMes(Mes? value) {
    mes = value;
  }

  void setAno(int? value) {
    ano = value;
  }

  void setFechada(bool? value) {
    fechada = value;
  }
}
