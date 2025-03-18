//state providers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/services/mqtt/api_store.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_firebase.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store_windows.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/banners_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_desktop_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_mobile_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/remote_config/ab_testing_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/remote_config/texts_store.dart';
import 'package:mysterium_vpn/stores/rest_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';

final localeStorePOD = Provider<LocaleStore>((ref) => LocaleStore());

final authSessionStorePOD = Provider<AuthSessionStore>(
  (ref) => AuthSessionStore(
    secureStorage: SecureStorageService.instance,
    remoteConfigStore: ref.watch(remoteConfigStorePOD),
  ),
);

final authStorePOD = Provider<AuthStore>((ref) {
  final authService = ref.watch(authServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final appLinks = ref.watch(appLinksPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final env = ref.watch(environmentPOD);
  final intercomStore = ref.watch(intercomStorePOD);
  final logger = ref.watch(loggerPOD);
  final abTestingStore = ref.watch(abTestingStorePOD);

  return AuthStore(
    authService: authService,
    authSessionStore: authSessionStore,
    appLinks: appLinks,
    analyticsStore: analyticsStore,
    env: env,
    intercomStore: intercomStore,
    logger: logger,
    abTestingStore: abTestingStore,
  );
});

final apiStorePOD = Provider<ApiStore>((ref) {
  final mqttService = ref.watch(vpnApiMQTTPOD);
  final logger = ref.watch(loggerPOD);

  final store = ApiStore(
    mqtt: mqttService,
    logger: logger,
  );
  ref.onDispose(store.dispose);

  return store;
});

final themeStorePOD = Provider<ThemeStore>((ref) => ThemeStore());

final vpnStorePOD = Provider<VpnStore>((ref) {
  final apiService = ref.read(apiServicePOD);
  final mqttService = ref.watch(vpnApiMQTTPOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final wireguardService = ref.watch(wireguardServicePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final env = ref.watch(environmentPOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  return VpnStore(
    apiService: apiService,
    mqtt: mqttService,
    locationsStore: locationsStore,
    wireguardService: wireguardService,
    subscriptionStore: subscriptionStore,
    env: env,
    logger: logger,
    analyticsStore: analyticsStore,
    remoteConfigStore: remoteConfigStore,
  );
});

final locationsStorePOD = Provider<LocationsStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final filterService = ref.watch(filterServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final localeStore = ref.watch(localeStorePOD);

  final store = LocationsStore(
    apiService,
    filterService,
    analyticsStore,
    remoteConfigStore,
    SharedPreferenceService.instance,
    LocalDBService.instance,
    localeStore,
  );

  ref.onCancel(store.dispose);

  return store;
});

final subscriptionStorePOD = Provider<SubscriptionStore>((ref) {
  final inAppPurchase = ref.read(inAppPurchasePOD);
  final subscriptionService = ref.read(subscriptionServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);

  return SubscriptionStore(
    inAppPurchase: inAppPurchase,
    subscriptionService: subscriptionService,
    authSessionStore: authSessionStore,
    analyticsStore: analyticsStore,
  );
});

final restApiStorePOD = Provider<RestStore>((ref) {
  final apiService = ref.read(apiServicePOD);

  return RestStore(apiService: apiService);
});

final environmentPOD = Provider<FlavorConfig>(
  (ref) => throw UnimplementedError(),
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
    final env = ref.watch(environmentPOD);
    return AnalyticsStoreWindows(
      measurementId: env.values.measurementId,
      apiSecret: env.values.apiSecret,
    );
  }

  return AnalyticsStoreFirebase(
    analytics: FirebaseAnalytics.instance,
    crashlytics: FirebaseCrashlytics.instance,
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
  final client = ref.watch(remoteConfigClientPOD);
  final logger = ref.watch(loggerPOD);
  return RemoteConfigStore(client, logger);
});

final abTestingStorePOD = Provider<ABTestingStore>((ref) {
  final client = ref.watch(abTestingClientPOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  return ABTestingStore(client, logger, analyticsStore);
});

final textsStorePOD = Provider<TextsStore>((ref) {
  final client = ref.watch(textsClientPOD);
  final logger = ref.watch(loggerPOD);
  return TextsStore(client, logger);
});

final bannersStorePOD = Provider<BannersStore>(
  (ref) => BannersStore(
    ref.watch(apiServicePOD),
    ref.watch(subscriptionStorePOD),
    ref.watch(locationsStorePOD),
    ref.watch(authSessionStorePOD),
  ),
);

final realIPInfoStorePOD = Provider<RealIPInfoStore>(
  (ref) => RealIPInfoStore(
    ref.watch(apiServicePOD),
    SharedPreferenceService.instance,
    ref.watch(wireguardServicePOD),
  ),
);
