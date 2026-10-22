import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:vpn_api/vpn_api.dart';

/// Answers however the test tells it to, and records what it was sent.
class _FakeConnection extends Fake implements Connection {
  _FakeConnection({this.throws, this.delay});

  final Object? throws;
  final Duration? delay;
  Map<String, dynamic>? sentExtra;
  int? sentDuration;

  @override
  Future<Response<TestTrafficConditionResponse>> testTrafficDrop({
    TestTrafficDropRequest? testTrafficDropRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    sentExtra = extra;
    sentDuration = testTrafficDropRequest?.durationSeconds;
    if (delay != null) {
      await Future<void>.delayed(delay!);
    }
    final failure = throws;
    if (failure != null) {
      // ignore: only_throw_errors
      throw failure;
    }
    return Response(
      requestOptions: RequestOptions(),
      data: TestTrafficConditionResponse(durationSeconds: 60),
    );
  }
}

ApiException _rejected(int code) => ApiException(
  RequestOptions(),
  'nope',
  code: code,
  identifier: 'test',
  endpoint: '/connection/test-traffic/drop',
  severity: ExceptionSeverity.low,
);

void main() {
  test('a reply means confirmed', () async {
    final service = TestTrafficService(_FakeConnection());

    expect(await service.drop(durationSeconds: 60), TestTrafficOutcome.confirmed);
  });

  test('disables retries, because delivery is the side effect', () async {
    final connection = _FakeConnection();
    await TestTrafficService(connection).drop(durationSeconds: 60);

    expect(connection.sentExtra, kNoRetryExtra);
  });

  test('a silent request is unconfirmed rather than an error', () async {
    // The drop kills the tunnel its own answer would return through.
    final service = TestTrafficService(_FakeConnection(delay: const Duration(seconds: 30)));

    expect(await service.drop(durationSeconds: 60), TestTrafficOutcome.unconfirmed);
  });

  test('a transport failure with no response is unconfirmed', () async {
    final service = TestTrafficService(
      _FakeConnection(throws: DioException(requestOptions: RequestOptions())),
    );

    expect(await service.drop(durationSeconds: 60), TestTrafficOutcome.unconfirmed);
  });

  test('a rejection is reported, never passed off as applied', () async {
    // Regression guard. ApiErrorsInterceptor drops `response` and carries the
    // status in `code`, so a response-only check read every rejection as
    // silence and told the tester their condition had been applied.
    final service = TestTrafficService(_FakeConnection(throws: _rejected(400)));

    await expectLater(service.drop(durationSeconds: 60), throwsA(isA<ApiException>()));
  });

  group('describeTestTrafficError', () {
    test('tells a missing deployment apart from an upstream failure', () {
      expect(describeTestTrafficError(_rejected(404)), contains('TEST_TRAFFIC_TOKEN'));
      expect(describeTestTrafficError(_rejected(502)), contains('upstream'));
    });

    test('falls back to the shared resolver for anything else', () {
      expect(describeTestTrafficError(Exception('boom')), contains('boom'));
    });
  });
}
