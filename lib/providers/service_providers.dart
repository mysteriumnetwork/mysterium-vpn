// import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:wireguard_dart/wireguard_dart.dart';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mysterium_vpn/common/interceptors/append_auth_token.dart';
import 'package:mysterium_vpn/common/interceptors/log_errors.dart';
import 'package:mysterium_vpn/common/interceptors/unauthorized.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/api/rest_api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/auth/rest_auth_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/subscription/rest_subscription_service.dart';
import 'package:mysterium_vpn/services/subscription/subscription_service.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

final inAppPurchasePOD = Provider(
  (ref) => InAppPurchase.instance,
);

final intercomPOD = Provider(
  (ref) => Intercom.instance,
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
  return Dio(
    BaseOptions(
      baseUrl: environment.values.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )
    ..interceptors.addAll([
      AppendTokenInterceptor(ref),
      UnauthorizedInterceptor(authStore),
      CustomLogInterceptor(
        responseHeader: false,
        requestHeader: false,
        requestBody: true,
        responseBody: true,
      )
    ])
    ..addSentry();
});

final unauthorizedApiClientPOD = Provider<Dio>((ref) {
  final environment = ref.watch(environmentPOD);

  return Dio(
    BaseOptions(
      baseUrl: environment.values.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )
    ..interceptors.add(
      CustomLogInterceptor(
        responseHeader: false,
        requestHeader: false,
        requestBody: true,
        responseBody: true,
      ),
    )
    ..addSentry();
});

final subscriptionServicePOD = Provider<SubscriptionService>((ref) {
  final apiClient = ref.watch(authorizedApiClientPOD);
  final localDb = ref.watch(localDBPOD);
  final inAppPurchase = ref.watch(inAppPurchasePOD);
  return RestSubscriptionService(
    apiClient: apiClient,
    inAppPurchase: inAppPurchase,
    localDb: localDb,
  );
});

final apiServicePOD = Provider<ApiService>((ref) {
  final apiClient = ref.watch(authorizedApiClientPOD);
  final localDb = ref.watch(localDBPOD);
  return RestApiService(apiClient: apiClient, localDb: localDb);
});

final authServicePOD = Provider<AuthService>((ref) {
  final apiClient = ref.watch(unauthorizedApiClientPOD);
  final environment = ref.watch(environmentPOD);

  return RestAuthService(
    apiClient: apiClient,
    scheme: environment.values.scheme,
  );
});
