import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/locations/store/latlng_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/config_cat_user_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/texts_store.dart';
import 'package:mysterium_vpn/pages/static/splash_page.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/lifecycle_listener.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class AppDeferredInitWidget extends StatefulWidget {
  const AppDeferredInitWidget({required this.child, super.key});

  final Widget child;

  @override
  State<AppDeferredInitWidget> createState() => _AppDeferredInitWidgetState();
}

class _AppDeferredInitWidgetState extends State<AppDeferredInitWidget> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _runStartup();
  }

  Future<void> _runStartup() async {
    final logger = getIt<Talker>()..log('App startup initiated');
    await Future.wait([
      _initRemoteConfig(logger).timeout(
        const Duration(seconds: 10),
        onTimeout: () => logger.log('Remote config init timed out'),
      ),
      _initLatLngStore(logger).timeout(
        const Duration(seconds: 10),
        onTimeout: () => logger.log('LatLng store init timed out'),
      ),
      _initOtherConfigCatStores(logger).timeout(
        const Duration(seconds: 10),
        onTimeout: () => logger.log('ConfigCat stores init timed out'),
      ),
      if (Platform.isWindows) _initWindows(),
    ]);
    logger.log('App fully initialized — ${Env.flavor.name} / ${Env.baseUrl}');
    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  Future<void> _initRemoteConfig(Talker talker) async {
    try {
      final configCatUserStore = getIt<ConfigCatUserStore>();
      final remoteConfigStore = getIt<RemoteConfigStore>();
      final configCatUser = await configCatUserStore.future;
      await remoteConfigStore.setUser(configCatUser);
      await remoteConfigStore.configFuture;
    } catch (e) {
      talker.log('Remote config init error (non-fatal): $e');
    }
  }

  Future<void> _initOtherConfigCatStores(Talker logger) async {
    try {
      final configCatUserStore = getIt<ConfigCatUserStore>();
      final configCatUser = await configCatUserStore.future;
      await Future.wait([
        getIt<ABTestingStore>().setUser(configCatUser),
        getIt<TextsStore>().setUser(configCatUser),
      ]);
    } catch (e) {
      logger.log('ConfigCat stores init error (non-fatal): $e');
    }
  }

  Future<void> _initLatLngStore(Talker logger) async {
    try {
      final latLngStore = getIt<LatLngStore>();
      await latLngStore.countryCoordinatesFuture;
    } catch (e) {
      logger.log('LatLng store init error (non-fatal): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SplashPage();
    }
    return widget.child;
  }
}

Future<void> _initWindows() async {
  try {
    await Future.wait([_nativeWindowsInit(), _setupTrayIcon()]);
    registerProtocolHandler(Env.appCustomSchemeUrl);
  } catch (e, stackTrace) {
    debugPrint('Windows init error (non-fatal): $e');
    await Sentry.captureException(e, stackTrace: stackTrace);
  }
}

Future<void> _nativeWindowsInit() async {
  final token = RootIsolateToken.instance!;
  await Future.wait([
    Isolate.spawn<List<Object>>(_wireguardInitBackground, <Object>[token]),
    Isolate.spawn<List<Object>>(_openvpnInitBackground, <Object>[token]),
  ]);
}

Future<void> _wireguardInitBackground(List<Object> args) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(args[0] as RootIsolateToken);
  try {
    await WireguardDart().nativeInit();
  } catch (e) {
    debugPrint('WireGuard native init error: $e');
  }
}

Future<void> _openvpnInitBackground(List<Object> args) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(args[0] as RootIsolateToken);
  try {
    await OpenVPNDart().ensureTapDriver();
  } catch (e) {
    debugPrint('OpenVPN native init error: $e');
  }
}

Future<void> _setupTrayIcon() async {
  try {
    await trayManager.setIcon(
      Env.flavor.isDev ? 'assets/logo/dev/app_icon.ico' : 'assets/logo/prod/app_icon.ico',
      iconPosition: TrayIconPosition.right,
    );
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: TrayMenuKeys.showWindow, label: 'Open'),
          MenuItem.separator(),
          MenuItem(key: TrayMenuKeys.exitApp, label: 'Exit MysteriumVPN'),
        ],
      ),
    );
  } catch (e) {
    Sentry.captureException(e);
  }
}
