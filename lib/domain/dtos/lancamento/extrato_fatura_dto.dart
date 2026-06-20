import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class ExtratoFaturaDto {
  String? id;
  LancamentoOrigem origem;
  int ano;
  Mes mes;
  DateTime dataInicio;
  DateTime dataFim;
  double saldoInicial;
  double saldoFinal;
  bool fechado;

  ExtratoFaturaDto({
    this.id,
    LancamentoOrigem? origem,
    this.ano = 2026,
    this.mes = Mes.janeiro,
    DateTime? dataInicio,
    DateTime? dataFim,
    this.saldoInicial = 0.0,
    this.saldoFinal = 0.0,
    this.fechado = false,
  }) : origem = origem ?? const LancamentoOrigem.conta(contaId: ''),
       dataInicio = dataInicio ?? DateTime.now(),
       dataFim = dataFim ?? DateTime.now();

  void setId(String? id) {
    this.id = id;
  }

  void setOrigem(LancamentoOrigem origem) {
    this.origem = origem;
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

  void setSaldoInicial(double saldoInicial) {
    this.saldoInicial = saldoInicial;
  }

  void setSaldoFinal(double saldoFinal) {
    this.saldoFinal = saldoFinal;
  }

  void setFechado(bool fechado) {
    this.fechado = fechado;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'origem': origem.toJson(),
    'ano': ano,
    'mes': mes.numero,
    'dataInicio': dataInicio.toIso8601String(),
    'dataFim': dataFim.toIso8601String(),
    'saldoInicial': saldoInicial,
    'saldoFinal': saldoFinal,
    'fechado': fechado,
  };

  factory ExtratoFaturaDto.fromJson(Map<String, dynamic> json) {
    return ExtratoFaturaDto(
      id: json['id'],
      origem: LancamentoOrigem.fromJson(Map<String, dynamic>.from(json['origem'])),
      ano: json['ano'] ?? 2026,
      mes: Mes.values.firstWhere((e) => e.numero == json['mes']),
      dataInicio: DateTime.parse(json['dataInicio']),
      dataFim: DateTime.parse(json['dataFim']),
      saldoInicial: (json['saldoInicial'] as num?)?.toDouble() ?? 0.0,
      saldoFinal: (json['saldoFinal'] as num?)?.toDouble() ?? 0.0,
      fechado: json['fechado'] ?? false,
    );
  }
}
