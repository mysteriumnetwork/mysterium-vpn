import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  final initializer = AppInitializer();
  _setupErrorHandlers(initializer);
  await initializer.init();
  initializer.logger.log(
    'App started in ${Env.flavor.name} mode\nBase URL ${Env.baseUrl}',
  );
  await SentryFlutter.init(
    (options) {
      options
        ..dsn = Env.sentryDsn
        ..sendClientReports = true
        ..maxRequestBodySize = MaxRequestBodySize.small
        ..beforeSend = _sentryBeforeSend;
    },
    appRunner: () => runApp(initializer.getApp()),
  );
}

/// Attach error handlers as early as possible — before any async work —
/// so crashes during init are not silently swallowed.
void _setupErrorHandlers(AppInitializer initializer) {
  FlutterError.onError = (details) {
    initializer.logger.handle(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    initializer.logger.handle(error, stack, 'fatal');
    return true;
  };
}

/// Filters out non-actionable exceptions from Sentry to reduce noise.
SentryEvent? _sentryBeforeSend(SentryEvent event, Hint hint) {
  debugPrint(event.throwable.toString());

  const ignoredTypes = {
    ApiException,
    SignInAborted,
    KeyDoesntExistsException,
    TimeoutException,
    TokenAlreadyUsedException,
    OperationCancelledException,
    SubscriptionRequiredException,
    RefreshTokenNotFoundException,
  };

  if (ignoredTypes.any((type) => event.throwable.runtimeType == type)) {
    return null;
  }
  return event;
}
