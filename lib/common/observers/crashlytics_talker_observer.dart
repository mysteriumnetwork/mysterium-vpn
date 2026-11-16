import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

/// Forwards Talker errors to Crashlytics as **non-fatal** issues.
///
/// Nothing that reaches here is a crash — the app caught it and carried on.
/// Real crashes come from Crashlytics' own handlers, so marking these fatal
/// only buries the crash-free rate under expected failures.
class CrashlyticsLoggerObserver extends TalkerObserver {
  CrashlyticsLoggerObserver({required this.analyticsStore});

  final AnalyticsStore analyticsStore;

  final ErrorReportThrottle _throttle = ErrorReportThrottle();

  @override
  void onLog(TalkerData log) {
    final message = log.message;
    if (message == null || message.isEmpty) {
      return;
    }
    // Cheaper than generateTextMessage(), which renders ANSI and the whole
    // stack trace on the main thread — but still carries the cause, which
    // logger.warning(msg, error, stack) puts in `exception`/`error`.
    final cause = log.exception ?? log.error;
    analyticsStore.logMessage(cause == null ? message : '$message: $cause');
  }

  // TalkerError populates `error`, TalkerException populates `exception`.
  @override
  Future<void> onError(TalkerError err) async => _report(err.error, err.stackTrace);

  @override
  Future<void> onException(TalkerException err) async =>
      _report(err.exception, err.stackTrace, reason: err.exception.toString());

  Future<void> _report(Object? error, StackTrace? stack, {String? reason}) async {
    // Counts first: the throttle collapses repeats, which would distort them.
    trackErrorEvent(error);
    // Filter before the throttle, or non-actionable errors evict real ones.
    if (isNonActionable(error) || !_throttle.allow(error)) {
      return;
    }
    // A throwing reporter inside an error handler becomes an unhandled async
    // error — the very thing this observer exists to record.
    try {
      await analyticsStore.logError(
        err: error ?? Exception('Unknown error'),
        stack: stack,
        reason: reason,
      );
    } catch (_) {}
  }

  void trackErrorEvent(Object? apiError) {
    if (apiError is ApiException) {
      analyticsStore.logEvent(
        AnalyticsEvent.apiError,
        parameters: {
          'message': apiError.message,
          'status_code': apiError.code,
          'error_code': ?apiError.errorCode,
          'endpoint': apiError.endpoint,
          'method': apiError.requestOptions.method,
          'error_type': 'api_exception',
        },
      );
    }
  }
}
