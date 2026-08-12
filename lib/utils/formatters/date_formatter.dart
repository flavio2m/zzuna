class DateFormatter {
  static String fullDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    final weekdays = {
      DateTime.monday: 'Segunda-feira',
      DateTime.tuesday: 'Terça-feira',
      DateTime.wednesday: 'Quarta-feira',
      DateTime.thursday: 'Quinta-feira',
      DateTime.friday: 'Sexta-feira',
      DateTime.saturday: 'Sábado',
      DateTime.sunday: 'Domingo',
    };

    final weekdayStr = weekdays[date.weekday] ?? '';
    return '$day/$month/$year, $weekdayStr';
  }

  static String shortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final weekdays = {
      DateTime.monday: 'Segunda',
      DateTime.tuesday: 'Terça',
      DateTime.wednesday: 'Quarta',
      DateTime.thursday: 'Quinta',
      DateTime.friday: 'Sexta',
      DateTime.saturday: 'Sábado',
      DateTime.sunday: 'Domingo',
    };
    final weekdayStr = weekdays[date.weekday] ?? '';
    return '$day, $weekdayStr';
  }

  static String dma(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}
