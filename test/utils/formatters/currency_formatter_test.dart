import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test(r'formatWithoutSymbol formats double without R$', () {
      expect(CurrencyFormatter.formatWithoutSymbol(29.99), equals('29,99'));
      expect(CurrencyFormatter.formatWithoutSymbol(1050.0), equals('1.050,00'));
      expect(CurrencyFormatter.formatWithoutSymbol(0.0), equals('0,00'));
    });

    test(r'formatWithSymbol formats double with R$', () {
      expect(CurrencyFormatter.formatWithSymbol(29.99), equals(r'R$ 29,99'));
      expect(CurrencyFormatter.formatWithSymbol(1050.0), equals(r'R$ 1.050,00'));
    });
  });
}
