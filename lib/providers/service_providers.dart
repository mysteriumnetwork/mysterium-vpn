import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/common/interceptors/append_auth_token.dart';
import 'package:mysterium_vpn/common/interceptors/unauthorized.dart';
import 'package:mysterium_vpn/common/observers/crashlytics_talker_observer.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/api/rest_api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/auth/rest_auth_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
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

final authorizedApiClientPOD = Provider<Dio>((ref) {
  final environment = ref.watch(environmentPOD);
  final authStore = ref.watch(authStorePOD);
  final logger = ref.watch(loggerPOD);
  return Dio(
    BaseOptions(
      baseUrl: environment.values.baseUrl,
    ),
  )..interceptors.addAll([
      AppendTokenInterceptor(ref),
      UnauthorizedInterceptor(authStore),
      TalkerDioLogger(
        talker: logger,
      ),
    ]);
});

final unauthorizedApiClientPOD = Provider<Dio>((ref) {
  final environment = ref.watch(environmentPOD);
  final logger = ref.watch(loggerPOD);
  return Dio(
    BaseOptions(
      baseUrl: environment.values.baseUrl,
    ),
  )..interceptors.add(
      TalkerDioLogger(
        talker: logger,
      ),
    );
});

final subscriptionServicePOD = Provider<SubscriptionService>((ref) {
  final apiClient = ref.watch(authorizedApiClientPOD);
  final localDb = ref.watch(localDBPOD);
  final inAppPurchase = ref.watch(inAppPurchasePOD);
  final logger = ref.watch(loggerPOD);
  return RestSubscriptionService(
    apiClient: apiClient,
    inAppPurchase: inAppPurchase,
    localDb: localDb,
    logger: logger,
  );
});

final apiServicePOD = Provider<ApiService>((ref) {
  final apiClient = ref.watch(authorizedApiClientPOD);
  final localDb = ref.watch(localDBPOD);
  final logger = ref.watch(loggerPOD);
  return RestApiService(apiClient: apiClient, localDb: localDb, logger: logger);
});

final authServicePOD = Provider<AuthService>((ref) {
  final apiClient = ref.watch(unauthorizedApiClientPOD);
  final environment = ref.watch(environmentPOD);
  final logger = ref.watch(loggerPOD);
  return RestAuthService(
    apiClient: apiClient,
    scheme: environment.values.scheme,
    logger: logger,
  );
});
final loggerPOD = Provider<Talker>((ref) {
  final analyticsStore = ref.watch(analyticsStorePOD);
  return Talker(
    observer: CrashlitycsLoggerObserver(analyticsStore: analyticsStore),
  );
});
