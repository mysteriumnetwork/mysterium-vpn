import 'dart:async';

import 'package:dio/dio.dart';

typedef RetryEvaluator = FutureOr<bool> Function(DioException error, int attempt);

/// An interceptor that will try to send failed request again
class RetryRequestInterceptor extends Interceptor {
  RetryRequestInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelays = const [Duration(seconds: 1), Duration(seconds: 3), Duration(seconds: 5)],
    this.ignoreRetryEvaluatorExceptions = false,
  });

  final Dio dio;
  final int retries;
  final bool ignoreRetryEvaluatorExceptions;
  final List<Duration> retryDelays;

  Future<bool> _shouldRetry(DioException error, int attempt) async {
    try {
      return evaluate(error, attempt);
    } catch (e) {
      if (!ignoreRetryEvaluatorExceptions) {
        rethrow;
      }
    }
    return true;
  }

  @override
  Future<dynamic> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.disableRetry) {
      return super.onError(err, handler);
    }
    bool isRequestCancelled() => err.requestOptions.cancelToken?.isCancelled ?? false;

    final attempt = err.requestOptions._attempt + 1;
    final shouldRetry = attempt <= retries && await _shouldRetry(err, attempt);

    if (!shouldRetry) {
      return super.onError(err, handler);
    }

    err.requestOptions._attempt = attempt;
    final delay = _getDelay(attempt);

    final requestOptions = err.requestOptions;

    if (delay != Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (isRequestCancelled()) {
      return super.onError(err, handler);
    }

    try {
      await dio.fetch<void>(requestOptions).then((value) => handler.resolve(value));
    } on DioException catch (e) {
      super.onError(e, handler);
    }
  }

  Duration _getDelay(int attempt) {
    if (retryDelays.isEmpty) {
      return Duration.zero;
    }
    return attempt - 1 < retryDelays.length ? retryDelays[attempt - 1] : retryDelays.last;
  }

  bool evaluate(DioException error, int attempt) {
    var shouldRetry = false;
    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        shouldRetry = _retryableStatuses.contains(statusCode);
      }
    } else {
      shouldRetry = _retryableErrorTypes.contains(error.type);
    }
    return shouldRetry;
  }
}

const _kDisableRetryKey = 'ro_disable_retry';

extension RequestOptionsX on RequestOptions {
  static const _kAttemptKey = 'ro_attempt';

  int get attempt => _attempt;

  bool get disableRetry => (extra[_kDisableRetryKey] as bool?) ?? false;

  set disableRetry(bool value) => extra[_kDisableRetryKey] = value;

  int get _attempt => (extra[_kAttemptKey] as int?) ?? 0;

  set _attempt(int value) => extra[_kAttemptKey] = value;
}

extension OptionsX on Options {
  bool get disableRetry => (extra?[_kDisableRetryKey] as bool?) ?? false;

  set disableRetry(bool value) {
    extra = Map.of(extra ??= <String, dynamic>{});
    extra![_kDisableRetryKey] = value;
  }
}

const _retryableErrorTypes = [
  DioExceptionType.connectionError,
  DioExceptionType.sendTimeout,
  DioExceptionType.receiveTimeout,
  DioExceptionType.connectionTimeout,
];

const _retryableStatuses = <int>{
  504, //GatewayTimeout,
  598, //NetworkReadTimeoutError,
  599, //NetworkConnectTimeoutError,
  521, //WebServerIsDown,
  522, //ConnectionTimedOut,
  523, //OriginIsUnreachable
  524, //TimeoutOccurred,
  525, //SSLHandshakeFailed,
};
