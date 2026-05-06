import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_firebase.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:talker/talker.dart';
import 'package:window_manager/window_manager.dart';

/// Resolves once OneSignal is initialized. Awaited by the splash so
/// pushNotificationsStorePOD is only constructed after OneSignal is ready,
/// while the first frame paints immediately.
final deferredInitFuturePOD = Provider<Future<void>>((ref) => Future.value());

class AppInitializer {
  AppInitializer() {
    providerContainer = ProviderContainer(
      overrides: [deferredInitFuturePOD.overrideWithValue(_deferredInit.future)],
    );
  }

  late final ProviderContainer providerContainer;
  Talker logger = Talker();

  final Completer<void> _deferredInit = Completer<void>();

  Widget getApp() => UncontrolledProviderScope(
    container: providerContainer,
    child: EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: kSupportedLocales,
      path: Asset.resources.langs.path,
      fallbackLocale: kFallbackLocale,
      startLocale: kFallbackLocale,
      assetLoader: providerContainer.read(assetsLoaderPOD),
      child: const MyApp(),
    ),
  );

  Future<void> init() async {
    _configureSystemUI();
    _configureFlutterErrorHandling();

    if (isDesktop()) {
      await _initDesktop();
    }

    GoogleFonts.config.allowRuntimeFetching = false;

    await Future.wait([
      SharedPreferenceService.instance.init(),
      SecureStorageService.instance.init(),
      EasyLocalization.ensureInitialized(),
      LocalDBService.initialize(),
    ]);

    logger = providerContainer.read(loggerPOD);

    // Firebase + OneSignal run past the first frame; the splash awaits via
    // deferredInitFuturePOD.
    unawaited(_runDeferredInit());
  }

  Future<void> _runDeferredInit() async {
    try {
      await Future.wait([
        _initFirebaseSDK().then((_) => _onFirebaseReady()),
        _initOneSignal(logger),
      ]);
    } catch (e, stack) {
      logger.handle(e, stack);
    } finally {
      if (!_deferredInit.isCompleted) {
        _deferredInit.complete();
      }
    }
  }

  // ─── Firebase SDK ─────────────────────────────────────────────────────────────

  Future<void> _initFirebaseSDK() async {
    try {
      final options = switch (Env.flavor) {
        Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
        Flavor.production => prod.DefaultFirebaseOptions.currentPlatform,
      };
      await providerContainer.read(analyticsInitPOD(options).future);
    } catch (e) {
      logger.log('Firebase SDK init error$e');
    }
  }

  Future<void> _onFirebaseReady() async {
    final analyticsStore = providerContainer.read(analyticsStorePOD);
    if (analyticsStore is AnalyticsStoreFirebase) {
      logger.configure(observer: CrashlyticsLoggerObserver(analyticsStore: analyticsStore));
      await analyticsStore.init();
    }
  }

  // ─── OneSignal ─────────────────────────────────────────────────────────────
  Future<void> _initOneSignal(Talker logger) async {
    if (!isMobile()) {
      return;
    }
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
      if (stack is stack_trace.Trace) {
        return stack.vmTrace;
      }
      if (stack is stack_trace.Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };
  }
}
