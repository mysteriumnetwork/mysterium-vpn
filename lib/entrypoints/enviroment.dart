import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:url_protocol/url_protocol.dart';
import 'package:window_manager/window_manager.dart';

class Enviroment {
  Future<void> launch({
    required String flavor,
    required FirebaseOptions firebaseOptions,
  }) async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    if (isDekstop()) {
      await windowManager.ensureInitialized();
    }
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    if (Platform.isWindows) {
      registerProtocolHandler('mysteriumvpn');
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light),
    );

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) {
        return stack.vmTrace;
      }
      if (stack is stack_trace.Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };

    await SharedPreferenceService.instance.init();
    await SecureStorageService.instance.init();
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter());
    await Hive.openBox<UserData>('user_data');

    final flavorConfig = setupFlavor(flavor);

    final container =
        ProviderContainer(overrides: [environmentPOD.overrideWith((ref) => flavorConfig)]);
    await container.read(analyticsInitPOD(firebaseOptions).future);
    final analyticsStore = container.read(analyticsStorePOD);
    await container.read(marketingAnalyticsInitPOD(flavorConfig).future);

    FlutterError.onError = (details) =>
        analyticsStore.logError(err: details.exception, stack: details.stack, fatal: true);
    PlatformDispatcher.instance.onError = (error, stack) {
      analyticsStore.logError(err: error, stack: stack, fatal: true);
      return true;
    };

    debugPrint('App started in ${flavorConfig.flavor} mode');
    debugPrint('Base URL ${flavorConfig.values.baseUrl}');
    await SentryFlutter.init(
      (options) {
        options
          ..dsn =
              'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200'
          ..sendClientReports = true
          ..maxRequestBodySize = MaxRequestBodySize.small
          ..maxResponseBodySize = MaxResponseBodySize.small;
      },
      appRunner: () {
        FlutterNativeSplash.remove();
        runApp(
          UncontrolledProviderScope(
            container: container,
            child: EasyLocalization(
              useOnlyLangCode: true,
              supportedLocales: kSupportedLocales,
              path: Assets.langs,
              fallbackLocale: kFallbackLocale,
              startLocale: kFallbackLocale,
              child: const MyApp(),
            ),
          ),
        );
      },
    );
  }

  FlavorConfig setupFlavor(String flavor) {
    switch (flavor) {
      case 'DEV':
        return FlavorConfig(flavor: Flavor.dev, values: FlavorValues.dev());

      case 'PROD':
        return FlavorConfig(flavor: Flavor.production, values: FlavorValues.production());

      default:
        return FlavorConfig(flavor: Flavor.dev, values: FlavorValues.dev());
    }
  }
}
