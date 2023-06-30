import 'package:beamer/beamer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

final routeInformationParserPOD = Provider((ref) => BeamerParser());

final routerDelegatePOD = Provider<BeamerDelegate>((ref) {
  final authStore = ref.read(authStorePOD);
  final navigatorObservers = ref.read(navigatorObserversPOD);
  return BeamerDelegate(
    navigatorObservers: navigatorObservers,
    guards: [
      BeamGuard(
        pathPatterns: [
          Routes.home.toRoute,
          Routes.settings.toRoute,
          Routes.subscription.toRoute,
          Routes.emailCommunications.toRoute,
          Routes.notifications.toRoute,
          Routes.vpnConfigConsent.toRoute,
          Routes.vpnPrivacyConsent.toRoute,
        ],
        check: (context, state) => authStore.authStatus == AuthStatus.authenticated,
        beamToNamed: (_, __) => Routes.login.toRoute,
      ),
      BeamGuard(
        pathPatterns: [Routes.login.toRoute],
        check: (context, state) =>
            authStore.authStatus == AuthStatus.unauthenticated ||
            authStore.authStatus == AuthStatus.authenticating,
        beamToNamed: (_, __) => Routes.home.toRoute,
      ),
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
