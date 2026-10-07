import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';

void main() {
  group('NumPercentExtension with UtilBrasilFields', () {
    test('toCleanString formats integers without decimals', () {
      expect(30.toCleanString(), '30');
      expect(30.0.toCleanString(), '30');
      expect(0.toCleanString(), '0');
      expect(100.0.toCleanString(), '100');
    });

    test('toCleanString formats decimals using comma and brasil_fields', () {
      expect(35.5.toCleanString(), '35,50');
      expect(35.5.toCleanString(fractionDigits: 1), '35,5');
      expect(12.75.toCleanString(), '12,75');
      expect(12.75.toCleanString(fractionDigits: 2), '12,75');
      expect(12.756.toCleanString(fractionDigits: 2), '12,76');
    });

    test('toPercentFormatted formats integers with %', () {
      expect(30.toPercentFormatted(), '30%');
      expect(30.0.toPercentFormatted(), '30%');
      expect(0.toPercentFormatted(), '0%');
      expect(100.0.toPercentFormatted(), '100%');
    });

    test('toPercentFormatted formats decimals with % and comma', () {
      expect(35.5.toPercentFormatted(), '35,50%');
      expect(35.5.toPercentFormatted(fractionDigits: 1), '35,5%');
      expect(12.75.toPercentFormatted(), '12,75%');
      expect(0.5.toPercentFormatted(), '0,50%');
    });
  });
}
