enum Mes {
  janeiro(1, 'Janeiro'),
  fevereiro(2, 'Fevereiro'),
  marco(3, 'Março'),
  abril(4, 'Abril'),
  maio(5, 'Maio'),
  junho(6, 'Junho'),
  julho(7, 'Julho'),
  agosto(8, 'Agosto'),
  setembro(9, 'Setembro'),
  outubro(10, 'Outubro'),
  novembro(11, 'Novembro'),
  dezembro(12, 'Dezembro');

  const Mes(this.numero, this.descricao);

  final int numero;
  final String descricao;

  static Mes fromNumero(int numero) => values.firstWhere((m) => m.numero == numero);

  static Mes fromDate(DateTime date) => fromNumero(date.month);

  Mes get anterior => numero == 1 ? Mes.dezembro : values[numero - 2];

  Mes get proximo => numero == 12 ? Mes.janeiro : values[numero];
}
