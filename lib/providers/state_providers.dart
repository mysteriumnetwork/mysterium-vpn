//state providers

import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/stores/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/intercom_store.dart';
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
  final env = ref.watch(environmentPOD);
  final intercomStore = ref.watch(intercomStorePOD);

  return AuthStore(
    authService: authService,
    appLinks: appLinks,
    localDb: localDb,
    analyticsStore: analyticsStore,
    env: env,
    intercomStore: intercomStore,
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
  final localDBService = ref.watch(localDBPOD);
  final env = ref.watch(environmentPOD);
  return VpnStore(
    apiService: apiService,
    locationsStore: locationsStore,
    wireguardService: wireguardService,
    analyticsStore: analyticsStore,
    subscriptionStore: subscriptionStore,
    localDBService: localDBService,
    env: env,
  );
});

final locationsStorePOD = Provider<LocationsStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final authStore = ref.watch(authStorePOD);
  return LocationsStore(
    apiService: apiService,
    analyticsStore: analyticsStore,
    authStore: authStore,
  );
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

final environmentPOD = StateProvider<FlavorConfig>(
  (ref) => FlavorConfig(
    flavor: Flavor.dev,
    values: FlavorValues.dev(),
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
  final analyticsService = ref.watch(analyticsServicePOD);

  return AnalyticsStore(
    analyticsService: analyticsService,
  );
});

final intercomStorePOD = StateProvider<IntercomStore>((ref) {
  final intercom = ref.watch(intercomPOD);

  return IntercomStore(
    intercom: intercom,
  );
});

final navigatorObserversPOD = Provider<List<NavigatorObserver>>((ref) {
  final navigatorObservers = <NavigatorObserver>[SentryNavigatorObserver()];

  if (!isWindowsOrLinux()) {
    navigatorObservers.add(
      FirebaseAnalyticsObserver(
        analytics: ref.read(firebaseAnalyticsPOD),
        nameExtractor: (settings) => settings.name,
      ),
    );
  }

  return navigatorObservers;
});
