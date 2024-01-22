import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:mysterium_vpn/entrypoints/enviroment.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  runZonedGuarded(() {
    Enviroment().launch(
      flavor: flavor,
      firebaseOptions: _getFirebaseOptions(flavor),
    );
  }, (error, stackTrace) async {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200';
    });
    await Sentry.captureException(error, stackTrace: stackTrace);
  });
}

FirebaseOptions? _getFirebaseOptions(String flavor) {
  try {
    if (flavor == Flavor.dev.name) {
      return dev.DefaultFirebaseOptions.currentPlatform;
    } else {
      return prod.DefaultFirebaseOptions.currentPlatform;
    }
  } catch (_) {
    return null;
  }
}
