//state providers

import 'package:beamer/beamer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
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

final vpnStorePOD = Provider.autoDispose<VpnStore>((ref) {
  return VpnStore();
});

final locationsStorePOD = Provider.autoDispose<LocationsStore>((ref) {
  return LocationsStore();
});

final routeInformationParserPOD = Provider((ref) => BeamerParser());

final routerDelegatePOD = Provider<BeamerDelegate>((ref) {
  final authStore = ref.read(authStorePOD);
  return BeamerDelegate(
    guards: [
      BeamGuard(
          pathPatterns: [Routes.home.toRoute, Routes.settings.toRoute, Routes.reportIssue.toRoute],
          check: (context, state) => authStore.authStatus == AuthStatus.authenticated,
          beamToNamed: (_, __) => Routes.login.toRoute),
      BeamGuard(
          pathPatterns: [Routes.login.toRoute],
          check: (context, state) =>
              authStore.authStatus == AuthStatus.unauthenticated ||
              authStore.authStatus == AuthStatus.loading,
          beamToNamed: (_, __) => Routes.home.toRoute),
      BeamGuard(
        pathPatterns: [Routes.splash.toRoute],
        check: (context, state) => authStore.authStatus == AuthStatus.unknown,
        beamToNamed: (_, __) => authStore.authStatus == AuthStatus.authenticated
            ? Routes.home.toRoute
            : Routes.login.toRoute,
      ),
    ],
    initialPath: Routes.splash.toRoute,
    locationBuilder: (routeInformation, _) => BeamerLocations(routeInformation),
  );
});
