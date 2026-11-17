import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/interceptors/api_errors.dart';
import 'package:mysterium_vpn/common/interceptors/connection_errors.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';
import 'package:mysterium_vpn/common/interceptors/transport_errors.dart';

import '../../support/fake_connectivity.dart';

/// Fails the first [failures] attempts the way a reaped keep-alive socket does:
/// the request is already sent, so `dart:io` reports a bare [HttpException].
class _AbortingAdapter implements HttpClientAdapter {
  _AbortingAdapter({this.failures = 1});

  final int failures;
  int attempts = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    attempts++;
    if (attempts <= failures) {
      throw const HttpException('Software caused connection abort');
    }
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late TransportErrorsInterceptor interceptor;

  setUp(() {
    installFakeConnectivity();
    interceptor = TransportErrorsInterceptor();
  });

  DioException run(DioException err) {
    DioException? forwarded;
    interceptor.onError(err, _CapturingHandler((e) => forwarded = e));
    return forwarded!;
  }

  DioException unknown(Object error, {CancelToken? cancelToken}) => DioException(
    requestOptions: RequestOptions(path: '/subscription', cancelToken: cancelToken),
    error: error,
  );

  group('onError', () {
    test('re-types a post-send abort as a connection error', () {
      const abort = HttpException('Software caused connection abort');
      final result = run(unknown(abort));

      expect(result.type, DioExceptionType.connectionError);
      expect(result.error, same(abort), reason: 'the cause must survive for logging');
      expect(result.message, contains('Software caused connection abort'));
      expect(result.requestOptions.path, '/subscription');
    });

    test('re-types a truncated response too', () {
      final result = run(unknown(const HttpException('Connection closed while receiving data')));

      expect(result.type, DioExceptionType.connectionError);
    });

    test('leaves an unknown wrapping something else alone', () {
      final err = unknown(const FormatException('bad json'));

      expect(run(err), same(err));
    });

    test('leaves an already classified failure alone', () {
      for (final type in [
        DioExceptionType.connectionError,
        DioExceptionType.badResponse,
        DioExceptionType.receiveTimeout,
        DioExceptionType.cancel,
      ]) {
        final err = DioException(
          requestOptions: RequestOptions(path: '/subscription'),
          type: type,
          error: const HttpException('Software caused connection abort'),
        );

        expect(run(err), same(err), reason: '$type must pass through');
      }
    });

    test('never re-types a cancelled request', () {
      final token = CancelToken()..cancel();
      final err = unknown(const HttpException('Request has been aborted'), cancelToken: token);

      expect(run(err), same(err));
    });
  });

  group('in the interceptor chain', () {
    Dio chainedDio(_AbortingAdapter adapter) {
      final dio = Dio()..httpClientAdapter = adapter;
      dio.interceptors.addAll([
        TransportErrorsInterceptor(),
        RetryRequestInterceptor(dio: dio, retryDelays: const []),
        ConnectionErrorsInterceptor(),
        ApiErrorsInterceptor(),
      ]);
      return dio;
    }

    test('retries the abort instead of surfacing it', () async {
      final adapter = _AbortingAdapter();
      final response = await chainedDio(adapter).get<dynamic>('/subscription');

      expect(adapter.attempts, 2);
      expect(response.statusCode, 200);
    });

    test('reports a persistent abort as a connection failure, not a 500', () async {
      final adapter = _AbortingAdapter(failures: 99);

      await expectLater(
        chainedDio(adapter).get<dynamic>('/subscription'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 1)
              .having((e) => e.severity, 'severity', ExceptionSeverity.low),
        ),
      );
      expect(adapter.attempts, 4, reason: 'the original attempt plus three retries');
    });

    test('does not replay a non-idempotent request', () async {
      final adapter = _AbortingAdapter(failures: 99);

      await expectLater(
        chainedDio(adapter).post<dynamic>('/subscription'),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 1)),
      );
      expect(adapter.attempts, 1);
    });
  });
}

class _CapturingHandler extends ErrorInterceptorHandler {
  _CapturingHandler(this.onNext);

  final void Function(DioException) onNext;

  @override
  void next(DioException err) => onNext(err);

  @override
  void reject(DioException err) => onNext(err);
}
