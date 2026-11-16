import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
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
  // SentryFlutter.init installed these; chain to them or Sentry goes blind to
  // every framework and unhandled async error.
  final sentryFlutterOnError = FlutterError.onError;
  final sentryPlatformOnError = PlatformDispatcher.instance.onError;

  FlutterError.onError = (details) {
    // toStringDeep walks the whole diagnostics tree — too costly for release,
    // where this runs on the UI thread, which is Android's main thread.
    final diagnostics = kDebugMode || Env.flavor.isDev
        ? details.toDiagnosticsNode(style: DiagnosticsTreeStyle.error).toStringDeep()
        : details.summary.toString();
    initializer.logger.handle(details.exception, details.stack, diagnostics);
    sentryFlutterOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    initializer.logger.handle(error, stack, 'fatal');
    sentryPlatformOnError?.call(error, stack);
    return true;
  };
}

/// Filters out non-actionable exceptions from Sentry to reduce noise.
SentryEvent? _sentryBeforeSend(SentryEvent event, Hint hint) {
  if (kDebugMode) {
    debugPrint(event.throwable.toString());
  }

  return isNonActionable(event.throwable) ? null : event;
}
