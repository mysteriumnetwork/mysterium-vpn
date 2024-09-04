import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/common/interceptors/interceptors.dart';
import 'package:mysterium_vpn/common/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/api/rest_api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/auth/rest_auth_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/network/dio_network_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:mysterium_vpn/services/dio_network_logger/dio_network_logger.dart';
import 'package:mysterium_vpn/services/subscription/rest_subscription_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

final inAppPurchasePOD = Provider(
  (ref) => InAppPurchase.instance,
);

final wireguardServicePOD = Provider(
  (ref) => WireguardDart(),
);

final appLinksPOD = Provider(
  (ref) => AppLinks(),
);

final localDBPOD = Provider((ref) => LocalDBService());

final logoutFunction = FutureProvider<void>((ref) async {
  await ref.read(authStorePOD).logout();
});

final networkServicePOD = Provider<NetworkService>((ref) {
  final environment = ref.watch(environmentPOD);
  final logger = ref.watch(loggerPOD);
  final dio = Dio();
  return DioNetworkService(
    dio,
    [
      UnauthorizedInterceptor(ref),
      RetryRequestInterceptor(dio: dio),
      if (kDebugMode)
        TalkerDioLogger(
          talker: logger,
        ),
      if (kDebugMode || environment.flavor == Flavor.dev) DioNetworkLoggerInterceptor(),
    ],
    environment.values.baseUrl,
  );
});

final subscriptionServicePOD = Provider<SubscriptionService>((ref) {
  final networkService = ref.watch(networkServicePOD);
  final localDb = ref.watch(localDBPOD);
  final inAppPurchase = ref.watch(inAppPurchasePOD);
  final logger = ref.watch(loggerPOD);
  return RestSubscriptionService(
    networkService: networkService,
    inAppPurchase: inAppPurchase,
    localDb: localDb,
    logger: logger,
  );
});

final apiServicePOD = Provider<ApiService>((ref) {
  final networkService = ref.watch(networkServicePOD);
  final localDb = ref.watch(localDBPOD);
  final logger = ref.watch(loggerPOD);
  return RestApiService(networkService: networkService, localDb: localDb, logger: logger);
});

final authServicePOD = Provider<AuthService>((ref) {
  final networkService = ref.watch(networkServicePOD);
  final env = ref.watch(environmentPOD).values;
  final logger = ref.watch(loggerPOD);
  return RestAuthService(
    networkService: networkService,
    logger: logger,
    env: env,
  );
});
final loggerPOD = Provider<Talker>((ref) {
  final analyticsStore = ref.watch(analyticsStorePOD);
  return Talker(
    observer: CrashlitycsLoggerObserver(analyticsStore: analyticsStore),
  );
});
