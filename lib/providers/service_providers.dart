// import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:wireguard_dart/wireguard_dart.dart';

// //service providers

// final wireguardServicePOD = Provider((ref) => WireguardDart());

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mysterium_vpn/services/api/rest_subscription_service.dart';
import 'package:mysterium_vpn/services/api/subscription_service.dart';

final inAppPurchasePOD = Provider(
  (ref) => InAppPurchase.instance,
);

final dioPOD = Provider(
  (ref) => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  ),
);

final subscriptionServicePOD = Provider<SubscriptionService>((ref) {
  final dio = ref.read(dioPOD);
  final inAppPurchase = ref.read(inAppPurchasePOD);
  return RestSubscriptionService(dio: dio, inAppPurchase: inAppPurchase);
});
