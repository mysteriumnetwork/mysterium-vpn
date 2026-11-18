import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

void main() {
  test('a repeat inside the window is held back', () {
    final throttle = ErrorReportThrottle();

    expect(throttle.allow(Exception('boom')), isTrue);
    expect(throttle.allow(Exception('boom')), isFalse);
  });

  test('distinct errors are independent', () {
    final throttle = ErrorReportThrottle();

    expect(throttle.allow(Exception('boom')), isTrue);
    expect(throttle.allow(Exception('different')), isTrue);
  });

  test('an elapsed window lets the error through again', () {
    final throttle = ErrorReportThrottle(window: Duration.zero);

    expect(throttle.allow(Exception('boom')), isTrue);
    expect(throttle.allow(Exception('boom')), isTrue);
  });

  test('tracked errors stay bounded', () {
    final throttle = ErrorReportThrottle(maxTrackedErrors: 4);

    for (var i = 0; i < 100; i++) {
      throttle.allow(Exception('boom $i'));
    }

    expect(throttle.allow(Exception('boom 99')), isFalse);
  });

  // Eviction is by least-recently-reported. Without re-insertion on update the
  // hot, repeatedly-suppressed error keeps the oldest slot and is evicted
  // first — dropping exactly the entry the throttle exists to hold back.
  test('a hot error survives eviction by other errors', () {
    final throttle = ErrorReportThrottle(maxTrackedErrors: 4);
    final hot = Exception('hot');

    expect(throttle.allow(hot), isTrue);
    for (var i = 0; i < 20; i++) {
      throttle.allow(Exception('cold $i'));
      expect(throttle.allow(hot), isFalse, reason: 'the hot error must stay suppressed');
    }
  });
}
