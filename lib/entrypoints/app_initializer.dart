import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:talker/talker.dart';
import 'package:window_manager/window_manager.dart';

class AppInitializer {
  AppInitializer();

  Talker logger = Talker();

  Widget getApp() => EasyLocalization(
    useOnlyLangCode: true,
    supportedLocales: kSupportedLocales,
    path: Asset.resources.langs.path,
    fallbackLocale: kFallbackLocale,
    startLocale: kFallbackLocale,
    assetLoader: getIt<AssetLoader>(),
    child: const MyApp(),
  );

  Future<void> init() async {
    _configureSystemUI();
    _configureFlutterErrorHandling();

    if (isDesktop()) {
      await _initDesktop();
    }

    GoogleFonts.config.allowRuntimeFetching = false;

    // Firebase must be initialised before setupServiceLocator() because
    // AnalyticsStoreFirebase calls FirebaseAnalytics.instance at registration time.
    await Future.wait([
      SharedPreferenceService.instance.init(),
      SecureStorageService.instance.init(),
      EasyLocalization.ensureInitialized(),
      LocalDBService.initialize(),
      _initFirebaseSDK(),
      _initOneSignal(logger),
    ]);

    try {
      await setupServiceLocator();
    } catch (e, st) {
      logger.log('Service locator init failed: $e\n$st');
    }

    logger = getIt<Talker>();
  }

  // ─── Firebase SDK ─────────────────────────────────────────────────────────────

  Future<void> _initFirebaseSDK() async {
    if (isWindowsOrLinux()) return;
    try {
      final options = switch (Env.flavor) {
        Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
        Flavor.production => prod.DefaultFirebaseOptions.currentPlatform,
      };
      await Firebase.initializeApp(options: options);
    } catch (e) {
      logger.log('Firebase SDK init error: $e');
    }
  }

  // ─── OneSignal ─────────────────────────────────────────────────────────────

  Future<void> _initOneSignal(Talker logger) async {
    if (!isMobile()) return;
    try {
      if (kDebugMode) {
        await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }
      OneSignal.initialize(Env.oneSignalAppId);
    } catch (e) {
      logger.log('OneSignal init error (non-fatal): $e');
    }
  }

  // ─── Desktop window ──────────────────────────────────────────────────────

  Future<void> _initDesktop() async {
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    final minimumSize = switch (Env.flavor) {
      Flavor.dev => const Size(400, 600),
      Flavor.production => const Size(1040, 700),
    };
    await windowManager.setMinimumSize(minimumSize);
    final actualSize = await windowManager.getSize();
    final desiredSize = Size(
      max(minimumSize.width, actualSize.width),
      max(minimumSize.height, actualSize.height),
    );
    if (actualSize != desiredSize) {
      await windowManager.setSize(desiredSize);
    }
  }

  void _configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      Platform.isAndroid
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      Platform.isAndroid ? SystemUiMode.edgeToEdge : SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
  }

  void _configureFlutterErrorHandling() {
    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) return stack.vmTrace;
      if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
      return stack;
    };
  }
}
