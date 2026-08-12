import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localizely_sdk/localizely_sdk.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_firebase.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:talker/talker.dart';
import 'package:window_manager/window_manager.dart';

/// Resolves once both Firebase and OneSignal have finished initializing
/// (including the post-Firebase observer/analytics-store wiring). Awaited by
/// the splash so dependents are only read once those SDKs are ready, while
/// the first frame paints immediately.
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

  Widget getApp() => UncontrolledProviderScope(container: providerContainer, child: const MyApp());

  Future<void> init() async {
    _configureSystemUI();
    _configureFlutterErrorHandling();

    if (isDesktop()) {
      await _initDesktop();
    }

    GoogleFonts.config.allowRuntimeFetching = false;

    if (Env.localizelySdkToken.isNotEmpty) {
      Localizely.init(Env.localizelySdkToken, Env.localizelyDistributionId);
    }

    await Future.wait([
      SharedPreferenceService.instance.init(),
      SecureStorageService.instance.init(),
      LocalDBService.initialize(),
      // Preload S so `S.current` is available before the first frame; app.dart's
      // locale reaction re-loads the persisted locale once the store is ready
      // (a no-op when it resolves to the same ARB locale).
      loadLocalizations(kFallbackLocale),
    ]);

    logger = providerContainer.read(loggerPOD);

    // Expose the analytics store to ref-less utils (e.g. openUrlLink).
    analyticsStoreRef = providerContainer.read(analyticsStorePOD);

    // Firebase + OneSignal run past the first frame; the splash awaits via
    // deferredInitFuturePOD.
    unawaited(_runDeferredInit());
  }

  Future<void> _runDeferredInit() async {
    final total = Stopwatch()..start();
    var firebaseInitMs = 0;
    var oneSignalInitMs = 0;
    try {
      await Future.wait([
        _initFirebaseSDK().then((ms) => firebaseInitMs = ms).then((_) => _onFirebaseReady()),
        _initOneSignal(logger).then((ms) => oneSignalInitMs = ms),
        // Independent of Firebase/OneSignal — fetch OTA translations concurrently.
        _updateLocalizelyTranslations(),
      ]);
      if (isMobile() && Firebase.apps.isNotEmpty) {
        await PerformanceMonitor.instance.activate();
        await PerformanceMonitor.instance.recordDeferredInit(
          firebaseInitMs: firebaseInitMs,
          oneSignalInitMs: oneSignalInitMs,
          totalMs: total.elapsedMilliseconds,
          attributes: {'flavor': Env.flavor.name},
        );
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    } finally {
      if (!_deferredInit.isCompleted) {
        _deferredInit.complete();
      }
    }
  }

  /// Fetches the latest Localizely over-the-air translations and reloads `S`
  /// for the active locale so updated strings apply without an app rebuild.
  Future<void> _updateLocalizelyTranslations() async {
    if (Env.localizelySdkToken.isEmpty) {
      return;
    }
    try {
      await Localizely.updateTranslations();
      final locale = providerContainer.read(localeStorePOD).currentLocale;
      await loadLocalizations(locale, force: true);
      // S.current is not observable; bump the revision so the tree repaints.
      localizationRevision.value++;
    } catch (e, stack) {
      logger.warning(e, stack);
    }
  }

  // ─── Firebase SDK ─────────────────────────────────────────────────────────────

  Future<int> _initFirebaseSDK() async {
    final sw = Stopwatch()..start();
    try {
      final options = switch (Env.flavor) {
        Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
        Flavor.production => prod.DefaultFirebaseOptions.currentPlatform,
      };
      await providerContainer.read(analyticsInitPOD(options).future);
    } catch (e, stack) {
      logger.handle(e, stack, 'Firebase SDK init error');
    }
    return sw.elapsedMilliseconds;
  }

  Future<void> _onFirebaseReady() async {
    final analyticsStore = providerContainer.read(analyticsStorePOD);
    if (analyticsStore is AnalyticsStoreFirebase) {
      logger.configure(observer: CrashlyticsLoggerObserver(analyticsStore: analyticsStore));
      await analyticsStore.init();
    }
  }

  // ─── OneSignal ─────────────────────────────────────────────────────────────
  Future<int> _initOneSignal(Talker logger) async {
    if (!isMobile()) {
      return 0;
    }
    final sw = Stopwatch()..start();
    try {
      if (kDebugMode) {
        await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }
      OneSignal.initialize(Env.oneSignalAppId);
    } catch (e) {
      logger.log('OneSignal init error (non-fatal): $e');
    }
    return sw.elapsedMilliseconds;
  }

  // ─── Desktop window ──────────────────────────────────────────────────────

  Future<void> _initDesktop() async {
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    final minimumSize = switch (Env.flavor) {
      Flavor.dev => const Size(320, 600),
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
