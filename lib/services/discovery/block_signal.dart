import 'package:dio/dio.dart';

/// Transport failures that look like interference rather than a weak
/// connection. A send or receive timeout means bytes were already moving, so
/// it is worth another domain but is not evidence of a block.
const blockingTransport = {
  DioExceptionType.connectionTimeout,
  DioExceptionType.connectionError,
  DioExceptionType.badCertificate,
};

/// Everything worth trying another domain for: the blocking set plus the
/// timeouts. Kept derived so the two can never drift apart silently.
const retryableTransport = {
  ...blockingTransport,
  DioExceptionType.sendTimeout,
  DioExceptionType.receiveTimeout,
};

/// Whether an HTTP answer is a censor rather than our own backend.
///
/// `451` says so outright. `403` and `5xx` are ambiguous — the Notifier returns
/// `403` for ordinary auth failures — so they only count when the body is not
/// the JSON our API always answers with. A missing content type counts as a
/// block, since our backend never omits it.
bool blockedByResponse(int status, Headers headers) {
  if (status == 451) {
    return true;
  }
  if (status != 403 && status < 500) {
    return false;
  }
  final contentType = headers[Headers.contentTypeHeader]?.join(',').toLowerCase();
  return contentType == null || !contentType.contains(Headers.jsonContentType);
}

/// Coarse analytics label for a failed response. Never an exception message.
String responseLabel(int status) => switch (status) {
  451 => 'http_451',
  403 => 'http_403',
  >= 500 => 'http_5xx',
  _ => 'http_$status',
};

/// Coarse analytics label for a transport failure.
String transportLabel(DioExceptionType type) => switch (type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => 'timeout',
  DioExceptionType.connectionError => 'connection_error',
  DioExceptionType.badCertificate => 'bad_certificate',
  _ => type.name,
};
