import 'package:zzuna/domain/enums/mes.dart';

class ExtratoFilterDto {
  Mes? mes;
  int? ano;
  bool? fechado;

  ExtratoFilterDto({
    this.mes,
    this.ano,
    this.fechado,
  });

  void setMes(Mes? value) {
    mes = value;
  }

  void setAno(int? value) {
    ano = value;
  }

  void setFechado(bool? value) {
    fechado = value;
  }
}
