import 'package:brasil_fields/brasil_fields.dart';

class CurrencyFormatter {
  /// Formata um valor numérico para o padrão monetário brasileiro sem o símbolo "R$" (ex: 1.050,00 ou 29,99)
  static String formatWithoutSymbol(double value) {
    return UtilBrasilFields.obterReal(value, moeda: false);
  }

  /// Formata um valor numérico para o padrão monetário brasileiro com o símbolo "R$" (ex: R$ 1.050,00 ou R$ 29,99)
  static String formatWithSymbol(double value) {
    return UtilBrasilFields.obterReal(value, moeda: true);
  }
}
