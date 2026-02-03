import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide runApp;
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:talker/talker.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class AppInitializer {
  AppInitializer();

  late final ProviderContainer providerContainer;
  late final RemoteConfigStore? remoteConfigStore;
  late final Talker logger;

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
    if (isDesktop()) {
      await windowManager.ensureInitialized();
      await windowManager.setPreventClose(true);
      // Give option to resize on DEV env for testing
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
    if (isMobile()) {
      if (kDebugMode) {
        await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }
      OneSignal.initialize(Env.oneSignalAppId);
    }

    if (Platform.isWindows) {
      registerProtocolHandler(Env.appCustomSchemeUrl);
      _nativeWindowsInit();
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light),
    );

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    SystemChrome.setEnabledSystemUIMode(
      Platform.isAndroid ? SystemUiMode.edgeToEdge : SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    GoogleFonts.config.allowRuntimeFetching = false;

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) {
        return stack.vmTrace;
      }
      if (stack is stack_trace.Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };

    await _setupTrayIcon();
    await Future.wait([
      SharedPreferenceService.instance.init(),
      SecureStorageService.instance.init(),
      EasyLocalization.ensureInitialized(),
      LocalDBService.initialize(),
    ]);
    providerContainer = ProviderContainer();

    final firebaseOptions = _getFirebaseOptions();
    await providerContainer.read(analyticsInitPOD(firebaseOptions).future);
    final [rcStore as RemoteConfigStore, _, _] = await Future.wait([
      _initRemoteConfig(providerContainer),
      _initLatLngStore(providerContainer),
      _initOtherConfigCatStores(providerContainer),
    ]);
    remoteConfigStore = rcStore;
    logger = providerContainer.read(loggerPOD);

    logger.log(
      'App started in ${Env.flavor.name} mode\nBase URL ${Env.baseUrl}',
    );
  }

  Future<RemoteConfigStore?> _initRemoteConfig(ProviderContainer container) async {
    try {
      final configCatUserStore = container.read(configCatUserStorePOD);
      final remoteConfigStore = container.read(remoteConfigStorePOD);

      final configCatUser = await configCatUserStore.future;
      await remoteConfigStore.setUser(configCatUser);

      await remoteConfigStore.configFuture;
      return remoteConfigStore;
    } catch (e) {
      debugPrint('Error initializing remote config $e');
      return null;
    }
  }

  Future<void> _initOtherConfigCatStores(ProviderContainer container) async {
    try {
      final configCatUserStore = container.read(configCatUserStorePOD);
      final abTestingStore = container.read(abTestingStorePOD);
      final textsStore = container.read(textsStorePOD);

      final configCatUser = await configCatUserStore.future;
      await Future.wait([
        abTestingStore.setUser(configCatUser),
        textsStore.setUser(configCatUser),
      ]);
    } catch (e) {
      debugPrint('Error initializing other ConfigCat stores $e');
    }
  }

  Future<LatLngStore?> _initLatLngStore(ProviderContainer container) async {
    try {
      final latLngStore = container.read(latLngStorePOD);
      await latLngStore.countryCoordinatesFuture;
      return latLngStore;
    } catch (e) {
      debugPrint('Error initializing latlng store $e');
      return null;
    }
  }

  Future<void> _wireguardInitBackground(List<Object> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      await WireguardDart().nativeInit();
      debugPrint('Native init done');
    } catch (e) {
      debugPrint('Native init error');
    }
  }

  Future<void> _openvpnInitBackground(List<Object> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      await OpenVPNDart().ensureTapDriver();
      debugPrint('OpenVPN native init done');
    } catch (e) {
      debugPrint('OpenVPN native init error');
    }
  }

  Future<void> _nativeWindowsInit() async {
    final rootIsolateToken = RootIsolateToken.instance!;
// Spawn both isolates in parallel
    await Future.wait([
      Isolate.spawn(_wireguardInitBackground, [rootIsolateToken]),
      Isolate.spawn(_openvpnInitBackground, [rootIsolateToken]),
    ]);
  }

  Future<void> _setupTrayIcon() async {
    if (!Platform.isWindows) {
      return;
    }
    try {
      await trayManager.setIcon(
        Env.flavor.isDev ? 'assets/logo/dev/app_icon.ico' : 'assets/logo/prod/app_icon.ico',
        iconPosition: TrayIconPosition.right,
      );
      final items = Menu(
        items: <MenuItem>[
          MenuItem(
            key: 'show_window',
            label: 'Open',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'exit_app',
            label: 'Exit MysteriumVPN',
          ),
        ],
      );

      await trayManager.setContextMenu(items);
    } catch (e) {
      Sentry.captureException(e);
    }
  }

  FirebaseOptions? _getFirebaseOptions() {
    try {
      return switch (Env.flavor) {
        Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
        Flavor.production => prod.DefaultFirebaseOptions.currentPlatform,
      };
    } catch (_) {
      return null;
    }
  }
}
