//state providers

import 'package:beamer/beamer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';

// final wireguardStorePOD = Provider<WireguardStore>((ref) {
//   final wireguardService = ref.read(wireguardServicePOD);
//   return WireguardStore(wireguardService: wireguardService);
// });

final localeStorePOD = Provider<LocaleStore>((ref) {
  return LocaleStore();
});

final authStorePOD = Provider<AuthStore>((ref) {
  return AuthStore();
});

final themeStorePOD = Provider<ThemeStore>((ref) {
  return ThemeStore();
});

final routeInformationParserPOD = Provider((ref) => BeamerParser());

final routerDelegatePOD = Provider<BeamerDelegate>((ref) {
  final authStore = ref.read(authStorePOD);

  return BeamerDelegate(
    guards: [
      BeamGuard(
          pathPatterns: ['/home'],
          check: (context, state) => authStore.authStatus == AuthStatus.authenticated,
          beamToNamed: (_, __) => '/login'),
      BeamGuard(
          pathPatterns: ['/login'],
          check: (context, state) => authStore.authStatus != AuthStatus.authenticated,
          beamToNamed: (_, __) => '/home'),
    ],
    initialPath: '/login',
    locationBuilder: (routeInformation, _) => BeamerLocations(routeInformation),
  );
});
