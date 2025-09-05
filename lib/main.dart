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
  await initializer.init();
  FlutterError.onError = (details) {
    initializer.logger.handle(
      details.exception,
      details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    initializer.logger.handle(error, stack, 'fatal');
    return true;
  };

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = initializer.remoteConfigStore?.sentryDsn ?? Env.sentryDsn
        ..sendClientReports = true
        ..maxRequestBodySize = MaxRequestBodySize.small
        ..beforeSend = (event, hint) {
          debugPrint(event.throwable.toString());
          if (event.throwable is ApiException ||
              event.throwable is SignInAborted ||
              event.throwable is KeyDoesntExistsException ||
              event.throwable is TimeoutException ||
              event.throwable is TokenAlreadyUsedException ||
              event.throwable is OperationCancelledException ||
              event.throwable is SubscriptionRequiredException ||
              event.throwable is RefreshTokenNotFoundException) {
            return null;
          }
          return event;
        };
    },
    appRunner: () => runApp(initializer.getApp()),
  );
}
