import 'dart:io';

import 'package:dio/dio.dart';

const _blockingTypes = {
  DioExceptionType.connectionTimeout,
  DioExceptionType.connectionError,
  DioExceptionType.badCertificate,
};

const _timeoutTypes = {DioExceptionType.sendTimeout, DioExceptionType.receiveTimeout};

/// Interference rather than a weak link. Every case fails before the request
/// is sent, so it is also safe to replay.
bool blockedByTransport(DioException error) =>
    _blockingTypes.contains(error.type) || _tlsHandshake(error.error);

/// Worth another domain: a block, or a timeout that proves nothing.
bool retryableTransport(DioException error) =>
    blockedByTransport(error) || _timeoutTypes.contains(error.type);

// dio leaves these unmapped, so they arrive as the wrapped error.
bool _tlsHandshake(Object? error) => error is HandshakeException || error is CertificateException;

bool _json(Headers headers) =>
    headers[Headers.contentTypeHeader]?.join(',').toLowerCase().contains(Headers.jsonContentType) ??
    false;

/// A censor, not our backend: `451`, or a `403` that is not our JSON.
bool blockedByResponse(int status, Headers headers) =>
    status == 451 || (status == 403 && !_json(headers));

/// Our own edge failing: worth another domain, but not evidence of a block.
bool unavailableResponse(int status, Headers headers) => status >= 500 && !_json(headers);

String responseLabel(int status) => switch (status) {
  451 => 'http_451',
  403 => 'http_403',
  >= 500 => 'http_5xx',
  _ => 'http_$status',
};

String transportLabel(DioException error) => switch (error.type) {
  _ when _tlsHandshake(error.error) => 'tls_handshake',
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => 'timeout',
  DioExceptionType.connectionError => 'connection_error',
  DioExceptionType.badCertificate => 'bad_certificate',
  _ => error.type.name,
};
