import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

class CrashlyticsLoggerObserver extends TalkerObserver {
  const CrashlyticsLoggerObserver({required this.analyticsStore});

  final AnalyticsStore analyticsStore;

  @override
  void onLog(TalkerData log) {
    analyticsStore.logMessage(log.generateTextMessage());
  }

  @override
  Future<void> onError(TalkerError err) async {
    // TalkerError populates `error`, never `exception`.
    trackErrorEvent(err.error);
    if (isNonActionable(err.error)) {
      return;
    }
    analyticsStore.logError(err: err.error ?? Error(), stack: err.stackTrace, fatal: true);
  }

  @override
  Future<void> onException(TalkerException err) async {
    trackErrorEvent(err.exception);
    if (isNonActionable(err.exception)) {
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
          'error_code': ?apiError.errorCode,
          'endpoint': apiError.endpoint,
          'method': apiError.requestOptions.method,
          'error_type': 'api_exception',
        },
      );
    }
  }
}
