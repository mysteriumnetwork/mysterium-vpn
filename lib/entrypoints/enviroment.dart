import 'dart:io';
import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
import 'package:tray_manager/tray_manager.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class Enviroment {
  Future<void> launch({
    required String flavor,
    required FirebaseOptions? firebaseOptions,
  }) async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    if (isDesktop()) {
      await windowManager.ensureInitialized();
      await windowManager.setPreventClose(true);
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

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) {
        return stack.vmTrace;
      }
      if (stack is stack_trace.Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };

    final flavorConfig = setupFlavor(flavor);
    await setupTrayIcon(flavorConfig);
    await SharedPreferenceService.instance.init();
    await SecureStorageService.instance.init(flavorConfig);
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter());
    await Hive.openBox<UserData>('user_data');

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

  FlavorConfig setupFlavor(String flavor) => switch (flavor) {
        'DEV' => FlavorConfig(flavor: Flavor.dev, values: FlavorValues.dev()),
        'PROD' => FlavorConfig(flavor: Flavor.production, values: FlavorValues.production()),
        _ => FlavorConfig(flavor: Flavor.dev, values: FlavorValues.dev())
      };

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
