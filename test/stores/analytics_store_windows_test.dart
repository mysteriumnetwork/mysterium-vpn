import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_windows.dart';

class _CapturingAdapter implements HttpClientAdapter {
  final List<String> bodies = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    bodies.add(options.data as String);
    return ResponseBody.fromString('{"validationMessages":[]}', 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AnalyticsSession session;
  late _CapturingAdapter adapter;

  void useSession({Duration timeout = const Duration(minutes: 30)}) {
    session = AnalyticsSession(
      'G-TEST',
      'secret',
      Future.value('device-abc'),
      sessionTimeout: timeout,
    );
    adapter = _CapturingAdapter();
    session.dio.httpClientAdapter = adapter;
  }

  setUp(useSession);

  Future<Map<String, dynamic>> sendAndDecode() async {
    await session.logEvent('app_launch');
    return jsonDecode(adapter.bodies.single) as Map<String, dynamic>;
  }

  Map<String, dynamic> paramsOf(String body) {
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final event = (decoded['events'] as List<dynamic>).single as Map<String, dynamic>;
    return event['params'] as Map<String, dynamic>;
  }

  List<int> reportedEngagement() =>
      adapter.bodies.map((body) => paramsOf(body)['engagement_time_msec'] as int).toList();

  group('AnalyticsSession', () {
    test('session id is unix seconds so GA4 can store it as an int64', () {
      expect(int.tryParse(session.sessionId), isNotNull);

      final nowSeconds = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(int.parse(session.sessionId), closeTo(nowSeconds, 2));
    });

    test('session id is not a date string GA4 would truncate to its leading digits', () {
      expect(session.sessionId, isNot(contains('-')));
      expect(session.sessionId, isNot(contains('T')));
    });

    test('sends the device id as client_id, not the platform name', () async {
      final body = await sendAndDecode();

      expect(body['client_id'], 'device-abc');
    });

    test('sends the numeric session id with the event', () async {
      final body = await sendAndDecode();

      final params = (body['events'] as List<dynamic>).single as Map<String, dynamic>;
      final sessionId = (params['params'] as Map<String, dynamic>)['session_id'];
      expect(int.tryParse(sessionId as String), isNotNull);
    });

    test('engagement time sums to wall clock rather than re-reporting from launch', () async {
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < 3; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await session.logEvent('app_launch');
      }
      stopwatch.stop();

      final reported = reportedEngagement();
      expect(reported, hasLength(3));
      // Deltas sum to elapsed time; cumulative values would sum to roughly double.
      expect(
        reported.reduce((a, b) => a + b),
        lessThanOrEqualTo(stopwatch.elapsedMilliseconds + 50),
      );
    });

    test('a later event does not re-report time already attributed to an earlier one', () async {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await session.logEvent('app_launch');
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await session.logEvent('app_launch');

      final reported = reportedEngagement();
      expect(reported.first, greaterThanOrEqualTo(100));
      expect(reported.last, lessThan(reported.first + 100));
    });

    // Session ids are unix seconds, so a timeout under a second cannot produce a
    // distinct id. The real 30-minute timeout is always well clear of that.
    const shortTimeout = Duration(seconds: 1);
    const pastTimeout = Duration(milliseconds: 1100);

    test('keeps one session id while events keep arriving inside the timeout', () async {
      await session.logEvent('app_launch');
      final first = session.sessionId;

      await Future<void>.delayed(pastTimeout);
      await session.logEvent('app_launch');

      expect(session.sessionId, first);
    });

    test('starts a new numeric session id once the idle timeout passes', () async {
      useSession(timeout: shortTimeout);
      await session.logEvent('app_launch');
      final first = session.sessionId;

      await Future<void>.delayed(pastTimeout);
      await session.logEvent('app_launch');

      expect(session.sessionId, isNot(first));
      expect(int.tryParse(session.sessionId), isNotNull);
    });

    test('a rolled-over session does not bill the idle gap as engagement', () async {
      useSession(timeout: shortTimeout);
      await session.logEvent('app_launch');

      await Future<void>.delayed(pastTimeout);
      await session.logEvent('app_launch');

      expect(reportedEngagement().last, 0);
    });
  });
}
