import 'package:beamer/beamer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final routeInformationParserPOD = Provider((ref) => BeamerParser());

final routerDelegatePOD = Provider<BeamerDelegate>((ref) {
  final authSessionStore = ref.read(authSessionStorePOD);
  final analyticsStore = ref.read(analyticsStorePOD);
  return BeamerDelegate(
    navigatorObservers: [
      ...analyticsStore.navigationObservers(),
      SentryNavigatorObserver(),
    ],
    guards: [
      BeamGuard(
        pathPatterns: [
          Routes.main.toRoute,
          Routes.settings.toRoute,
          Routes.payment.toRoute,
          Routes.emailCommunications.toRoute,
          Routes.notifications.toRoute,
          Routes.permissions.toRoute,
          Routes.privacyPolicy.toRoute,
        ],
        check: (context, state) => authSessionStore.status == AuthStatus.authenticated,
        beamToNamed: (_, __) => Routes.welcome.toRoute,
      ),
      BeamGuard(
        pathPatterns: [Routes.welcome.toRoute],
        check: (context, state) =>
            authSessionStore.status == AuthStatus.unauthenticated ||
            authSessionStore.status == AuthStatus.authenticating,
        beamToNamed: (_, __) => Routes.main.toRoute,
      ),
      BeamGuard(
        pathPatterns: [Routes.splash.toRoute],
        check: (context, state) => authSessionStore.status == AuthStatus.unknown,
        beamToNamed: (_, __) => authSessionStore.status == AuthStatus.authenticated
            ? Routes.main.toRoute
            : Routes.welcome.toRoute,
      ),
    ],
    initialPath: Routes.splash.toRoute,
    locationBuilder: (routeInformation, _) => BeamerLocations(routeInformation),
  );
});
