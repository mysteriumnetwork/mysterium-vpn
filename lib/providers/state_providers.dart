//state providers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
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
import 'package:mysterium_vpn/stores/device_id_store.dart';
import 'package:mysterium_vpn/stores/device_info_store.dart';
import 'package:mysterium_vpn/stores/dns_store.dart';
import 'package:mysterium_vpn/stores/latlng_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/network_statistics_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/refresh_ip_store.dart';
import 'package:mysterium_vpn/stores/remote_config/ab_testing_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/remote_config/texts_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:mysterium_vpn/stores/update_availabe_store.dart';
import 'package:mysterium_vpn/stores/user_intents_store.dart';
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
  final userPreferencesStore = ref.watch(userPreferencesStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final appLinks = ref.watch(appLinksPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final logger = ref.watch(loggerPOD);
  final abTestingStore = ref.watch(abTestingStorePOD);

  return AuthStore(
    authService: authService,
    userPreferencesStore: userPreferencesStore,
    authSessionStore: authSessionStore,
    appLinks: appLinks,
    analyticsStore: analyticsStore,
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
  final externalApiService = ref.watch(externalApiServicePOD);
  final mqttService = ref.watch(vpnApiMQTTPOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final wireguardService = ref.watch(wireguardServicePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  final wireguardKeyService = ref.watch(wireguradKeyServicePOD);
  final dnsStore = ref.watch(dnsStorePOD);
  final refreshIPStore = ref.watch(refreshIPStorePOD);
  return VpnStore(
    apiService: apiService,
    externalApiService: externalApiService,
    mqtt: mqttService,
    locationsStore: locationsStore,
    wireguardService: wireguardService,
    subscriptionStore: subscriptionStore,
    logger: logger,
    analyticsStore: analyticsStore,
    remoteConfigStore: remoteConfigStore,
    authSessionStore: authSessionStore,
    realIPInfo: realIPInfoStore,
    wireguardKeyService: wireguardKeyService,
    dnsStore: dnsStore,
    refreshIPStore: refreshIPStore,
  );
});

final locationsStorePOD = Provider<LocationsStore>((ref) {
  final api = ref.watch(vpnApiPOD);
  final filterService = ref.watch(filterServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final localeStore = ref.watch(localeStorePOD);
  final logger = ref.watch(loggerPOD);

  final store = LocationsStore(
    api.getConnection(),
    filterService,
    analyticsStore,
    remoteConfigStore,
    SharedPreferenceService.instance,
    LocalDBService.instance,
    logger,
    localeStore,
    null,
  );

  ref.onCancel(store.dispose);

  return store;
});

final subscriptionStorePOD = Provider<SubscriptionStore>((ref) {
  final inAppPurchase = ref.read(inAppPurchasePOD);
  final subscriptionService = ref.read(subscriptionServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);

  final store = SubscriptionStore(
    inAppPurchase: inAppPurchase,
    subscriptionService: subscriptionService,
    authSessionStore: authSessionStore,
    analyticsStore: analyticsStore,
  );
  ref.onCancel(store.dispose);
  return store;
});

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
    return AnalyticsStoreWindows(
      measurementId: Env.measurementId,
      apiSecret: Env.apiSecret,
      deviceInfoStore: ref.watch(deviceInfoStorePOD),
      deviceIDStore: ref.watch(deviceIDStorePOD),
    );
  }

  return AnalyticsStoreFirebase(
    analytics: FirebaseAnalytics.instance,
    crashlytics: FirebaseCrashlytics.instance,
    deviceInfoStore: ref.watch(deviceInfoStorePOD),
    deviceIDStore: ref.watch(deviceIDStorePOD),
  );
});

final isAppWindowFocused = StateProvider<bool>((_) => true);

final userPreferencesStorePOD = StateProvider<UserPreferencesStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  return UserPreferencesStore(
    apiService: apiService,
    analyticsStore: analyticsStore,
    realIPInfo: realIPInfoStore,
    localDBService: LocalDBService.instance,
  );
});

final remoteConfigStorePOD = Provider<RemoteConfigStore>((ref) {
  final client = ref.watch(remoteConfigClientPOD);
  final logger = ref.watch(loggerPOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  return RemoteConfigStore(client, logger, realIPInfoStore, isDev: Env.flavor.isDev);
});

final abTestingStorePOD = Provider<ABTestingStore>((ref) {
  final client = ref.watch(abTestingClientPOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);

  return ABTestingStore(client, logger, realIPInfoStore, analyticsStore);
});

final textsStorePOD = Provider<TextsStore>((ref) {
  final client = ref.watch(textsClientPOD);
  final logger = ref.watch(loggerPOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);

  return TextsStore(client, logger, realIPInfoStore);
});

final bannersStorePOD = Provider<BannersStore>(
  (ref) => BannersStore(
    LocalDBService.instance,
    ref.watch(subscriptionStorePOD),
    ref.watch(authSessionStorePOD),
    ref.watch(vpnStorePOD),
    ref.watch(updateAvailableStorePOD),
  ),
);

final realIPInfoStorePOD = Provider<RealIPInfoStore>(
  (ref) => RealIPInfoStore(
    ref.watch(externalApiServicePOD),
    SharedPreferenceService.instance,
    ref.watch(wireguardServicePOD),
    ref.watch(analyticsStorePOD),
  ),
);

final deviceInfoStorePOD = Provider<DeviceInfoStore>(
  (ref) => DeviceInfoStore(),
);

final deviceIDStorePOD = Provider<DeviceIDStore>(
  (ref) => DeviceIDStore(),
);

final latLngStorePOD = Provider<LatLngStore>((ref) {
  final assetsService = ref.watch(assetsServicePOD);
  return LatLngStore(assetsService);
});

final networkStatisticsStorePOD = Provider.autoDispose<NetworkStatisticsStore>((ref) {
  final wireguardService = ref.watch(wireguardServicePOD);
  return NetworkStatisticsStore(
    wireguardService,
  );
});

final updateAvailableStorePOD = Provider.autoDispose<UpdateAvailableStore>((ref) {
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  return UpdateAvailableStore(remoteConfigStore, Env.buildInfo);
});

final userIntentsStorePOD = Provider.autoDispose<UserIntentsStore>(
  (ref) {
    final apiService = ref.watch(apiServicePOD);
    final realIPInfoStore = ref.watch(realIPInfoStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);

    final store = UserIntentsStore(
      apiService,
      realIPInfoStore,
      locationsStore,
      remoteConfigStore,
    );

    ref.onCancel(store.dispose);
    return store;
  },
);

final dnsStorePOD = Provider.autoDispose<DNSStore>(
  (ref) => DNSStore(
    LocalDBService.instance,
    ref.watch(remoteConfigStorePOD),
    ref.watch(loggerPOD),
    ref.watch(authSessionStorePOD),
  ),
);

final refreshIPStorePOD = Provider.autoDispose<RefreshIPStore>(
  (ref) => RefreshIPStore(
    LocalDBService.instance,
    ref.watch(loggerPOD),
    ref.watch(authSessionStorePOD),
  ),
);
