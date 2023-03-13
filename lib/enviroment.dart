import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/flavor_config.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

class Enviroment {
  Future<void> launch({
    required FlavorConfig env,
    required FirebaseOptions firebaseOptions,
  }) async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
    await SharedPreferenceService.init();
    await EasyLocalization.ensureInitialized();
    FlutterNativeSplash.remove();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    debugPrint('App started in ${env.flavor} mode');
    runApp(
      ProviderScope(
        overrides: [environmentPOD.overrideWith((ref) => env)],
        child: EasyLocalization(
          supportedLocales: kSupportedLocales,
          path: Assets.langs,
          fallbackLocale: kFallbackLocale,
          assetLoader: const CodegenLoader(),
          child: const MyApp(),
        ),
      ),
    );
  }
}
