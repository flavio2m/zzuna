import 'package:zzuna/domain/enums/mes.dart';

class ExtratoDto {
  String? id;
  String contaId;
  int ano;
  Mes mes;
  DateTime dataInicio;
  DateTime dataFim;
  bool fechado;

  ExtratoDto({
    this.id,
    this.contaId = '',
    this.ano = 2026,
    this.mes = Mes.janeiro,
    DateTime? dataInicio,
    DateTime? dataFim,
    this.fechado = false,
  }) : dataInicio = dataInicio ?? DateTime.now(),
       dataFim = dataFim ?? DateTime.now();

  void setId(String? id) {
    this.id = id;
  }

  void setContaId(String contaId) {
    this.contaId = contaId;
  }

  void setAno(int ano) {
    this.ano = ano;
  }

  void setMes(Mes mes) {
    this.mes = mes;
  }

  void setDataInicio(DateTime dataInicio) {
    this.dataInicio = dataInicio;
  }

  void setDataFim(DateTime dataFim) {
    this.dataFim = dataFim;
  }

  void setFechado(bool fechado) {
    this.fechado = fechado;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contaId': contaId,
    'ano': ano,
    'mes': mes.numero,
    'dataInicio': dataInicio.toIso8601String(),
    'dataFim': dataFim.toIso8601String(),
    'fechado': fechado,
  };

  factory ExtratoDto.fromJson(Map<String, dynamic> json) {
    return ExtratoDto(
      id: json['id'],
      contaId: json['contaId'] ?? '',
      ano: json['ano'] ?? 2026,
      mes: Mes.values.firstWhere((e) => e.numero == json['mes']),
      dataInicio: DateTime.parse(json['dataInicio']),
      dataFim: DateTime.parse(json['dataFim']),
      fechado: json['fechado'] ?? false,
    );
  }
}
