import 'package:beamer/beamer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final routeInformationParserPOD = Provider((ref) => BeamerParser());

final routerDelegatePOD = Provider<BeamerDelegate>((ref) {
  final authSessionStore = ref.read(authSessionStorePOD);
  final analyticsStore = ref.read(analyticsStorePOD);
  final authStore = ref.read(authStorePOD);
  return BeamerDelegate(
    navigatorObservers: [
      ...analyticsStore.navigationObservers(),
      SentryNavigatorObserver(),
    ],
    guards: [
      BeamGuard(
        pathPatterns: [
          Routes.main.path,
          Routes.settings.path,
        ],
        check: (context, state) => authSessionStore.canBrowseApp,
        beamToNamed: (_, __) => Routes.platformLogin.path,
      ),
      BeamGuard(
        pathPatterns: [
          Routes.payment.path,
          Routes.paymentSettings.path,
        ],
        check: (context, state) => authSessionStore.status == AuthStatus.authenticated,
        beamToNamed: (_, __) => Routes.platformLogin.path,
      ),
      BeamGuard(
        pathPatterns: [
          Routes.platformLogin.path,
          Routes.checkYourEmail.path,
        ],
        check: (context, state) =>
            authSessionStore.status == AuthStatus.unauthenticated ||
            authStore.authenticateFeature?.status == FutureStatus.pending,
        beamToNamed: (_, __) => Routes.main.path,
      ),
      BeamGuard(
        pathPatterns: [Routes.emailToken.path],
        check: (context, state) => false,
        beamToNamed: (a, b) => a?.state.routeInformation.uri.path ?? Routes.platformLogin.path,
      ),
      BeamGuard(
        pathPatterns: [Routes.splash.path],
        check: (context, state) => authSessionStore.status == AuthStatus.unknown,
        beamToNamed: (_, __) =>
            authSessionStore.canBrowseApp ? Routes.main.path : Routes.platformLogin.path,
      ),
    ],
    initialPath: Routes.splash.path,
    locationBuilder: (routeInformation, _) => BeamerLocations(routeInformation),
    setBrowserTabTitle: false,
    notFoundRedirectNamed: Routes.main.path,
  );
});
