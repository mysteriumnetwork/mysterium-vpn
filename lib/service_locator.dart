import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:beamer/beamer.dart';
import 'package:configcat_client/configcat_client.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
// Core stores
import 'package:mysterium_vpn/core/device/device_id_store.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/string.dart';
import 'package:mysterium_vpn/core/interceptors/api_errors.dart';
import 'package:mysterium_vpn/core/interceptors/connection_errors.dart';
import 'package:mysterium_vpn/core/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/core/interceptors/retry_request.dart';
import 'package:mysterium_vpn/core/interceptors/test_flags_interceptor.dart';
import 'package:mysterium_vpn/core/locale/locale_store.dart';
import 'package:mysterium_vpn/core/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/core/router/router.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
// Feature stores
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store_firebase.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store_windows.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/home/store/banners_store.dart';
import 'package:mysterium_vpn/features/home/store/promotional_content_store.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/store/latlng_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_query_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/recent_locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/selected_location_store.dart';
import 'package:mysterium_vpn/features/locations/store/unavailable_locations_store.dart';
import 'package:mysterium_vpn/features/notifications/repositories/desktop_notifications_repository.dart';
import 'package:mysterium_vpn/features/notifications/repositories/notifications_repository.dart';
import 'package:mysterium_vpn/features/notifications/repositories/onesignal_notifications_repository.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/config_cat_user_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/texts_store.dart';
import 'package:mysterium_vpn/features/settings/store/update_available_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_features_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_limited_time_offer_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_upgrade_store.dart';
import 'package:mysterium_vpn/features/vpn/repositories/openvpn_repository.dart';
import 'package:mysterium_vpn/features/vpn/repositories/wireguard_repository.dart';
import 'package:mysterium_vpn/features/vpn/store/connection_decision_store.dart';
import 'package:mysterium_vpn/features/vpn/store/connection_display_store.dart';
import 'package:mysterium_vpn/features/vpn/store/connections_limit_store.dart';
import 'package:mysterium_vpn/features/vpn/store/dns_store.dart';
import 'package:mysterium_vpn/features/vpn/store/network_statistics_store.dart';
import 'package:mysterium_vpn/features/vpn/store/real_ip_info_store.dart';
import 'package:mysterium_vpn/features/vpn/store/refresh_ip_store.dart';
import 'package:mysterium_vpn/features/vpn/store/smart_refresh_store.dart';
import 'package:mysterium_vpn/features/vpn/store/user_intents_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_protocol_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  _registerPrimitives();
  _registerNetworking();
  _registerServices();
  _registerRepositories();
  _registerStores();
  await getIt.allReady();
}

// ─── Primitives ────────────────────────────────────────────────────────────────

void _registerPrimitives() {
  getIt
    ..registerLazySingleton<AppLinks>(AppLinks.new)
    ..registerLazySingleton<InAppPurchase>(() => InAppPurchase.instance)
    ..registerLazySingleton<WireguardDart>(WireguardDart.new)
    ..registerLazySingleton<OpenVPNDart>(OpenVPNDart.new);
}

// ─── Networking ────────────────────────────────────────────────────────────────

void _registerNetworking() {
  getIt
    ..registerLazySingleton<BaseOptions>(
      () => BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'User-Agent': Env.userAgent,
          'x-client-version': Env.buildInfo.buildVersion,
          'x-client-platform': Platform.operatingSystem,
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    )
    // Primary Dio (with auth interceptors)
    ..registerLazySingleton<Dio>(() {
      final options = getIt<BaseOptions>();
      final sessionStore = getIt<AuthSessionStore>();
      final logger = getIt<Talker>();
      final dio = Dio(options);
      dio.interceptors.addAll([
        ConnectionErrorsInterceptor(),
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (sessionStore.accessToken != null) {
              options.headers['Authorization'] = 'Bearer ${sessionStore.accessToken}';
            }
            options.headers['Accept-Charset'] = 'utf-8';
            return handler.next(options);
          },
        ),
        RefreshTokenInterceptor(dio: dio, logger: logger),
        RetryRequestInterceptor(dio: dio),
        if (kDebugMode || Env.flavor == Flavor.dev) DioNetworkLoggerInterceptor(),
        ApiErrorsInterceptor(),
        if (kDebugMode)
          TalkerDioLogger(
            talker: logger,
            settings: const TalkerDioLoggerSettings(
              printRequestData: false,
              printResponseData: false,
              printErrorData: false,
            ),
          ),
        if (Env.flavor == Flavor.dev && Env.isAutomated) TestFlagsInterceptor(),
      ]);
      return dio;
    })
    // DioNetworkService wrapping the primary auth Dio
    ..registerLazySingleton<DioNetworkService>(() => DioNetworkService(getIt<Dio>()))
    // External NetworkService (no auth; used for IP lookup etc.)
    ..registerLazySingleton<NetworkService>(() {
      final dio = Dio(getIt<BaseOptions>());
      dio.interceptors.add(RetryRequestInterceptor(dio: dio));
      return DioNetworkService(dio);
    }, instanceName: 'external')
    ..registerLazySingleton<VpnApi>(() => VpnApi(dio: getIt<Dio>()))
    // Three separate ConfigCat clients (remote config, A/B testing, texts)
    ..registerLazySingleton<ConfigCatClient>(
      () => ConfigCatClient.get(
        sdkKey: Env.remoteConfigSdkKey,
        options: ConfigCatOptions(
          pollingMode: PollingMode.manualPoll(),
          logger: Env.flavor.isDev ? ConfigCatLogger() : null,
          cache: ConfigCatPreferencesCache(),
        ),
      ),
      instanceName: 'remoteConfig',
    )
    ..registerLazySingleton<ConfigCatClient>(
      () => ConfigCatClient.get(
        sdkKey: Env.abTestingSdkKey,
        options: ConfigCatOptions(
          pollingMode: PollingMode.lazyLoad(
            cacheRefreshInterval: Duration(seconds: Env.flavor.isDev ? 30 : 60 * 180),
          ),
          logger: Env.flavor.isDev ? ConfigCatLogger() : null,
          cache: ConfigCatPreferencesCache(),
        ),
      ),
      instanceName: 'abTesting',
    )
    ..registerLazySingleton<ConfigCatClient>(
      () => ConfigCatClient.get(
        sdkKey: Env.textsSdkKey,
        options: ConfigCatOptions(
          pollingMode: PollingMode.lazyLoad(
            cacheRefreshInterval: Duration(seconds: Env.flavor.isDev ? 30 : 60 * 180),
          ),
          logger: Env.flavor.isDev ? ConfigCatLogger() : null,
          cache: ConfigCatPreferencesCache(),
        ),
      ),
      instanceName: 'texts',
    )
    // Router
    ..registerLazySingleton<BeamerParser>(BeamerParser.new)
    ..registerLazySingleton<BeamerDelegate>(() {
      final authSessionStore = getIt<AuthSessionStore>();
      final analyticsStore = getIt<AnalyticsStore>();
      final authStore = getIt<AuthStore>();
      return BeamerDelegate(
        navigatorObservers: [...analyticsStore.navigationObservers(), SentryNavigatorObserver()],
        guards: [
          BeamGuard(
            pathPatterns: [Routes.main.path, Routes.settings.path],
            check: (context, state) => authSessionStore.canBrowseApp,
            beamToNamed: (_, _) => Routes.platformLogin.path,
          ),
          BeamGuard(
            pathPatterns: [Routes.platformLogin.path, Routes.checkYourEmail.path],
            check: (context, state) =>
                authSessionStore.status == AuthStatus.unauthenticated ||
                authStore.authenticateFeature?.status == FutureStatus.pending,
            beamToNamed: (_, _) => Routes.main.path,
          ),
          BeamGuard(
            pathPatterns: [Routes.emailToken.path],
            check: (context, state) => false,
            beamToNamed: (a, b) => a?.state.routeInformation.uri.path ?? Routes.platformLogin.path,
          ),
          BeamGuard(
            pathPatterns: [Routes.splash.path],
            check: (context, state) => authSessionStore.status == AuthStatus.unknown,
            beamToNamed: (_, _) =>
                authSessionStore.canBrowseApp ? Routes.main.path : Routes.platformLogin.path,
          ),
        ],
        initialPath: Routes.splash.path,
        locationBuilder: (routeInformation, _) => BeamerLocations(routeInformation),
        setBrowserTabTitle: false,
        notFoundRedirectNamed: Routes.main.path,
      );
    });
}

// ─── Services ──────────────────────────────────────────────────────────────────

void _registerServices() {
  getIt
    ..registerLazySingleton<Talker>(
      () => Talker(observer: CrashlitycsLoggerObserver(analyticsStore: getIt<AnalyticsStore>())),
    )
    ..registerLazySingleton<MQTTService>(
      () => MQTTService(
        Env.mqttUrl,
        Env.mqttUsername,
        Env.mqttPassword,
        'mysterium-vpn-${Env.buildInfo.buildVersion}'.truncate(23),
        getIt<Talker>(),
        getIt<RemoteConfigStore>(),
      ),
    )
    ..registerLazySingleton<ApiService>(
      () => RestApiService(api: getIt<VpnApi>(), logger: getIt<Talker>()),
    )
    ..registerLazySingleton<ExternalApiService>(
      () =>
          RestExternalApiService(getIt<NetworkService>(instanceName: 'external'), getIt<Talker>()),
    )
    ..registerLazySingleton<AuthService>(
      () => RestAuthService(
        api: getIt<VpnApi>(),
        networkService: getIt<DioNetworkService>(),
        authSessionStore: getIt<AuthSessionStore>(),
        logger: getIt<Talker>(),
      ),
    )
    ..registerLazySingleton<SubscriptionService>(
      () => RestSubscriptionService(
        api: getIt<VpnApi>(),
        inAppPurchase: getIt<InAppPurchase>(),
        logger: getIt<Talker>(),
      ),
    )
    ..registerLazySingleton<FilterService>(FilterService.new)
    ..registerLazySingleton<LocationsService>(
      () => LocationsService(getIt<VpnApi>().getConnection()),
    )
    ..registerLazySingleton<AssetsService>(() => const AssetsService())
    // Note: WireguradKeyService preserves the typo from the original source.
    ..registerLazySingleton<WireguradKeyService>(
      () => WireguradKeyService(
        wireguardService: getIt<WireguardDart>(),
        secureStorageService: SecureStorageService.instance,
        analyticsStore: getIt<AnalyticsStore>(),
      ),
    )
    ..registerLazySingleton<NominatimService>(
      () => NominatimService(
        LocalDBService.instance,
        Dio(
          BaseOptions(
            baseUrl: 'https://nominatim.openstreetmap.org/',
            headers: {HttpHeaders.userAgentHeader: Env.userAgent},
          ),
        ),
      ),
    )
    // TranslationAssetLoader wraps TextsStore for ConfigCat-driven translations.
    ..registerLazySingleton<AssetLoader>(() => TranslationAssetLoader(getIt<TextsStore>()));
}

// ─── Repositories ──────────────────────────────────────────────────────────────

void _registerRepositories() {
  getIt
    ..registerLazySingleton<WireguardRepository>(
      () => WireguardRepository(
        service: getIt<WireguardDart>(),
        logger: getIt<Talker>(),
        wireguradKeyService: getIt<WireguradKeyService>(),
        apiService: getIt<ApiService>(),
      ),
    )
    ..registerLazySingleton<OpenVpnRepository>(
      () => OpenVpnRepository(
        service: getIt<OpenVPNDart>(),
        logger: getIt<Talker>(),
        apiService: getIt<ApiService>(),
      ),
    )
    ..registerLazySingleton<NotificationsRepository>(
      () => isDesktop()
          ? DesktopNotificationsRepository()
          : OnesignalNotificationsRepository(logger: getIt<Talker>()),
    );
}

// ─── Stores ────────────────────────────────────────────────────────────────────

void _registerStores() {
  // ── Core ──────────────────────────────────────────────────────────────────
  getIt
    ..registerLazySingleton<ThemeStore>(ThemeStore.new)
    ..registerLazySingleton<LocaleStore>(LocaleStore.new)
    ..registerLazySingleton<DeviceIDStore>(DeviceIDStore.new);

  // ── Analytics (platform-conditional) ────────────────────────────────────
  if (isWindowsOrLinux()) {
    getIt.registerLazySingleton<AnalyticsStore>(
      () => AnalyticsStoreWindows(
        measurementId: Env.measurementId,
        apiSecret: Env.apiSecret,
        deviceIDStore: getIt<DeviceIDStore>(),
      ),
    );
  } else {
    getIt.registerLazySingleton<AnalyticsStore>(
      () => AnalyticsStoreFirebase(
        analytics: FirebaseAnalytics.instance,
        crashlytics: FirebaseCrashlytics.instance,
        deviceIDStore: getIt<DeviceIDStore>(),
      ),
    );
  }

  // ── Remote config ────────────────────────────────────────────────────────
  getIt
    ..registerLazySingleton<RemoteConfigStore>(
      () => RemoteConfigStore(
        getIt<ConfigCatClient>(instanceName: 'remoteConfig'),
        getIt<Talker>(),
        isDev: Env.flavor.isDev,
      ),
    )
    ..registerLazySingleton<ABTestingStore>(
      () => ABTestingStore(
        getIt<ConfigCatClient>(instanceName: 'abTesting'),
        getIt<Talker>(),
        getIt<AnalyticsStore>(),
      ),
    )
    ..registerLazySingleton<TextsStore>(
      () => TextsStore(getIt<ConfigCatClient>(instanceName: 'texts'), getIt<Talker>()),
    )
    // ── Auth ──────────────────────────────────────────────────────────────────
    ..registerLazySingleton<AuthSessionStore>(
      () => AuthSessionStore(
        secureStorage: SecureStorageService.instance,
        remoteConfigStore: getIt<RemoteConfigStore>(),
      ),
    )
    ..registerLazySingleton<AuthStore>(
      () => AuthStore(
        authService: getIt<AuthService>(),
        authSessionStore: getIt<AuthSessionStore>(),
        appLinks: getIt<AppLinks>(),
        analyticsStore: getIt<AnalyticsStore>(),
        logger: getIt<Talker>(),
        abTestingStore: getIt<ABTestingStore>(),
        deviceIDStore: getIt<DeviceIDStore>(),
      ),
    )
    // ── Locations ─────────────────────────────────────────────────────────────
    ..registerLazySingleton<SelectedLocationStore>(SelectedLocationStore.new)
    ..registerLazySingleton<LocationsQueryStore>(
      () => LocationsQueryStore(
        SharedPreferenceService.instance,
        getIt<AnalyticsStore>(),
        getIt<LocaleStore>(),
      ),
    )
    ..registerLazySingleton<LocationsStore>(
      () => LocationsStore(
        getIt<VpnApi>().getConnection(),
        getIt<FilterService>(),
        LocalDBService.instance,
        getIt<LocationsService>(),
        getIt<Talker>(),
        getIt<RemoteConfigStore>(),
        getIt<LocationsQueryStore>(),
        getIt<LocaleStore>(),
      ),
    )
    ..registerLazySingleton<RecentLocationsStore>(
      () => RecentLocationsStore(
        LocalDBService.instance,
        getIt<FilterService>(),
        getIt<LocationsQueryStore>(),
        getIt<RemoteConfigStore>(),
        getIt<LocationsStore>(),
        getIt<LocaleStore>(),
      ),
    )
    ..registerLazySingleton<UnavailableLocationsStore>(
      () => UnavailableLocationsStore(getIt<LocationsStore>()),
    )
    ..registerLazySingleton<LatLngStore>(() => LatLngStore(getIt<AssetsService>()))
    // ── VPN ───────────────────────────────────────────────────────────────────
    ..registerLazySingleton<MqttStore>(
      () => MqttStore(mqtt: getIt<MQTTService>(), logger: getIt<Talker>()),
    )
    ..registerLazySingleton<RealIPInfoStore>(
      () => RealIPInfoStore(
        getIt<ExternalApiService>(),
        SharedPreferenceService.instance,
        getIt<WireguardDart>(),
        getIt<AnalyticsStore>(),
      ),
    )
    ..registerLazySingleton<RefreshIPStore>(
      () => RefreshIPStore(LocalDBService.instance, getIt<Talker>(), getIt<AuthSessionStore>()),
    )
    ..registerLazySingleton<SmartRefreshStore>(
      () => SmartRefreshStore(getIt<LocationsStore>(), getIt<SubscriptionStore>(), getIt<Talker>()),
    )
    ..registerLazySingleton<ConnectionsLimitStore>(ConnectionsLimitStore.new)
    ..registerLazySingleton<UserIntentsStore>(
      () => UserIntentsStore(
        getIt<ApiService>(),
        getIt<RealIPInfoStore>(),
        getIt<LocationsStore>(),
        getIt<RemoteConfigStore>(),
      ),
    )
    ..registerLazySingleton<ConnectionDecisionStore>(
      () => ConnectionDecisionStore(
        locationsStore: getIt<LocationsStore>(),
        recentLocationsStore: getIt<RecentLocationsStore>(),
        userIntentsStore: getIt<UserIntentsStore>(),
      ),
    )
    ..registerLazySingleton<VpnProtocolStore>(
      () => VpnProtocolStore(
        LocalDBService.instance,
        getIt<AnalyticsStore>(),
        getIt<RemoteConfigStore>(),
        getIt<AuthSessionStore>(),
      ),
    )
    ..registerLazySingleton<DNSStore>(
      () => DNSStore(
        LocalDBService.instance,
        getIt<RemoteConfigStore>(),
        getIt<Talker>(),
        getIt<AuthSessionStore>(),
        getIt<SubscriptionFeaturesStore>(),
      ),
    )
    ..registerLazySingleton<NetworkStatisticsStore>(
      () => NetworkStatisticsStore(getIt<WireguardDart>()),
    )
    ..registerLazySingleton<VpnStore>(
      () => VpnStore(
        externalApiService: getIt<ExternalApiService>(),
        mqtt: getIt<MQTTService>(),
        locationsStore: getIt<LocationsStore>(),
        subscriptionStore: getIt<SubscriptionStore>(),
        logger: getIt<Talker>(),
        analyticsStore: getIt<AnalyticsStore>(),
        remoteConfigStore: getIt<RemoteConfigStore>(),
        authSessionStore: getIt<AuthSessionStore>(),
        realIPInfo: getIt<RealIPInfoStore>(),
        dnsStore: getIt<DNSStore>(),
        refreshIPStore: getIt<RefreshIPStore>(),
        locationsQueryStore: getIt<LocationsQueryStore>(),
        recentLocationsStore: getIt<RecentLocationsStore>(),
        locationsService: getIt<LocationsService>(),
        unavailableLocationsStore: getIt<UnavailableLocationsStore>(),
        userIntentsStore: getIt<UserIntentsStore>(),
        connectionsLimitStore: getIt<ConnectionsLimitStore>(),
        wireguardRepository: getIt<WireguardRepository>(),
        openVpnRepository: getIt<OpenVpnRepository>(),
        protocolStore: getIt<VpnProtocolStore>(),
        connectionDecisionStore: getIt<ConnectionDecisionStore>(),
      ),
    )
    ..registerLazySingleton<ConnectionDisplayStore>(
      () => ConnectionDisplayStore(
        getIt<VpnStore>(),
        getIt<LocationsStore>(),
        getIt<SelectedLocationStore>(),
        getIt<UnavailableLocationsStore>(),
      ),
    )
    // ── Subscription ──────────────────────────────────────────────────────────
    ..registerLazySingleton<SubscriptionStore>(
      () => SubscriptionStore(
        subscriptionService: getIt<SubscriptionService>(),
        authSessionStore: getIt<AuthSessionStore>(),
        analyticsStore: getIt<AnalyticsStore>(),
        remoteConfigStore: getIt<RemoteConfigStore>(),
      ),
    )
    ..registerLazySingleton<SubscriptionConfigStore>(
      () => SubscriptionConfigStore(
        getIt<AuthSessionStore>(),
        getIt<SubscriptionService>(),
        getIt<AnalyticsStore>(),
      ),
    )
    ..registerLazySingleton<SubscriptionFeaturesStore>(
      () => SubscriptionFeaturesStore(getIt<SubscriptionStore>(), getIt<SubscriptionConfigStore>()),
    )
    ..registerLazySingleton<SubscriptionPlansStore>(
      () => SubscriptionPlansStore(
        getIt<SubscriptionService>(),
        getIt<SubscriptionStore>(),
        getIt<RemoteConfigStore>(),
      ),
    )
    ..registerLazySingleton<SubscriptionPurchaseStore>(
      () => SubscriptionPurchaseStore(
        getIt<InAppPurchase>(),
        SecureStorageService.instance,
        getIt<SubscriptionService>(),
        getIt<Talker>(),
        getIt<AnalyticsStore>(),
        getIt<AuthSessionStore>(),
        getIt<SubscriptionStore>(),
        getIt<SubscriptionPlansStore>(),
      ),
    )
    ..registerLazySingleton<SubscriptionUpgradeStore>(
      () => SubscriptionUpgradeStore(getIt<SubscriptionStore>(), getIt<SubscriptionPlansStore>()),
    )
    ..registerLazySingleton<SubscriptionLimitedTimeOfferStore>(
      () => SubscriptionLimitedTimeOfferStore(
        getIt<SubscriptionPlansStore>(),
        getIt<RemoteConfigStore>(),
      ),
    )
    // ── Settings ──────────────────────────────────────────────────────────────
    ..registerLazySingleton<UpdateAvailableStore>(
      () => UpdateAvailableStore(getIt<RemoteConfigStore>(), Env.buildInfo),
    )
    ..registerLazySingleton<UserPreferencesStore>(
      () => UserPreferencesStore(
        apiService: getIt<ApiService>(),
        analyticsStore: getIt<AnalyticsStore>(),
        realIPInfo: getIt<RealIPInfoStore>(),
        localDBService: LocalDBService.instance,
        pushNotificationsStore: getIt<PushNotificationsStore>(),
        authSessionStore: getIt<AuthSessionStore>(),
      ),
    )
    // ── Notifications ─────────────────────────────────────────────────────────
    ..registerLazySingleton<PushNotificationsStore>(
      () => PushNotificationsStore(
        getIt<AuthSessionStore>(),
        getIt<RealIPInfoStore>(),
        getIt<SubscriptionStore>(),
        getIt<Talker>(),
        getIt<NotificationsRepository>(),
        getIt<AnalyticsStore>(),
        LocalDBService.instance,
        getIt<RemoteConfigStore>(),
      ),
    )
    // ── Home ──────────────────────────────────────────────────────────────────
    ..registerLazySingleton<BannersStore>(
      () => BannersStore(
        LocalDBService.instance,
        getIt<SubscriptionStore>(),
        getIt<AuthSessionStore>(),
        getIt<ConnectionsLimitStore>(),
        getIt<UpdateAvailableStore>(),
      ),
    )
    ..registerLazySingleton<PromotionalContentStore>(
      () => PromotionalContentStore(getIt<RemoteConfigStore>()),
    )
    ..registerLazySingleton<HomeState>(
      () => HomeState(SharedPreferenceService.instance, getIt<AnalyticsStore>()),
    )
    // ── Remote config user store ───────────────────────────────────────────────
    ..registerLazySingleton<ConfigCatUserStore>(
      () => ConfigCatUserStore(
        getIt<AuthSessionStore>(),
        getIt<RealIPInfoStore>(),
        getIt<SubscriptionStore>(),
        getIt<Talker>(),
      ),
    );
}
