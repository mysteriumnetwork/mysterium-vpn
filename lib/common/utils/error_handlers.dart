import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/utils/error_report_throttle.dart';
import 'package:talker/talker.dart';

/// Installs the global error handlers, chaining to the ones already in place —
/// Sentry's, from `SentryFlutter.init`. Overwriting them blinds Sentry.
///
/// [reportThrottle] gates that chained hop only; null chains every report.
/// Sentry parses every stack frame by regex synchronously on the thread that
/// threw, and dedupes only after, so a looping error pins Android's main
/// thread. The logger stays unthrottled — its observer keeps exact error counts
/// and throttles Crashlytics itself.
///
/// [logger] is read per error: AppInitializer swaps in the Crashlytics-observing
/// Talker once the provider container is up.
void installErrorHandlers({
  required Talker Function() logger,
  required FlutterExceptionHandler? flutterOnError,
  required ErrorCallback? platformOnError,
  ErrorReportThrottle? reportThrottle,
  bool verboseDiagnostics = false,
}) {
  bool chainReport(Object? error) => reportThrottle?.allow(error) ?? true;

  FlutterError.onError = (details) {
    // toStringDeep walks the whole diagnostics tree — too costly for release,
    // where this runs on the UI thread, which is Android's main thread.
    final diagnostics = verboseDiagnostics
        ? details.toDiagnosticsNode(style: DiagnosticsTreeStyle.error).toStringDeep()
        : details.summary.toString();
    logger().handle(details.exception, details.stack, diagnostics);
    if (chainReport(details.exception)) {
      flutterOnError?.call(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // Reported non-fatal — this returns true, so the app carries on — but the
    // reason marks it as having escaped every handler.
    logger().handle(error, stack, 'Unhandled async error');
    if (chainReport(error)) {
      platformOnError?.call(error, stack);
    }
    return true;
  };
}
