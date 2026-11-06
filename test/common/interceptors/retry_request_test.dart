import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';

void main() {
  late RetryRequestInterceptor interceptor;

  setUp(() {
    interceptor = RetryRequestInterceptor(dio: Dio());
  });

  DioException error(String method, {DioExceptionType type = DioExceptionType.connectionError}) =>
      DioException(
        requestOptions: RequestOptions(path: '/connection/connect', method: method),
        type: type,
      );

  group('evaluate', () {
    test('retries an idempotent request that lost its connection', () {
      expect(interceptor.evaluate(error('GET'), 1), isTrue);
    });

    test('retries an idempotent request that timed out', () {
      expect(interceptor.evaluate(error('HEAD', type: DioExceptionType.receiveTimeout), 1), isTrue);
    });

    test('never replays a non-idempotent request', () {
      for (final method in ['POST', 'PUT', 'PATCH', 'DELETE', 'post']) {
        expect(
          interceptor.evaluate(error(method), 1),
          isFalse,
          reason: '$method must not be replayed',
        );
      }
    });

    test('never replays a non-idempotent request on a retryable status either', () {
      final gatewayTimeout = DioException(
        requestOptions: RequestOptions(path: '/subscription/cancel', method: 'POST'),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/subscription/cancel', method: 'POST'),
          statusCode: 504,
        ),
      );

      expect(interceptor.evaluate(gatewayTimeout, 1), isFalse);
    });

    test('leaves non-transport failures alone', () {
      expect(interceptor.evaluate(error('GET', type: DioExceptionType.cancel), 1), isFalse);
    });
  });
}
