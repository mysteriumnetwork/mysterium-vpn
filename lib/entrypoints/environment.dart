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
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/latlng_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:store_checker_windows/store_checker_windows.dart';
import 'package:talker/talker.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class Environment {
  Environment(this.flavor);

  final String flavor;
  late final ProviderContainer providerContainer;
  late final FlavorConfig flavorConfig;
  late final RemoteConfigStore? remoteConfigStore;
  late final Talker logger;

  Widget getApp() => UncontrolledProviderScope(
        container: providerContainer,
        child: EasyLocalization(
          useOnlyLangCode: true,
          supportedLocales: kSupportedLocales,
          path: Assets.langs,
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
      final minimumSize = flavor == 'DEV' ? const Size(400, 600) : const Size(1040, 700);
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

    if (Platform.isWindows) {
      registerProtocolHandler('mysteriumvpn');
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

    flavorConfig = await _setupFlavor();
    await _setupTrayIcon(flavorConfig);
    await Future.wait([
      SharedPreferenceService.instance.init(),
      SecureStorageService.instance.init(flavorConfig),
      EasyLocalization.ensureInitialized(),
      LocalDBService.initialize(),
    ]);
    providerContainer = ProviderContainer(
      overrides: [environmentPOD.overrideWithValue(flavorConfig)],
    );

    final firebaseOptions = _getFirebaseOptions();
    await providerContainer.read(analyticsInitPOD(firebaseOptions).future);
    final [rcStore, _] = await Future.wait([
      _initRemoteConfig(providerContainer),
      _initLatLngStore(providerContainer),
    ]);
    remoteConfigStore = rcStore! as RemoteConfigStore;
    logger = providerContainer.read(loggerPOD);

    logger.log(
      'App started in ${flavorConfig.flavor} mode\nBase URL ${flavorConfig.values.baseUrl}',
    );
  }

  Future<RemoteConfigStore?> _initRemoteConfig(ProviderContainer container) async {
    try {
      final remoteConfigStore = container.read(remoteConfigStorePOD);
      await remoteConfigStore.configFuture;
      return remoteConfigStore;
    } catch (e) {
      debugPrint('Error initializing remote config $e');
      return null;
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

  Future<FlavorConfig> _setupFlavor() async {
    var buildInfo = BuildInfo(
      buildNumber: 0,
      buildVersion: '0',
    );
    try {
      final info = await PackageInfo.fromPlatform();
      var installerStore = info.installerStore;
      if (Platform.isWindows) {
        installerStore = getCurrentPackageFullName();
      }
      buildInfo = BuildInfo(
        buildNumber: int.tryParse(info.buildNumber) ?? 0,
        buildVersion: info.version,
        installerStore: installerStore,
      );
    } catch (e) {
      debugPrint('Error getting package info');
      Sentry.captureException(e);
    }

    return switch (flavor) {
      'PROD' => FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues.production(),
          buildInfo: buildInfo,
        ),
      _ => FlavorConfig(
          flavor: Flavor.dev,
          values: FlavorValues.dev(),
          buildInfo: buildInfo,
        ),
    };
  }

  Future<void> _nativeInitBackground(List<Object> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      await WireguardDart().nativeInit();
      debugPrint('Native init done');
    } catch (e) {
      debugPrint('Native init error');
    }
  }

  Future<void> _nativeWindowsInit() async {
    final rootIsolateToken = RootIsolateToken.instance!;
    Isolate.spawn(_nativeInitBackground, [rootIsolateToken]);
  }

  Future<void> _setupTrayIcon(FlavorConfig flavor) async {
    if (!Platform.isWindows) {
      return;
    }
    try {
      await trayManager.setIcon(
        flavor.isDev ? 'assets/logo/dev/app_icon.ico' : 'assets/logo/prod/app_icon.ico',
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
      if (flavor == Flavor.dev.name) {
        return dev.DefaultFirebaseOptions.currentPlatform;
      } else {
        return prod.DefaultFirebaseOptions.currentPlatform;
      }
    } catch (_) {
      return null;
    }
  }
}
