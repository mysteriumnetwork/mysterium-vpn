import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';
import 'package:mysterium_vpn/services/discovery/domain_discovery.dart';
import 'package:talker/talker.dart';

class DiscoveryAdapter implements HttpClientAdapter {
  DiscoveryAdapter(this._inner, this._discovery, {Talker? logger}) : _logger = logger;

  final HttpClientAdapter _inner;
  final DomainDiscovery _discovery;
  final Talker? _logger;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final original = options.uri;
    if (!_discovery.supports(original)) {
      return _inner.fetch(options, requestStream, cancelFuture);
    }
    final tried = <String>{};

    var refreshed = false;
    var consumed = false;
    var cancelled = false;
    unawaited(
      cancelFuture?.then((_) {
        cancelled = true;
      }),
    );
    var candidates = await _discovery.cachedCandidates(original);
    final safeMethod = {'GET', 'HEAD', 'OPTIONS'}.contains(options.method.toUpperCase());
    while (true) {
      if (cancelled || (options.cancelToken?.isCancelled ?? false)) {
        throw DioException.requestCancelled(requestOptions: options, reason: 'Cancelled');
      }
      final candidate = candidates.removeAt(0);
      tried.add(candidate.host);
      final isFallback = candidate.host != original.host;
      if (isFallback) {
        _logger?.info(
          '[discovery] API ${options.method} fallback attempt: '
          '${original.origin} -> ${candidate.origin} '
          '(${tried.length == 1 ? 'cached selection' : 'retry'})',
        );
      }
      final headers = Map<String, dynamic>.of(options.headers)
        ..removeWhere((key, _) => key.toLowerCase() == 'host');
      final attempt = options.copyWith(
        path: candidate.toString(),
        baseUrl: '',
        queryParameters: {},
        headers: headers,
      );
      Stream<Uint8List> trackedBody() async* {
        consumed = true;
        yield* requestStream!;
      }

      final body = requestStream == null ? null : trackedBody();
      ResponseBody? response;
      DioException? failure;
      try {
        response = await _inner.fetch(attempt, body, cancelFuture);
        if (cancelled || (options.cancelToken?.isCancelled ?? false)) {
          await response.stream.listen(null).cancel();
          throw DioException.requestCancelled(requestOptions: options, reason: 'Cancelled');
        }
        await _bufferResponse(response, attempt);
        if (!_unavailable(response.statusCode)) {
          if (isFallback) {
            _logger?.info(
              '[discovery] API ${options.method} fallback response: '
              '${original.origin} -> ${candidate.origin} (HTTP ${response.statusCode})',
            );
          }
          await _discovery.record(original, candidate, success: true);
          return response;
        }
      } on DioException catch (error) {
        if (cancelled ||
            error.type == DioExceptionType.cancel ||
            (options.cancelToken?.isCancelled ?? false) ||
            !_transportFailure(error)) {
          rethrow;
        }
        failure = error;
        response = null;
      } on IOException catch (error, stack) {
        if (cancelled || (options.cancelToken?.isCancelled ?? false)) {
          rethrow;
        }
        failure = DioException(requestOptions: options, error: error, stackTrace: stack);
        response = null;
      }
      final reason = response != null
          ? 'HTTP ${response.statusCode}'
          : failure!.type == DioExceptionType.unknown
          ? failure.error.runtimeType.toString()
          : failure.type.name;
      _logger?.warning(
        '[discovery] API ${options.method} endpoint failed: ${candidate.origin} ($reason)',
      );
      await _discovery.record(original, candidate, success: false);
      final beforeSend =
          failure != null &&
          {
            DioExceptionType.connectionTimeout,
            DioExceptionType.connectionError,
            DioExceptionType.badCertificate,
          }.contains(failure.type);
      // Preserve no-retry and consumed-body semantics for requests with side effects.
      final canReplay =
          !cancelled &&
          !(options.cancelToken?.isCancelled ?? false) &&
          !options.disableRetry &&
          !consumed &&
          (safeMethod || beforeSend);
      if (canReplay) {
        if (!refreshed) {
          candidates = await _discovery.candidatesAfterFailure(original);
          refreshed = true;
        }
        candidates.removeWhere((uri) => tried.contains(uri.host));
      }
      if (!canReplay ||
          cancelled ||
          (options.cancelToken?.isCancelled ?? false) ||
          candidates.isEmpty) {
        _logger?.warning(
          '[discovery] API ${options.method} failover stopped for ${original.origin}: '
          '${!canReplay ? 'request cannot be replayed safely' : 'no untried fallback domains'}',
        );
        if (response != null) {
          return response;
        }
        throw failure!;
      }
      if (response != null) {
        await response.stream.listen(null).cancel();
      }
    }
  }

  Future<void> _bufferResponse(ResponseBody response, RequestOptions options) async {
    if (options.responseType == ResponseType.stream) {
      return;
    }
    final timeout = options.receiveTimeout;
    final stream = timeout != null && timeout > Duration.zero
        ? response.stream.timeout(timeout)
        : response.stream;
    try {
      final chunks = await stream.toList();
      response.stream = Stream.fromIterable(chunks);
    } on TimeoutException {
      throw DioException.receiveTimeout(requestOptions: options, timeout: timeout!);
    }
  }

  bool _unavailable(int status) => status >= 500 || status == 403 || status == 451;

  bool _transportFailure(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.connectionError ||
    DioExceptionType.badCertificate ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => true,
    _ => false,
  };

  @override
  void close({bool force = false}) => _inner.close(force: force);
}
