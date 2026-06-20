import 'package:zzuna/domain/enums/mes.dart';

class ExtratoFaturaFilterDto {
  int ano;
  Mes mes;
  bool? fechado;

  ExtratoFaturaFilterDto({required this.mes, required this.ano, this.fechado});

  void setAno(int value) {
    ano = value;
  }

  void setMes(Mes value) {
    mes = value;
  }

  void setFechado(bool? value) {
    fechado = value;
  }
}
