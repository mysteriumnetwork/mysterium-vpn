import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:talker/talker.dart';

class CrashlitycsLoggerObserver extends TalkerObserver {
  const CrashlitycsLoggerObserver({
    required this.analyticsStore,
  });

  final AnalyticsStore analyticsStore;

  @override
  void onLog(TalkerDataInterface log) {
    analyticsStore.logMessage(log.generateTextMessage());
  }

  @override
  Future<void> onError(TalkerError err) async {
    analyticsStore.logError(
      err: err.error,
      stack: err.stackTrace,
      fatal: true,
    );
  }

  @override
  Future<void> onException(TalkerException err) async {
    analyticsStore.logError(
      err: err.exception,
      stack: err.stackTrace,
      reason: err.message,
      fatal: true,
    );
  }
}
