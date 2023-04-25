//state providers

import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/stores/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/rest_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final localeStorePOD = Provider<LocaleStore>((ref) => LocaleStore());

final authStorePOD = Provider<AuthStore>((ref) {
  final authService = ref.watch(authServicePOD);
  final appLinks = ref.watch(appLinksPOD);
  final localDb = ref.watch(localDBPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);

  return AuthStore(
    authService: authService,
    appLinks: appLinks,
    localDb: localDb,
    analyticsStore: analyticsStore,
  );
});

final themeStorePOD = Provider<ThemeStore>((ref) => ThemeStore());

final connectivityStorePOD = Provider<ConnectivityStore>((ref) => ConnectivityStore());

final vpnStorePOD = Provider<VpnStore>((ref) {
  final apiService = ref.read(apiServicePOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final wireguardService = ref.watch(wireguardServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  return VpnStore(
    apiService: apiService,
    locationsStore: locationsStore,
    wireguardService: wireguardService,
    analyticsStore: analyticsStore,
    subscriptionStore: subscriptionStore,
  );
});

final locationsStorePOD = Provider<LocationsStore>((ref) {
  final apiService = ref.read(apiServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  return LocationsStore(apiService: apiService, analyticsStore: analyticsStore);
});

final subscriptionStorePOD = Provider<SubscriptionStore>((ref) {
  final inAppPurchase = ref.read(inAppPurchasePOD);
  final subscriptionService = ref.read(subscriptionServicePOD);
  final authStore = ref.read(authStorePOD);
  final localDb = ref.read(localDBPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  return SubscriptionStore(
    inAppPurchase: inAppPurchase,
    subscriptionService: subscriptionService,
    authStore: authStore,
    localDb: localDb,
    analyticsStore: analyticsStore,
  );
});

final restApiStorePOD = Provider<RestStore>((ref) {
  final apiService = ref.read(apiServicePOD);
  return RestStore(apiService: apiService);
});

final routeInformationParserPOD = Provider((ref) => BeamerParser());

final routerDelegatePOD = Provider<BeamerDelegate>((ref) {
  final authStore = ref.read(authStorePOD);
  final firebaseAnalytics = ref.read(firebaseAnalyticsPOD);
  return BeamerDelegate(
    navigatorObservers: [
      FirebaseAnalyticsObserver(
        analytics: firebaseAnalytics,
        nameExtractor: (settings) => settings.name,
      ),
      SentryNavigatorObserver(),
    ],
    guards: [
      BeamGuard(
        pathPatterns: [
          Routes.home.toRoute,
          Routes.settings.toRoute,
          Routes.subscription.toRoute,
          Routes.emailCommunications.toRoute,
          Routes.notifications.toRoute,
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

final environmentPOD = StateProvider<FlavorConfig>(
  (ref) => FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues.production(),
  ),
);

final tokenStreamPOD = StreamProvider<String>((ref) {
  final authStore = ref.watch(authStorePOD);
  final streamController = StreamController<String>();
  final autorunDisposer = autorun((_) {
    if (authStore.authData != null) {
      streamController.add(authStore.authData!.accessToken);
    }
  });
  ref.onDispose(() {
    autorunDisposer();
    streamController.close();
  });

  return streamController.stream;
});

final analyticsStorePOD = StateProvider<AnalyticsStore>((ref) {
  final localDb = ref.watch(localDBPOD);
  final firebaseAnalytics = ref.watch(firebaseAnalyticsPOD);

  return AnalyticsStore(
    localDb: localDb,
    analytics: firebaseAnalytics,
  );
});
