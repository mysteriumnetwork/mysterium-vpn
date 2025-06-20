import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/entrypoints/environment.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  final environment = Environment(flavor);

  WidgetsFlutterBinding.ensureInitialized();
  await environment.init();
  FlutterError.onError = (details) {
    environment.logger.handle(
      details.exception,
      details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    environment.logger.handle(error, stack, 'fatal');
    return true;
  };

  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            environment.remoteConfigStore?.sentryDsn ?? environment.flavorConfig.values.sentryDsn
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
    appRunner: () => runApp(environment.getApp()),
  );
}
