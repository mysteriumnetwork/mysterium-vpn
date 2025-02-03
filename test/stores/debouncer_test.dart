import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';

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
      bool executed = false;
      debouncer.debounce(() {
        executed = true;
      }, Duration(milliseconds: 100));

      await Future.delayed(Duration(milliseconds: 150));
      expect(executed, true);
    });

    test('cancels previous timer if called again within duration', () async {
      bool executed = false;
      debouncer.debounce(() {
        executed = true;
      }, Duration(milliseconds: 100));

      debouncer.debounce(() {
        executed = true;
      }, Duration(milliseconds: 100));

      await Future.delayed(Duration(milliseconds: 150));
      expect(executed, true);
    });

    test('does not execute function if cancelled before duration', () async {
      bool executed = false;
      debouncer.debounce(() {
        executed = true;
      }, Duration(milliseconds: 100));

      debouncer.dispose();

      await Future.delayed(Duration(milliseconds: 150));
      expect(executed, false);
    });
  });
}
