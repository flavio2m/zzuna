import 'package:brasil_fields/brasil_fields.dart';

/// Extensões para manipulação e formatação de números ([num], [double], [int])
/// utilizando o padrão brasileiro via [UtilBrasilFields].
extension NumPercentExtension on num {
  /// Retorna o número formatado como texto no padrão brasileiro (vírgula como decimal).
  /// Se for um número inteiro (ex: 30.0), retorna '30'.
  /// Se tiver casas decimais, utiliza [UtilBrasilFields.obterReal] sem o prefixo de moeda.
  ///
  /// Exemplos:
  /// - `30.0.toCleanString()` -> `'30'`
  /// - `35.5.toCleanString()` -> `'35,50'`
  /// - `35.5.toCleanString(fractionDigits: 1)` -> `'35,5'`
  String toCleanString({int fractionDigits = 2}) {
    if (this % 1 == 0) {
      return toInt().toString();
    }
    return UtilBrasilFields.obterReal(
      toDouble(),
      moeda: false,
      decimal: fractionDigits,
    );
  }

  /// Retorna o percentual formatado com o símbolo '%' no padrão brasileiro.
  ///
  /// Exemplos:
  /// - `30.0.toPercentFormatted()` -> `'30%'`
  /// - `35.5.toPercentFormatted()` -> `'35,50%'`
  /// - `35.5.toPercentFormatted(fractionDigits: 1)` -> `'35,5%'`
  String toPercentFormatted({int fractionDigits = 2}) {
    if (this % 1 == 0) {
      return '${toInt()}%';
    }
    return '${toCleanString(fractionDigits: fractionDigits)}%';
  }
}
