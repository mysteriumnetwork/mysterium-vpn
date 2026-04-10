import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:configcat_client/configcat_client.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/core/extensions/string.dart';
import 'package:mysterium_vpn/core/interceptors/api_errors.dart';
import 'package:mysterium_vpn/core/interceptors/connection_errors.dart';
import 'package:mysterium_vpn/core/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/core/interceptors/retry_request.dart';
import 'package:mysterium_vpn/core/interceptors/test_flags_interceptor.dart';
import 'package:mysterium_vpn/core/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

final inAppPurchasePOD = Provider((ref) => InAppPurchase.instance);

final wireguardServicePOD = Provider((ref) => WireguardDart());
final openVpnServicePOD = Provider((ref) => OpenVPNDart());

final appLinksPOD = Provider((ref) => AppLinks());

final networkServicePOD = Provider<DioNetworkService>((ref) {
  final dio = ref.watch(vpnApiDioPOD);

  return DioNetworkService(dio);
});

final vpnApiDioPOD = Provider<Dio>((ref) {
  final options = ref.watch(dioOptionsPOD);
  final logger = ref.watch(loggerPOD);
  final sessionStore = ref.watch(authSessionStorePOD);
  final dio = Dio(options);

  dio.interceptors.addAll([
    ConnectionErrorsInterceptor(),
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (sessionStore.accessToken != null) {
          options.headers['Authorization'] = 'Bearer ${sessionStore.accessToken}';
        }
        options.headers['Accept-Charset'] = 'utf-8'; // Force UTF-8 encoding
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
});

final dioOptionsPOD = Provider(
  (ref) => BaseOptions(
    // ignore: avoid_redundant_argument_values
    baseUrl: Env.baseUrl,
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
);

final vpnApiMQTTPOD = Provider<MQTTService>((ref) {
  final logger = ref.watch(loggerPOD);
  final remoteConfigStore = ref.watch(remoteConfigStorePOD);

  return MQTTService(
    Env.mqttUrl,
    Env.mqttUsername,
    Env.mqttPassword,
    'mysterium-vpn-${Env.buildInfo.buildVersion}'.truncate(23),
    logger,
    remoteConfigStore,
  );
});

final vpnApiPOD = Provider<VpnApi>((ref) {
  final dio = ref.watch(vpnApiDioPOD);

  return VpnApi(dio: dio);
});

final subscriptionServicePOD = Provider<SubscriptionService>((ref) {
  final api = ref.watch(vpnApiPOD);
  final inAppPurchase = ref.watch(inAppPurchasePOD);
  final logger = ref.watch(loggerPOD);

  return RestSubscriptionService(api: api, inAppPurchase: inAppPurchase, logger: logger);
});

final apiServicePOD = Provider<ApiService>((ref) {
  final api = ref.watch(vpnApiPOD);
  final logger = ref.watch(loggerPOD);

  return RestApiService(api: api, logger: logger);
});

final externalApiServicePOD = Provider<ExternalApiService>((ref) {
  final networkService = ref.watch(externalNetworkServicePOD);
  final logger = ref.watch(loggerPOD);

  return RestExternalApiService(networkService, logger);
});

final externalNetworkServicePOD = Provider<NetworkService>((ref) {
  final dio = Dio(ref.watch(dioOptionsPOD));
  dio.interceptors.addAll([RetryRequestInterceptor(dio: dio)]);

  return DioNetworkService(dio);
});

final authServicePOD = Provider<AuthService>((ref) {
  final api = ref.watch(vpnApiPOD);
  final networkService = ref.watch(networkServicePOD);
  final authSessionStore = ref.watch(authSessionStorePOD);
  final logger = ref.watch(loggerPOD);

  return RestAuthService(
    api: api,
    networkService: networkService,
    authSessionStore: authSessionStore,
    logger: logger,
  );
});
final loggerPOD = Provider<Talker>((ref) {
  final analyticsStore = ref.watch(analyticsStorePOD);
  return Talker(observer: CrashlitycsLoggerObserver(analyticsStore: analyticsStore));
});

final remoteConfigClientPOD = Provider<ConfigCatClient>(
  (ref) => ConfigCatClient.get(
    sdkKey: Env.remoteConfigSdkKey,
    options: ConfigCatOptions(
      pollingMode: PollingMode.manualPoll(),
      logger: Env.flavor.isDev ? ConfigCatLogger() : null,
      cache: ConfigCatPreferencesCache(),
    ),
  ),
);

final abTestingClientPOD = Provider<ConfigCatClient>(
  (ref) => ConfigCatClient.get(
    sdkKey: Env.abTestingSdkKey,
    options: ConfigCatOptions(
      pollingMode: PollingMode.lazyLoad(
        cacheRefreshInterval: Duration(seconds: Env.flavor.isDev ? 30 : 60 * 180),
      ),
      logger: Env.flavor.isDev ? ConfigCatLogger() : null,
      cache: ConfigCatPreferencesCache(),
    ),
  ),
);

final textsClientPOD = Provider<ConfigCatClient>(
  (ref) => ConfigCatClient.get(
    sdkKey: Env.textsSdkKey,
    options: ConfigCatOptions(
      pollingMode: PollingMode.lazyLoad(
        cacheRefreshInterval: Duration(seconds: Env.flavor.isDev ? 30 : 60 * 180),
      ),
      logger: Env.flavor.isDev ? ConfigCatLogger() : null,
      cache: ConfigCatPreferencesCache(),
    ),
  ),
);

final assetsLoaderPOD = Provider<AssetLoader>((ref) {
  final textsStore = ref.watch(textsStorePOD);
  return TranslationAssetLoader(textsStore);
});

final filterServicePOD = Provider<FilterService>((ref) => FilterService());

final locationsServicePOD = Provider<LocationsService>((ref) {
  final api = ref.watch(vpnApiPOD);
  return LocationsService(api.getConnection());
});

final assetsServicePOD = Provider((_) => const AssetsService());

final wireguradKeyServicePOD = Provider<WireguradKeyService>(
  (ref) => WireguradKeyService(
    wireguardService: ref.watch(wireguardServicePOD),
    secureStorageService: SecureStorageService.instance,
    analyticsStore: ref.watch(analyticsStorePOD),
  ),
);

final nominatimServicePOD = Provider<NominatimService>(
  (ref) => NominatimService(
    LocalDBService.instance,
    Dio(
      BaseOptions(
        baseUrl: 'https://nominatim.openstreetmap.org/',
        headers: {HttpHeaders.userAgentHeader: Env.userAgent},
      ),
    ),
  ),
);
