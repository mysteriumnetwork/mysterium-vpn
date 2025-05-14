import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/entrypoints/environment.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  final environment = Environment(flavor);

  await environment.init();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            environment.remoteConfigStore?.sentryDsn ?? environment.flavorConfig.values.sentryDsn
        ..sendClientReports = true
        ..maxRequestBodySize = MaxRequestBodySize.small
        ..maxResponseBodySize = MaxResponseBodySize.small
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
