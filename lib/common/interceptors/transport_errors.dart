import 'dart:io';

import 'package:dio/dio.dart';

/// Re-types a post-send transport failure as a [DioExceptionType.connectionError].
///
/// `dart:io` flattens a [SocketException] that lands while the response is
/// awaited into a bare [HttpException], dropping the type and the errno
/// (`_http/http_impl.dart`). dio's adapter only recognises [SocketException],
/// so what survives is an `unknown` that the retries skip and the connection
/// mapping misses — it reaches the caller as a phantom 500. Typical source is a
/// pooled keep-alive socket the OS reaped while the app was backgrounded.
///
/// Must sit ahead of `RetryRequestInterceptor`, which is why
/// `ConnectionErrorsInterceptor` cannot do this itself: it rejects, ending the
/// chain before the retries run.
class TransportErrorsInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = err.error;
    final cancelled = err.requestOptions.cancelToken?.isCancelled ?? false;
    if (cancelled || err.type != DioExceptionType.unknown || error is! HttpException) {
      return handler.next(err);
    }

    return handler.next(
      DioException.connectionError(
        requestOptions: err.requestOptions,
        reason: error.message,
        error: error,
      ),
    );
  }
}
