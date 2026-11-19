import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  final initializer = AppInitializer();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = Env.sentryDsn
        ..sendClientReports = true
        ..maxRequestBodySize = MaxRequestBodySize.small
        ..beforeSend = _sentryBeforeSend;
    },
    appRunner: () async {
      _setupErrorHandlers(initializer);
      await initializer.init();
      initializer.logger.log('App started in ${Env.flavor.name} mode\nBase URL ${Env.baseUrl}');
      runApp(initializer.getApp());
    },
  );
}

/// Attach error handlers as early as practical in the startup flow so
/// crashes during app initialization are not silently swallowed.
void _setupErrorHandlers(AppInitializer initializer) {
  // Verbose builds report every error: throttling would hide a repeating
  // framework error from the console it is being debugged in.
  final verbose = kDebugMode || Env.flavor.isDev;

  installErrorHandlers(
    logger: () => initializer.logger,
    // SentryFlutter.init installed these.
    flutterOnError: FlutterError.onError,
    platformOnError: PlatformDispatcher.instance.onError,
    reportThrottle: verbose ? null : ErrorReportThrottle(),
    verboseDiagnostics: verbose,
  );
}

/// Filters out non-actionable exceptions from Sentry to reduce noise.
SentryEvent? _sentryBeforeSend(SentryEvent event, Hint hint) {
  if (kDebugMode) {
    debugPrint(event.throwable.toString());
  }

  return isNonActionable(event.throwable) ? null : event;
}
