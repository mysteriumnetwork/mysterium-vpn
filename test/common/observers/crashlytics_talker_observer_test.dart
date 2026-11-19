import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
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

  VerificationResult verifyReports() => verify(
    analyticsStore.logError(
      err: anyNamed('err'),
      stack: anyNamed('stack'),
      reason: anyNamed('reason'),
    ),
  );

  test('an expired session is handled, not reported as a crash', () async {
    await observer.onException(TalkerException(RefreshTokenNotFoundException()));

    verifyZeroInteractions(analyticsStore);
  });

  test('unexpected exceptions are reported, and never as a crash', () async {
    await observer.onException(TalkerException(Exception('boom')));

    verifyReports().called(1);
    verifyNever(
      analyticsStore.logError(
        err: anyNamed('err'),
        stack: anyNamed('stack'),
        reason: anyNamed('reason'),
        fatal: true,
      ),
    );
  });

  group('repeat suppression', () {
    test('a looping failure is reported once, not once per occurrence', () async {
      for (var i = 0; i < 20; i++) {
        await observer.onException(TalkerException(Exception('boom')));
      }

      verifyReports().called(1);
    });

    test('analytics events are not throttled, so error counts stay accurate', () async {
      final apiError = ApiException(
        RequestOptions(),
        'boom',
        code: 500,
        identifier: 'id',
        endpoint: '/a',
        severity: ExceptionSeverity.medium,
      );

      await observer.onException(TalkerException(apiError));
      await observer.onException(TalkerException(apiError));

      verify(analyticsStore.logEvent(any, parameters: anyNamed('parameters'))).called(2);
    });

    test('distinct failures are each reported', () async {
      await observer.onException(TalkerException(Exception('boom')));
      await observer.onException(TalkerException(Exception('different')));

      verifyReports().called(2);
    });

    test('errors and exceptions are suppressed on the same path', () async {
      await observer.onError(TalkerError(StateError('boom')));
      await observer.onError(TalkerError(StateError('boom')));

      verifyReports().called(1);
    });
  });

  group('breadcrumbs', () {
    test('forwards the raw message without formatting it', () {
      observer.onLog(TalkerLog('MQTT reconnecting..'));

      verify(analyticsStore.logMessage('MQTT reconnecting..')).called(1);
    });

    // logger.warning(msg, error, stack) is now the house style for expected
    // failures, so the breadcrumb has to carry the cause or it says nothing.
    test('keeps the cause when a warning carries one', () {
      observer.onLog(TalkerLog('MQTT connect failed', exception: Exception('refused')));

      verify(analyticsStore.logMessage('MQTT connect failed: Exception: refused')).called(1);
    });

    test('skips logs that carry no message', () {
      observer.onLog(TalkerLog(''));

      verifyNever(analyticsStore.logMessage(any));
    });
  });
}
