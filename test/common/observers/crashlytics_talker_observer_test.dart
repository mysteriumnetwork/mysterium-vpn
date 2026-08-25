import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'crashlytics_talker_observer_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnalyticsStore>()])
void main() {
  late MockAnalyticsStore analyticsStore;
  late CrashlyticsLoggerObserver observer;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    observer = CrashlyticsLoggerObserver(analyticsStore: analyticsStore);
  });

  test('an expired session is handled, not reported as a crash', () async {
    await observer.onException(TalkerException(RefreshTokenNotFoundException()));

    verifyZeroInteractions(analyticsStore);
  });

  test('unexpected exceptions are still reported as fatal', () async {
    await observer.onException(TalkerException(Exception('boom')));

    verify(
      analyticsStore.logError(
        err: anyNamed('err'),
        stack: anyNamed('stack'),
        reason: anyNamed('reason'),
        fatal: true,
      ),
    ).called(1);
  });
}
