import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

void main() {
  group('Debouncer', () {
    late Debouncer debouncer;

    setUp(() {
      debouncer = Debouncer();
    });

    tearDown(() {
      debouncer.dispose();
    });

    test('executes function after specified duration', () async {
      var executed = false;
      debouncer.debounce(() {
        executed = true;
      }, const Duration(milliseconds: 100));

      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, true);
    });

    test('cancels previous timer if called again within duration', () async {
      var executed = false;
      debouncer
        ..debounce(() {
          executed = true;
        }, const Duration(milliseconds: 100))
        ..debounce(() {
          executed = true;
        }, const Duration(milliseconds: 100));

      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, true);
    });

    test('does not execute function if cancelled before duration', () async {
      var executed = false;
      debouncer
        ..debounce(() {
          executed = true;
        }, const Duration(milliseconds: 100))
        ..dispose();

      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, false);
    });
  });
}
