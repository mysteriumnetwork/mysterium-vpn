//state providers

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/providers/repository_providers.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_user_store.dart';
import 'package:mysterium_vpn/stores/smart_refresh_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_limited_time_offer_store.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';
import 'package:mysterium_vpn/stores/subscription_purchase_store.dart';

final localeStorePOD = Provider<LocaleStore>((ref) => LocaleStore());

final authSessionStorePOD = Provider<AuthSessionStore>((ref) {
  final store = AuthSessionStore(
    secureStorage: SecureStorageService.instance,
    remoteConfigStore: ref.watch(remoteConfigStorePOD),
  );

  ref.onDispose(store.dispose);

  return store;
});

final authStorePOD = Provider<AuthStore>((ref) {
  final authService = ref.watch(authServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final appLinks = ref.watch(appLinksPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final logger = ref.watch(loggerPOD);
  final abTestingStore = ref.watch(abTestingStorePOD);
  final deviceIDStore = ref.watch(deviceIDStorePOD);

  return AuthStore(
    authService: authService,
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

  final store = MqttStore(mqtt: mqttService, logger: logger);
  ref.onDispose(store.dispose);

  return store;
});

final themeStorePOD = Provider<ThemeStore>((ref) => ThemeStore());

final homeTabsStorePOD = Provider<HomeTabsStore>((ref) {
  final store = HomeTabsStore(
    ref.watch(authSessionStorePOD),
    analyticsStore: ref.watch(analyticsStorePOD),
    subscriptionStore: ref.watch(subscriptionStorePOD),
    locationsQueryStore: ref.watch(locationsQueryStorePOD),
  );
  ref.onDispose(store.dispose);
  return store;
});

final vpnStorePOD = Provider<VpnStore>((ref) {
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
  final wireguardRepository = ref.watch(wireguardRepositoryPOD);
  final openVpnRepository = ref.watch(openVpnRepositoryPOD);
  final protocolStore = ref.watch(vpnProtocolStorePOD);
  final connectionDecisionStore = ref.watch(connectionDecisionStorePOD);
  final ipRefreshExhaustionStore = ref.watch(ipRefreshExhaustionStorePOD);

  final vpnStore = VpnStore(
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
    wireguardRepository: wireguardRepository,
    openVpnRepository: openVpnRepository,
    protocolStore: protocolStore,
    connectionDecisionStore: connectionDecisionStore,
    ipRefreshExhaustionStore: ipRefreshExhaustionStore,
  );

  return vpnStore;
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

  final authSessionStore = ref.watch(authSessionStorePOD);

  final store = LocationsStore(
    api.getConnection(),
    filterService,
    dbService,
    locationsService,
    logger,
    remoteConfigStore,
    queryStore,
    localeStore,
    authSessionStore,
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

final unavailableLocationsStorePOD = Provider<UnavailableLocationsStore>((ref) {
  final store = UnavailableLocationsStore(ref.watch(locationsStorePOD));
  ref.onDispose(store.dispose);

  return store;
});

final subscriptionStorePOD = Provider<SubscriptionStore>((ref) {
  final api = ref.watch(vpnApiPOD);
  final subscriptionService = ref.read(subscriptionServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final configStore = ref.watch(subscriptionConfigStorePOD);

  final store = SubscriptionStore(
    api: api,
    subscriptionService: subscriptionService,
    authSessionStore: authSessionStore,
    analyticsStore: analyticsStore,
    remoteConfigStore: remoteConfigStore,
    configStore: configStore,
  );
  ref.onDispose(store.dispose);
  return store;
});

final subscriptionCancellationStorePOD = Provider<SubscriptionCancellationStore>((ref) {
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  final store = SubscriptionCancellationStore(
    analyticsStore: analyticsStore,
    remoteConfigStore: remoteConfigStore,
  );
  ref.onDispose(store.dispose);
  return store;
});

final analyticsInitPOD = FutureProvider.family<void, FirebaseOptions?>((ref, options) async {
  if (options == null) {
    return;
  }
  await Firebase.initializeApp(options: options);
});

final analyticsStorePOD = Provider<AnalyticsStore>((ref) {
  if (_isWindowsOrLinux()) {
    return AnalyticsStoreWindows(
      measurementId: Env.measurementId,
      apiSecret: Env.apiSecret,
      deviceIDStore: ref.watch(deviceIDStorePOD),
    );
  }

  return AnalyticsStoreFirebase(deviceIDStore: ref.watch(deviceIDStorePOD));
});

class IsAppWindowFocusedNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  bool get focused => state;
  set focused(bool value) => state = value;
}

final isAppWindowFocused = NotifierProvider<IsAppWindowFocusedNotifier, bool>(
  IsAppWindowFocusedNotifier.new,
);

final subscriptionOnboardingStorePOD = Provider<SubscriptionOnboardingStore>((ref) {
  final analyticsStore = ref.watch(analyticsStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  return SubscriptionOnboardingStore(
    analyticsStore: analyticsStore,
    subscriptionStore: subscriptionStore,
    localDBService: LocalDBService.instance,
    remoteConfigStore: remoteConfigStore,
  );
});

final userPreferencesStorePOD = Provider<UserPreferencesStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  final pushNotificationsStore = ref.watch(pushNotificationsStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final subscriptionOnboardingStore = ref.watch(subscriptionOnboardingStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  return UserPreferencesStore(
    apiService: apiService,
    analyticsStore: analyticsStore,
    realIPInfo: realIPInfoStore,
    localDBService: LocalDBService.instance,
    pushNotificationsStore: pushNotificationsStore,
    authSessionStore: authSessionStore,
    subscriptionStore: subscriptionStore,
    subscriptionOnboardingStore: subscriptionOnboardingStore,
    remoteConfigStore: remoteConfigStore,
  );
});

final configCatUserStorePOD = Provider<ConfigCatUserStore>((ref) {
  final authSessionStore = ref.watch(authSessionStorePOD);
  final ipInfoStore = ref.watch(realIPInfoStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final logger = ref.watch(loggerPOD);

  final store = ConfigCatUserStore(authSessionStore, ipInfoStore, subscriptionStore, logger);

  ref.onDispose(store.dispose);

  return store;
});

final remoteConfigStorePOD = Provider<RemoteConfigStore>((ref) {
  final client = ref.watch(remoteConfigClientPOD);
  final logger = ref.watch(loggerPOD);
  return RemoteConfigStore(client, logger, isDev: Env.flavor.isDev);
});

final abTestingStorePOD = Provider<ABTestingStore>((ref) {
  final client = ref.watch(abTestingClientPOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);

  return ABTestingStore(client, logger, analyticsStore);
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

final residentialEducationStorePOD = Provider<ResidentialEducationStore>(
  (ref) => ResidentialEducationStore(LocalDBService.instance),
);

final realIPInfoStorePOD = Provider<RealIPInfoStore>(
  (ref) => RealIPInfoStore(
    ref.watch(externalApiServicePOD),
    SharedPreferenceService.instance,
    ref.watch(wireguardServicePOD),
    ref.watch(analyticsStorePOD),
  ),
);

final deviceIDStorePOD = Provider<DeviceIDStore>((ref) => DeviceIDStore());

final latLngStorePOD = Provider<LatLngStore>((ref) {
  final assetsService = ref.watch(assetsServicePOD);
  return LatLngStore(assetsService);
});

final networkStatisticsStorePOD = Provider.autoDispose<NetworkStatisticsStore>((ref) {
  final wireguardService = ref.watch(wireguardServicePOD);
  return NetworkStatisticsStore(wireguardService);
});

final updateAvailableStorePOD = Provider.autoDispose<UpdateAvailableStore>((ref) {
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  return UpdateAvailableStore(remoteConfigStore, Env.buildInfo);
});

final userIntentsStorePOD = Provider.autoDispose<UserIntentsStore>((ref) {
  final apiService = ref.watch(apiServicePOD);
  final realIPInfoStore = ref.watch(realIPInfoStorePOD);
  final locationsStore = ref.watch(locationsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  final store = UserIntentsStore(apiService, realIPInfoStore, locationsStore, remoteConfigStore);

  ref.onDispose(store.dispose);
  return store;
});

final dnsStorePOD = Provider<DNSStore>(
  (ref) => DNSStore(
    LocalDBService.instance,
    ref.watch(remoteConfigStorePOD),
    ref.watch(loggerPOD),
    ref.watch(authSessionStorePOD),
    ref.watch(subscriptionStorePOD),
  ),
);

final refreshIPStorePOD = Provider<RefreshIPStore>(
  (ref) =>
      RefreshIPStore(LocalDBService.instance, ref.watch(loggerPOD), ref.watch(authSessionStorePOD)),
);

final ipRefreshExhaustionStorePOD = Provider<IpRefreshExhaustionStore>(
  (ref) => IpRefreshExhaustionStore(ref.watch(analyticsStorePOD)),
);

final newsCenterStorePOD = Provider<NewsCenterStore>(
  (ref) => NewsCenterStore(ref.watch(newsCenterServicePOD), ref.watch(loggerPOD)),
);

final newsCenterRefreshStorePOD = Provider<NewsCenterRefreshStore>((ref) {
  final store = NewsCenterRefreshStore(
    ref.watch(newsCenterStorePOD),
    ref.watch(remoteConfigStorePOD),
  );
  ref.onDispose(store.dispose);
  return store;
});

final subscriptionUpgradeStorePOD = Provider<SubscriptionUpgradeStore>(
  (ref) => SubscriptionUpgradeStore(
    ref.watch(subscriptionStorePOD),
    ref.watch(subscriptionPlansStorePOD),
  ),
);

final connectionsLimitStorePOD = Provider<ConnectionsLimitStore>((ref) => ConnectionsLimitStore());

final connectionDecisionStorePOD = Provider<ConnectionDecisionStore>(
  (ref) => ConnectionDecisionStore(
    locationsStore: ref.watch(locationsStorePOD),
    recentLocationsStore: ref.watch(recentLocationsStorePOD),
    userIntentsStore: ref.watch(userIntentsStorePOD),
  ),
);

final subscriptionLimitedTimeOfferStorePOD = Provider<SubscriptionLimitedTimeOfferStore>((ref) {
  final store = SubscriptionLimitedTimeOfferStore(
    ref.watch(subscriptionPlansStorePOD),
    ref.watch(remoteConfigStorePOD),
  );

  ref.onDispose(store.dispose);

  return store;
});

final vpnProtocolStorePOD = Provider<VpnProtocolStore>((ref) {
  final localDB = LocalDBService.instance;
  final analyticsStore = ref.watch(analyticsStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  return VpnProtocolStore(localDB, analyticsStore, remoteConfigStore, authSessionStore);
});

final connectionDisplayStorePOD = Provider<ConnectionDisplayStore>(
  (ref) => ConnectionDisplayStore(
    ref.watch(vpnStorePOD),
    ref.watch(locationsStorePOD),
    ref.watch(selectedLocationStorePOD),
    ref.watch(unavailableLocationsStorePOD),
  ),
);

final subscriptionPlansStorePOD = Provider<SubscriptionPlansStore>((ref) {
  final subscriptionService = ref.read(subscriptionServicePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  final inAppPurchase = ref.read(inAppPurchasePOD);

  final store = SubscriptionPlansStore(
    subscriptionService,
    subscriptionStore,
    remoteConfigStore,
    inAppPurchase,
  );

  ref.onDispose(store.dispose);

  return store;
});

final subscriptionPurchaseStorePOD = Provider<SubscriptionPurchaseStore>((ref) {
  final inAppPurchase = ref.read(inAppPurchasePOD);
  final secureStorageService = SecureStorageService.instance;
  final subscriptionService = ref.read(subscriptionServicePOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final subscriptionPlansStore = ref.watch(subscriptionPlansStorePOD);

  final store = SubscriptionPurchaseStore(
    inAppPurchase,
    secureStorageService,
    subscriptionService,
    logger,
    analyticsStore,
    authSessionStore,
    subscriptionStore,
    subscriptionPlansStore,
  );

  ref.onDispose(store.dispose);

  return store;
});

final smartRefreshStorePOD = Provider<SmartRefreshStore>((ref) {
  final locationsStore = ref.watch(locationsStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final logger = ref.watch(loggerPOD);

  final store = SmartRefreshStore(locationsStore, subscriptionStore, authSessionStore, logger);

  ref.onDispose(store.dispose);

  return store;
});

final subscriptionConfigStorePOD = Provider<SubscriptionConfigStore>((ref) {
  final subscriptionService = ref.read(subscriptionServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);

  final store = SubscriptionConfigStore(authSessionStore, subscriptionService);

  ref.onDispose(store.dispose);

  return store;
});

final promotionalContentStorePOD = Provider<PromotionalContentStore>((ref) {
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);
  return PromotionalContentStore(remoteConfigStore);
});

final pushNotificationsStorePOD = Provider<PushNotificationsStore>((ref) {
  final authSessionStore = ref.watch(authSessionStorePOD);
  final ipInfoStore = ref.watch(realIPInfoStorePOD);
  final subscriptionStore = ref.watch(subscriptionStorePOD);
  final notificationsRepository = ref.watch(pushNotificationsRepositoryPOD);
  final logger = ref.watch(loggerPOD);
  final analyticsStore = ref.watch(analyticsStorePOD);
  final localDb = LocalDBService.instance;
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  final store = PushNotificationsStore(
    authSessionStore,
    ipInfoStore,
    subscriptionStore,
    logger,
    notificationsRepository,
    analyticsStore,
    localDb,
    remoteConfigStore,
  );

  ref.onDispose(store.dispose);

  return store;
});

final reviewPromptStorePOD = Provider<ReviewPromptStore>((ref) {
  // Best-effort crash suppression: Crashlytics only runs where Firebase is
  // initialised (mobile). Fetched once asynchronously and read synchronously by
  // the store; it's only needed when a session later completes.
  var crashedRecently = false;
  if (Platform.isAndroid || Platform.isIOS) {
    unawaited(() async {
      try {
        crashedRecently = await FirebaseCrashlytics.instance.didCrashOnPreviousExecution();
      } catch (_) {
        // Firebase not ready / unsupported — leave false.
      }
    }());
  }

  final store = ReviewPromptStore(
    prefs: SharedPreferenceService.instance,
    remoteConfigStore: ref.watch(remoteConfigStorePOD),
    analyticsStore: ref.watch(analyticsStorePOD),
    vpnStore: ref.watch(vpnStorePOD),
    authSessionStore: ref.watch(authSessionStorePOD),
    didCrashRecently: () => crashedRecently,
    canShowNativeReview: InAppReviewService().isAvailable,
  )..init();

  ref.onDispose(store.dispose);

  return store;
});

bool _isWindowsOrLinux() => Platform.isWindows || Platform.isLinux;
