import 'package:mysterium_vpn/common/enums/enums.dart';

abstract class AnalyticsService {
  Future<void> logEvent(AnalyticsEvent event, Map<String, dynamic> parameters);

  Future<void> setUserId(String id);

  Future<void> setUserProperty({required String name, required String value});

  Future<void> setScreenName(String name);

  Future<void> setSessionTimeoutDuration();

  Future<void> setLogin(String loginMethod);

  Future<void> setSignUp({required String userId, required String signUpMethod});
  Future<void> setLogOut(String userId);

  Future<void> setSearchEvent(String searchTerm);

  Future<void> setVpnConnect({
    required String vpnServer,
    required Duration vpnProcessingTime,
  });

  Future<void> setVpnDisconnect({required String vpnServer});

  Future<void> setVpnError({
    required int errorCode,
    required String errorMessage,
    required String errorSource,
  });

  Future<void> setPaymentSuccessful({
    required String paymentGateway,
    required String planType,
    required double planPrice,
    required String transactionId,
    required String transactionDate,
  });

  Future<void> setPaymentInitiated({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  });

  Future<void> setManageSubscription({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  });
}
