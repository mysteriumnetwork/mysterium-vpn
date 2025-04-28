import 'dart:async';

import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:talker/talker.dart';

class CrashlitycsLoggerObserver extends TalkerObserver {
  const CrashlitycsLoggerObserver({
    required this.analyticsStore,
  });

  final AnalyticsStore analyticsStore;

  @override
  void onLog(TalkerData log) {
    analyticsStore.logMessage(log.generateTextMessage());
  }

  @override
  Future<void> onError(TalkerError err) async {
    if (shouldSkipEvent(err.exception)) {
      return;
    }
    analyticsStore.logError(
      err: err.error ?? Error(),
      stack: err.stackTrace,
      fatal: true,
    );
  }

  @override
  Future<void> onException(TalkerException err) async {
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
