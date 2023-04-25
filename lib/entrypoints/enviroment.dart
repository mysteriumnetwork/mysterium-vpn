import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'package:mysterium_vpn/firebase_options.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:url_protocol/url_protocol.dart';

class Enviroment {
  Future<void> launch({
    required String flavor,
  }) async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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

    final windowsOrLinux = isWindowsOrLinux();

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) {
        return stack.vmTrace;
      }
      if (stack is stack_trace.Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };
    if (!windowsOrLinux) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
    await SharedPreferenceService().init();
    await SecureStorageService().init();
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter());
    await Hive.openBox<UserData>('user_data');

    final flavorConfig = setupFlavor(flavor);
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
          ProviderScope(
            overrides: [environmentPOD.overrideWith((ref) => flavorConfig)],
            child: EasyLocalization(
              supportedLocales: kSupportedLocales,
              path: Assets.langs,
              fallbackLocale: kFallbackLocale,
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
        return FlavorConfig(flavor: Flavor.production, values: FlavorValues.production());
    }
  }
}
