import 'package:zzuna/domain/enums/mes.dart';

class FaturaDto {
  String? id;
  String cartaoId;
  int ano;
  Mes mes;
  DateTime dataInicio;
  DateTime dataFim;
  bool fechada;

  FaturaDto({
    this.id,
    this.cartaoId = '',
    this.ano = 2026,
    this.mes = Mes.janeiro,
    DateTime? dataInicio,
    DateTime? dataFim,
    this.fechada = false,
  }) : dataInicio = dataInicio ?? DateTime.now(),
       dataFim = dataFim ?? DateTime.now();

  void setId(String? id) {
    this.id = id;
  }

  void setCartaoId(String cartaoId) {
    this.cartaoId = cartaoId;
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

  void setFechada(bool fechada) {
    this.fechada = fechada;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cartaoId': cartaoId,
    'ano': ano,
    'mes': mes.numero,
    'dataInicio': dataInicio.toIso8601String(),
    'dataFim': dataFim.toIso8601String(),
    'fechada': fechada,
  };

  factory FaturaDto.fromJson(Map<String, dynamic> json) {
    return FaturaDto(
      id: json['id'],
      cartaoId: json['cartaoId'] ?? '',
      ano: json['ano'] ?? 2026,
      mes: Mes.values.firstWhere((e) => e.numero == json['mes']),
      dataInicio: DateTime.parse(json['dataInicio']),
      dataFim: DateTime.parse(json['dataFim']),
      fechada: json['fechada'] ?? false,
    );
  }
}
