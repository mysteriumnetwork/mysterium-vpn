//state providers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/providers/repository_providers.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

final localeStorePOD = Provider<LocaleStore>((ref) => LocaleStore());

final authSessionStorePOD = Provider<AuthSessionStore>(
  (ref) {
    final store = AuthSessionStore(
      secureStorage: SecureStorageService.instance,
      remoteConfigStore: ref.watch(remoteConfigStorePOD),
    );

    ref.onDispose(store.dispose);

    return store;
  },
);

final authStorePOD = Provider<AuthStore>((ref) {
  final authService = ref.watch(authServicePOD);
  final userPreferencesStore = ref.watch(userPreferencesStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final appLinks = ref.watch(appLinksPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final logger = ref.watch(loggerPOD);
  final abTestingStore = ref.watch(abTestingStorePOD);
  final deviceIDStore = ref.watch(deviceIDStorePOD);

  return AuthStore(
    authService: authService,
    userPreferencesStore: userPreferencesStore,
    authSessionStore: authSessionStore,
    appLinks: appLinks,
    analyticsStore: analyticsStore,
    logger: logger,
    abTestingStore: abTestingStore,
    deviceIDStore: deviceIDStore,
  );
});

final apiStorePOD = Provider<MqttStore>((ref) {
  final mqttService = ref.watch(vpnApiMQTTPOD);
  final logger = ref.watch(loggerPOD);

  final store = MqttStore(
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
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  final dnsStore = ref.watch(dnsStorePOD);
  final refreshIPStore = ref.watch(refreshIPStorePOD);
  final locationsQueryStore = ref.watch(locationsQueryStorePOD);
  final recentLocationsStore = ref.watch(recentLocationsStorePOD);
  final locationsService = ref.watch(locationsServicePOD);
  final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
  final userIntentsStore = ref.watch(userIntentsStorePOD);
  final connectionsLimitStore = ref.watch(connectionsLimitStorePOD);
  final vpnRepository = ref.watch(wireguardRepositoryPOD);
  final connectionDecisionStore = ref.watch(connectionDecisionStorePOD);
  return VpnStore(
    apiService: apiService,
    externalApiService: externalApiService,
    mqtt: mqttService,
    locationsStore: locationsStore,
    subscriptionStore: subscriptionStore,
    logger: logger,
    analyticsStore: analyticsStore,
    remoteConfigStore: remoteConfigStore,
    authSessionStore: authSessionStore,
    realIPInfo: realIPInfoStore,
    dnsStore: dnsStore,
    refreshIPStore: refreshIPStore,
    locationsQueryStore: locationsQueryStore,
    recentLocationsStore: recentLocationsStore,
    locationsService: locationsService,
    unavailableLocationsStore: unavailableLocationsStore,
    userIntentsStore: userIntentsStore,
    connectionsLimitStore: connectionsLimitStore,
    vpnRepository: vpnRepository,
    connectionDecisionStore: connectionDecisionStore,
  );
});

final selectedLocationStorePOD = Provider<SelectedLocationStore>((ref) => SelectedLocationStore());

final locationsQueryStorePOD = Provider<LocationsQueryStore>((ref) {
  final prefs = SharedPreferenceService.instance;
  final analyticsStore = ref.watch(analyticsStorePOD);
  final localeStore = ref.watch(localeStorePOD);
  final store = LocationsQueryStore(prefs, analyticsStore, localeStore);

  ref.onDispose(store.dispose);

  return store;
});

final locationsStorePOD = Provider<LocationsStore>((ref) {
  final api = ref.watch(vpnApiPOD);
  final filterService = ref.watch(filterServicePOD);
  final dbService = LocalDBService.instance;
  final locationsService = ref.watch(locationsServicePOD);
  final logger = ref.watch(loggerPOD);

  final queryStore = ref.watch(locationsQueryStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final localeStore = ref.watch(localeStorePOD);

  final store = LocationsStore(
    api.getConnection(),
    filterService,
    dbService,
    locationsService,
    logger,
    remoteConfigStore,
    queryStore,
    localeStore,
  );

  ref.onDispose(store.dispose);

  return store;
});

final recentLocationsStorePOD = Provider<RecentLocationsStore>((ref) {
  final dbService = LocalDBService.instance;
  final filterService = ref.watch(filterServicePOD);
  final queryStore = ref.watch(locationsQueryStorePOD);
  final localeStore = ref.watch(localeStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final locationsStore = ref.watch(locationsStorePOD);

  final store = RecentLocationsStore(
    dbService,
    filterService,
    queryStore,
    remoteConfigStore,
    locationsStore,
    localeStore,
  );

  ref.onDispose(store.dispose);

  return store;
});

final unavailableLocationsStorePOD = Provider<UnavailableLocationsStore>(
  (ref) {
    final store = UnavailableLocationsStore(ref.watch(locationsStorePOD));
    ref.onDispose(store.dispose);

    return store;
  },
);

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
  ref.onDispose(store.dispose);
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
      deviceIDStore: ref.watch(deviceIDStorePOD),
    );
  }

  return AnalyticsStoreFirebase(
    analytics: FirebaseAnalytics.instance,
    crashlytics: FirebaseCrashlytics.instance,
    deviceIDStore: ref.watch(deviceIDStorePOD),
  );
});

final isAppWindowFocused = StateProvider<bool>((_) => true);

final userPreferencesStorePOD = StateProvider<UserPreferencesStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  final wireguardService = ref.watch(wireguardServicePOD);
  return UserPreferencesStore(
    apiService: apiService,
    analyticsStore: analyticsStore,
    realIPInfo: realIPInfoStore,
    localDBService: LocalDBService.instance,
    wireguardService: wireguardService,
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
    ref.watch(connectionsLimitStorePOD),
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

    ref.onDispose(store.dispose);
    return store;
  },
);

final dnsStorePOD = Provider<DNSStore>(
  (ref) => DNSStore(
    LocalDBService.instance,
    ref.watch(remoteConfigStorePOD),
    ref.watch(loggerPOD),
    ref.watch(authSessionStorePOD),
  ),
);

final refreshIPStorePOD = Provider<RefreshIPStore>(
  (ref) => RefreshIPStore(
    LocalDBService.instance,
    ref.watch(loggerPOD),
    ref.watch(authSessionStorePOD),
  ),
);

final subscriptionUpgradeStorePOD = Provider<SubscriptionUpgradeStore>(
  (ref) => SubscriptionUpgradeStore(
    ref.watch(subscriptionStorePOD),
  ),
);

final connectionsLimitStorePOD = Provider<ConnectionsLimitStore>(
  (ref) => ConnectionsLimitStore(),
);

final connectionDecisionStorePOD = Provider<ConnectionDecisionStore>(
  (ref) => ConnectionDecisionStore(
    locationsStore: ref.watch(locationsStorePOD),
    recentLocationsStore: ref.watch(recentLocationsStorePOD),
    userIntentsStore: ref.watch(userIntentsStorePOD),
  ),
);
