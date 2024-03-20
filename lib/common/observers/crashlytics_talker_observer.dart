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
    analyticsStore.logError(
      err: err.error ?? Error(),
      stack: err.stackTrace,
      fatal: true,
    );
  }

  @override
  Future<void> onException(TalkerException err) async {
    analyticsStore.logError(
      err: err.exception ?? Exception('Unknown exception'),
      stack: err.stackTrace,
      reason: err.exception.toString(),
      fatal: true,
    );
  }
}
