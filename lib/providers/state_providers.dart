//state providers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_firebase.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_noop.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_desktop_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_mobile_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/remote_config/ab_testing_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/rest_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

final localeStorePOD = Provider<LocaleStore>((ref) => LocaleStore());

final authStorePOD = Provider<AuthStore>((ref) {
  final authService = ref.watch(authServicePOD);
  final appLinks = ref.watch(appLinksPOD);
  final localDb = ref.watch(localDBPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final env = ref.watch(environmentPOD);
  final intercomStore = ref.watch(intercomStorePOD);
  final logger = ref.watch(loggerPOD);
  final userPreferencesStore = ref.watch(userPreferencesStorePOD);
  return AuthStore(
    authService: authService,
    appLinks: appLinks,
    localDb: localDb,
    analyticsStore: analyticsStore,
    env: env,
    intercomStore: intercomStore,
    logger: logger,
    userPreferencesStore: userPreferencesStore,
  );
});

final themeStorePOD = Provider<ThemeStore>((ref) => ThemeStore());

final vpnStorePOD = Provider<VpnStore>((ref) {
  final apiService = ref.read(apiServicePOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final wireguardService = ref.watch(wireguardServicePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final localDBService = ref.watch(localDBPOD);
  final env = ref.watch(environmentPOD);
  final logger = ref.watch(loggerPOD);
  return VpnStore(
    apiService: apiService,
    locationsStore: locationsStore,
    wireguardService: wireguardService,
    subscriptionStore: subscriptionStore,
    localDBService: localDBService,
    env: env,
    logger: logger,
  );
});

final locationsStorePOD = Provider<LocationsStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final localeStore = ref.watch(localeStorePOD);
  final authStore = ref.watch(authStorePOD);
  return LocationsStore(
    apiService: apiService,
    analyticsStore: analyticsStore,
    authStore: authStore,
    localeStore: localeStore,
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
    buildInfo: BuildInfo(
      buildNumber: 0,
      buildVersion: '0',
    ),
    isStoreVersion: true,
  ),
);

final analyticsInitPOD = FutureProviderFamily<void, FirebaseOptions?>((ref, options) async {
  if (options == null) {
    return;
  }
  await Firebase.initializeApp(
    options: options,
  );
});

final analyticsStorePOD = StateProvider<AnalyticsStore>((ref) {
  if (isWindowsOrLinux()) {
    return AnalyticsStoreNoop();
  }
  final localDb = ref.watch(localDBPOD);
  return AnalyticsStoreFirebase(
    analytics: FirebaseAnalytics.instance,
    crashlytics: FirebaseCrashlytics.instance,
    localDb: localDb,
  );
});

final intercomStorePOD = StateProvider<IntercomStore>((ref) {
  if (isDesktop()) {
    return IntercomDesktopStore();
  }
  return IntercomMobileStore(intercom: Intercom.instance);
});

final isAppWindowFocused = StateProvider<bool>((_) => true);

final userPreferencesStorePOD = StateProvider<UserPreferencesStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  return UserPreferencesStore(
    apiService: apiService,
  );
});

final remoteConfigStorePOD = Provider<RemoteConfigStore>((ref) {
  final logger = ref.watch(loggerPOD);
  final configCatClient = ref.watch(remoteConfigClientPOD);
  return RemoteConfigStore(client: configCatClient, logger: logger);
});

final abTestingStorePOD = Provider<ABTestingStore>((ref) {
  final logger = ref.watch(loggerPOD);
  final configCatClient = ref.watch(abTestingClientPOD);
  return ABTestingStore(client: configCatClient, logger: logger);
});
