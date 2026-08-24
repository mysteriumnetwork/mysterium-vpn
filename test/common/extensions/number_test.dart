import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

void main() {
  group('PausePeriodCodeExtensions.monthsFromPausePeriodCode', () {
    test('parses month codes', () {
      expect('1'.numeric, 1);
      expect('1m'.numeric, 1);
      expect('1mo'.numeric, 1);
      expect('12m'.numeric, 12);
      expect(' 3mo '.numeric, 3);
    });

    test('returns null for unknown formats', () {
      expect(''.numeric, isNull);
      expect('3d'.numeric, isNull);
      expect('m3'.numeric, isNull);
    });
  });
}
