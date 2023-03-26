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
import 'package:mysterium_vpn/firebase_options.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

class Enviroment {
  Future<void> launch({
    required String flavor,
    required FirebaseOptions firebaseOptions,
  }) async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
    final needsWeb = Platform.isLinux || Platform.isWindows;
    await Firebase.initializeApp(
      options: needsWeb ? DefaultFirebaseOptions.web : firebaseOptions,
    );
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) {
        return stack.vmTrace;
      }
      if (stack is stack_trace.Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await SharedPreferenceService.init();
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter());
    await Hive.openBox<UserData>('user_data');
    FlutterNativeSplash.remove();

    final flavorConfig = setupFlavor(flavor);
    debugPrint('App started in ${flavorConfig.flavor} mode');
    debugPrint('Base URL ${flavorConfig.values.baseUrl}');

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
