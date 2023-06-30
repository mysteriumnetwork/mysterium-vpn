import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

abstract class AnalyticsStore {
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  });
  List<NavigatorObserver> navigationObservers();
  Future<void> logEvent(AnalyticsEvent event, Map<String, dynamic> parameters);
  Future<void> setUserId(String id);
  Future<void> setUserProperty(String name, String value);
  Future<void> setScreenName(String name);
  Future<void> setSessionTimeoutDuration();
  Future<void> setLogin([AuthMethod loginMethod = AuthMethod.email]);
  Future<void> setSignUp(
    String userId, [
    AuthMethod signUpMethod = AuthMethod.email,
  ]);
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
