import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/pages/static/splash_page.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

final _appStartupPOD = FutureProvider<void>((ref) async {
  final logger = ref.read(loggerPOD)..log('App startup initiated');
  await Future.wait([
    _initRemoteConfig(ref, logger).timeout(
      const Duration(seconds: 10),
      onTimeout: () => logger.log('Remote config init timed out'),
    ),
    _initLatLngStore(ref, logger).timeout(
      const Duration(seconds: 10),
      onTimeout: () => logger.log('LatLng store init timed out'),
    ),
    _initOtherConfigCatStores(ref, logger).timeout(
      const Duration(seconds: 10),
      onTimeout: () => logger.log('ConfigCat stores init timed out'),
    ),
    _initOneSignal(
      logger,
    ).timeout(const Duration(seconds: 10), onTimeout: () => logger.log('OneSignal init timed out')),
    if (Platform.isWindows) _initWindows(),
  ]);

  ref.read(loggerPOD).log('App fully initialized — ${Env.flavor.name} / ${Env.baseUrl}');
});

Future<void> _initRemoteConfig(Ref ref, Talker talker) async {
  try {
    final configCatUserStore = ref.read(configCatUserStorePOD);
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
    final configCatUser = await configCatUserStore.future;
    await remoteConfigStore.setUser(configCatUser);
    await remoteConfigStore.configFuture;
  } catch (e) {
    talker.log('Remote config init error (non-fatal): $e');
  }
}

Future<void> _initOtherConfigCatStores(Ref ref, Talker logger) async {
  try {
    final configCatUserStore = ref.read(configCatUserStorePOD);
    final configCatUser = await configCatUserStore.future;
    await Future.wait([
      ref.read(abTestingStorePOD).setUser(configCatUser),
      ref.read(textsStorePOD).setUser(configCatUser),
    ]);
  } catch (e) {
    logger.log('ConfigCat stores init error (non-fatal): $e');
  }
}

Future<void> _initLatLngStore(Ref ref, Talker logger) async {
  try {
    final latLngStore = ref.read(latLngStorePOD);
    await latLngStore.countryCoordinatesFuture;
  } catch (e) {
    logger.log('LatLng store init error (non-fatal): $e');
  }
}

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
          MenuItem(key: 'show_window', label: 'Open'),
          MenuItem.separator(),
          MenuItem(key: 'exit_app', label: 'Exit MysteriumVPN'),
        ],
      ),
    );
  } catch (e) {
    Sentry.captureException(e);
  }
}

class AppDeferredInitWidget extends ConsumerWidget {
  const AppDeferredInitWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(_appStartupPOD);

    return startup.when(
      loading: () => const SplashPage(),
      data: (_) => child,
      error: (_, _) => child,
    );
  }
}
