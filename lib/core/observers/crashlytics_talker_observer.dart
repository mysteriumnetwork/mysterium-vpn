import 'dart:async';

import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

class CrashlitycsLoggerObserver extends TalkerObserver {
  const CrashlitycsLoggerObserver({required this.analyticsStore});

  final AnalyticsStore analyticsStore;

  @override
  void onLog(TalkerData log) {
    analyticsStore.logMessage(log.generateTextMessage());
  }

  @override
  Future<void> onError(TalkerError err) async {
    trackErrorEvent(err.exception);
    if (shouldSkipEvent(err.exception)) {
      return;
    }
    analyticsStore.logError(err: err.error ?? Error(), stack: err.stackTrace, fatal: true);
  }

  @override
  Future<void> onException(TalkerException err) async {
    trackErrorEvent(err.exception);
    if (shouldSkipEvent(err.exception)) {
      return;
    }
    analyticsStore.logError(
      err: err.exception ?? Exception('Unknown exception'),
      stack: err.stackTrace,
      reason: err.exception.toString(),
      fatal: true,
    );
  }

  void trackErrorEvent(Object? apiError) {
    if (apiError is ApiException) {
      analyticsStore.logEvent(
        AnalyticsEvent.apiError,
        parameters: {
          'message': apiError.message,
          'status_code': apiError.code,
          'endpoint': apiError.endpoint,
          'method': apiError.requestOptions.method,
          'error_type': 'api_exception',
        },
      );
    }
  }

  /// Skip some exceptions from being logged to Crashlytics
  bool shouldSkipEvent(Object? exception) {
    if (exception is ApiException ||
        exception is SignInAborted ||
        exception is KeyDoesntExistsException ||
        exception is TimeoutException ||
        exception is OperationCancelledException ||
        exception is SubscriptionRequiredException) {
      return true;
    }
    return false;
  }
}
