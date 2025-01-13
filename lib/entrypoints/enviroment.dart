import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/data/local/adapters/banner_type_adapter.dart';
import 'package:mysterium_vpn/services/data/local/adapters/vpn_location_adapter.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:store_checker_windows/store_checker_windows.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class Enviroment {
  Future<void> launch({
    required String flavor,
    required FirebaseOptions? firebaseOptions,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (isDesktop()) {
      await windowManager.ensureInitialized();
      await windowManager.setPreventClose(true);
      await windowManager.setMinimumSize(const Size(400, 600));
    }

    if (Platform.isWindows) {
      registerProtocolHandler('mysteriumvpn');
      nativeWindowsInit();
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

    final flavorConfig = await setupFlavor(flavor: flavor);
    await setupTrayIcon(flavorConfig);
    await SharedPreferenceService.instance.init();
    await SecureStorageService.instance.init(flavorConfig);
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter())
      ..registerAdapter(VPNLocationAdapter(typeId: 3))
      ..registerAdapter(BannerTypeAdapter(typeId: 4));
    await Hive.openBox<UserData>(
      'user_data',
      compactionStrategy: (e, d) => false,
    );

    final container = ProviderContainer(
      overrides: [environmentPOD.overrideWithValue(flavorConfig)],
    );
    await container.read(analyticsInitPOD(firebaseOptions).future);
    await initRemoteConfig(container);
    final logger = container.read(loggerPOD);

    FlutterError.onError = (details) {
      logger.handle(
        details.exception,
        details.stack,
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.handle(error, stack, 'fatal');
      return true;
    };

    logger.log(
      'App started in ${flavorConfig.flavor} mode\nBase URL ${flavorConfig.values.baseUrl}',
    );
    await SentryFlutter.init(
      (options) {
        options
          ..dsn =
              'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200'
          ..sendClientReports = true
          ..maxRequestBodySize = MaxRequestBodySize.small
          ..maxResponseBodySize = MaxResponseBodySize.small
          ..beforeSend = (event, hint) {
            debugPrint(event.throwable.toString());
            if (event.throwable is ApiException ||
                event.throwable is SignInAborted ||
                event.throwable is KeyDoesntExistsException ||
                event.throwable is TimeoutException ||
                event.throwable is TokenAlreadyUsedException ||
                event.throwable is OperationCancelledException ||
                event.throwable is SubscriptionRequiredException) {
              return null;
            }
            return event;
          };
      },
      appRunner: () {
        runApp(
          UncontrolledProviderScope(
            container: container,
            child: EasyLocalization(
              useOnlyLangCode: true,
              supportedLocales: kSupportedLocales,
              path: Assets.langs,
              fallbackLocale: kFallbackLocale,
              startLocale: kFallbackLocale,
              assetLoader: container.read(assetsLoaderPOD),
              child: const MyApp(),
            ),
          ),
        );
      },
    );
  }

  Future<void> initRemoteConfig(ProviderContainer container) async {
    try {
      final remoteConfigStore = container.read(remoteConfigStorePOD);
      await remoteConfigStore.configFuture;
    } catch (e) {
      debugPrint('Error initializing remote config $e');
    }
  }

  Future<FlavorConfig> setupFlavor({required String flavor}) async {
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
    }

    return switch (flavor) {
      'DEV' => FlavorConfig(
          flavor: Flavor.dev,
          values: FlavorValues.dev(),
          buildInfo: buildInfo,
        ),
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

  Future<void> nativeInitBackground(List<Object> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      await WireguardDart().nativeInit();
      debugPrint('Native init done');
    } catch (e) {
      debugPrint('Native init error');
    }
  }

  Future<void> nativeWindowsInit() async {
    final rootIsolateToken = RootIsolateToken.instance!;
    Isolate.spawn(nativeInitBackground, [rootIsolateToken]);
  }

  Future<void> setupTrayIcon(FlavorConfig flavor) async {
    if (!Platform.isWindows) {
      return;
    }
    await trayManager.setIcon(
      flavor.isDev() ? 'assets/logo/dev/app_icon.ico' : 'assets/logo/prod/app_icon.ico',
      iconPosition: TrayIconPositon.right,
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
  }
}
