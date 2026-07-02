import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';

void main() {
  group('clampDayToMonth', () {
    test(
      'Item 2: se o dia for 31, o sistema deve lancar no dia 30 se o mes nao tiver dia 31 (Abril)',
      () {
        final diaAbril = clampDayToMonth(31, 4, 2024);
        expect(diaAbril, 30);
      },
    );

    test('Deve lancar dia 29 se o ano for bissexto (Fevereiro 2024)', () {
      final diaFevBissexto = clampDayToMonth(31, 2, 2024);
      expect(diaFevBissexto, 29);
    });

    test('Deve lancar dia 28 se o ano nao for bissexto (Fevereiro 2023)', () {
      final diaFevNaoBissexto = clampDayToMonth(31, 2, 2023);
      expect(diaFevNaoBissexto, 28);
    });

    test('Deve manter dia 31 em meses que tem 31 dias (Marco)', () {
      final diaMarco = clampDayToMonth(31, 3, 2024);
      expect(diaMarco, 31);
    });

    test('Deve manter o dia original se for menor que o ultimo dia', () {
      final diaAbril = clampDayToMonth(15, 4, 2024);
      expect(diaAbril, 15);
    });
  });
}
