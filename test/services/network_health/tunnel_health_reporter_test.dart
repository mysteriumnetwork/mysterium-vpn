import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_report_queue.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_reporter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import '../../support/test_prefs.dart';
import 'tunnel_health_reporter_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Connection>()])
void main() {
  late MockConnection api;
  late TunnelHealthReportQueue queue;
  final now = DateTime.utc(2026, 10, 15, 12);

  setUp(() async {
    api = MockConnection();
    queue = TunnelHealthReportQueue(await initTestPrefs(), Talker());
    when(
      api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
    ).thenAnswer((_) async => Response(requestOptions: RequestOptions(), statusCode: 200));
  });

  RestTunnelHealthReporter build({
    String publicKey = 'pubkey-1',
    String deviceId = 'device-1',
    String originCountry = 'lt',
    String internetType = 'wifi',
    Future<String> Function()? publicKeyOverride,
    Future<String> Function()? internetTypeOverride,
  }) => RestTunnelHealthReporter(
    api: api,
    logger: Talker(),
    queue: queue,
    clock: () => now,
    publicKey: publicKeyOverride ?? () async => publicKey,
    deviceId: () => deviceId,
    originCountry: () => originCountry,
    internetType: internetTypeOverride ?? () async => internetType,
    osType: 'macos',
    appVersion: '2.5.0',
  );

  ReportBrokenNodeRequest captureRequest() =>
      verify(
            api.reportBrokenNode(
              reportBrokenNodeRequest: captureAnyNamed('reportBrokenNodeRequest'),
            ),
          ).captured.single
          as ReportBrokenNodeRequest;

  test('assembles the full payload from the session and ambient context', () async {
    await build().report(
      sessionId: 'sess-1',
      hash: 'hash-1',
      destinationCountry: 'de',
      trigger: TunnelHealthTrigger.auto,
    );

    final request = captureRequest();
    expect(request.sessionId, 'sess-1');
    expect(request.hash, 'hash-1');
    expect(request.publicKey, 'pubkey-1');
    expect(request.deviceId, 'device-1');
    expect(request.destinationCountry, 'de');
    expect(request.originCountry, 'lt');
    expect(request.osType, 'macos');
    expect(request.internetType, 'wifi');
    expect(request.appVersion, '2.5.0');
    expect(request.trigger, ReportBrokenNodeRequestTriggerEnum.auto);
  });

  test('maps the user trigger onto the generated enum', () async {
    await build().report(
      sessionId: 'sess-2',
      hash: 'hash-2',
      destinationCountry: 'nl',
      trigger: TunnelHealthTrigger.user,
    );

    expect(captureRequest().trigger, ReportBrokenNodeRequestTriggerEnum.user);
  });

  test('an unavailable public key is sent as empty, not omitted', () async {
    await build(publicKey: '').report(
      sessionId: 'sess-3',
      hash: 'hash-3',
      destinationCountry: 'fr',
      trigger: TunnelHealthTrigger.auto,
    );

    expect(captureRequest().publicKey, '');
  });

  test('a context lookup that throws still sends the report', () async {
    // The caller has already spent this session's one report, so a throw from
    // secure storage or the connectivity channel would lose it outright.
    await build(
      publicKeyOverride: () async => throw Exception('keychain locked'),
      internetTypeOverride: () async => throw Exception('channel died'),
    ).report(
      sessionId: 'sess-ctx',
      hash: 'hash-ctx',
      destinationCountry: 'de',
      trigger: TunnelHealthTrigger.auto,
    );

    final request = captureRequest();
    expect(request.sessionId, 'sess-ctx');
    expect(request.publicKey, '');
    expect(request.internetType, '');
  });

  group('queueing', () {
    Future<void> reportAndSwallow() async {
      try {
        await build().report(
          sessionId: 'sess-q',
          hash: 'hash-q',
          destinationCountry: 'de',
          trigger: TunnelHealthTrigger.auto,
        );
      } on DioException {
        // The store logs it; here we only care what was queued.
      }
    }

    /// The shapes the real interceptor chain produces. ConnectionErrors wraps
    /// transport failures into ApiException before ApiErrors ever sees them, so
    /// a bare DioException never escapes it — a test that throws one certifies
    /// a path production cannot take.
    ApiException transportFailure(int code) => ApiException(
      RequestOptions(),
      'unreachable',
      code: code,
      identifier: 'test',
      endpoint: '/connection/report-broken-node',
      severity: ExceptionSeverity.low,
    );

    test('a transport failure is queued for retry', () async {
      // The report travels through the very tunnel it is reporting, so this is
      // the common case, not an edge one.
      when(
        api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
      ).thenThrow(transportFailure(1));

      await reportAndSwallow();

      expect((await queue.drain(now: now)).single.request.sessionId, 'sess-q');
    });

    test('no connectivity at request time is queued', () async {
      // ConnectionErrorsInterceptor rejects before the request leaves.
      when(
        api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
      ).thenThrow(transportFailure(0));

      await reportAndSwallow();

      expect((await queue.drain(now: now)).single.request.sessionId, 'sess-q');
    });

    test('a timeout is queued, since nothing reached the backend', () async {
      // ApiErrorsInterceptor maps a response-less failure to code 500.
      when(
        api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
      ).thenThrow(transportFailure(500));

      await reportAndSwallow();

      expect((await queue.drain(now: now)).single.request.sessionId, 'sess-q');
    });

    test('a mapped HTTP rejection is not queued, despite carrying no response', () async {
      // ApiErrorsInterceptor drops `response` when it builds ApiException, so a
      // response-only check read every 4xx as a transport failure and queued
      // permanent rejections forever.
      when(
        api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
      ).thenThrow(
        ApiException(
          RequestOptions(),
          'rejected',
          code: 400,
          identifier: 'test',
          endpoint: '/connection/report-broken-node',
          severity: ExceptionSeverity.low,
          // The response is what tells a rejection from a transport failure.
          response: Response<void>(requestOptions: RequestOptions(), statusCode: 400),
        ),
      );

      await reportAndSwallow();

      expect(await queue.drain(now: now), isEmpty);
    });

    test('a rejected request is not queued — retrying would fail the same way', () async {
      when(
        api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
      ).thenThrow(
        DioException.badResponse(
          statusCode: 400,
          requestOptions: RequestOptions(),
          response: Response(requestOptions: RequestOptions(), statusCode: 400),
        ),
      );

      await reportAndSwallow();

      expect(await queue.drain(now: now), isEmpty);
    });

    test('flushPending sends what was queued and clears it', () async {
      await queue.add(
        ReportBrokenNodeRequest(
          sessionId: 'sess-pending',
          hash: 'h',
          publicKey: 'p',
          deviceId: 'd',
          destinationCountry: 'de',
          originCountry: 'lt',
          osType: 'macos',
          internetType: 'wifi',
          appVersion: '1.0.0',
          trigger: ReportBrokenNodeRequestTriggerEnum.auto,
        ),
        now: now,
      );

      await build().flushPending();

      expect(captureRequest().sessionId, 'sess-pending');
      expect(await queue.drain(now: now), isEmpty);
    });
  });

  test('a failing call propagates so the store can log it', () async {
    when(
      api.reportBrokenNode(reportBrokenNodeRequest: anyNamed('reportBrokenNodeRequest')),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    expect(
      () => build().report(
        sessionId: 'sess-4',
        hash: 'hash-4',
        destinationCountry: 'de',
        trigger: TunnelHealthTrigger.auto,
      ),
      throwsA(isA<DioException>()),
    );
  });
}
