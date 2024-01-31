import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'analytics_store_noop.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreNoop = _AnalyticsStoreNoop with _$AnalyticsStoreNoop;

abstract class _AnalyticsStoreNoop extends AnalyticsStore with Store {
  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {}

  @override
  List<NavigatorObserver> navigationObservers() => [];

  @override
  @action
  Future<void> logEvent(
    AnalyticsEvent event,
    Map<String, dynamic> parameters,
  ) async {}

  @override
  @action
  Future<void> setUserId(String id) async {}

  @override
  @action
  Future<void> setUserProperty(String name, String value) async {}

  @override
  @action
  Future<void> setScreenName(String name) async {}

  @override
  @action
  Future<void> setSessionTimeoutDuration() async {}

  @override
  @action
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {}

  @override
  @action
  Future<void> setSignUp(
    String userId, [
    GrantType signUpMethod = GrantType.email,
  ]) async {}

  @override
  @action
  Future<void> setLogOut(String userId) async {}

  @override
  @action
  Future<void> setSearchEvent(String searchTerm) async {}

  @override
  @action
  Future<void> setVpnConnect({
    required String vpnServer,
    required Duration vpnProcessingTime,
  }) async {}

  @override
  @action
  Future<void> setVpnDisconnect({required String vpnServer}) async {}

  @override
  @action
  Future<void> setVpnError({
    required int errorCode,
    required String errorMessage,
    required String errorSource,
  }) async {}

  @override
  @action
  Future<void> setPaymentSuccessful({
    required String paymentGateway,
    required String planType,
    required double planPrice,
    required String transactionId,
    required String transactionDate,
  }) async {}

  @override
  @action
  Future<void> setPaymentInitiated({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  }) async {}

  @override
  @action
  Future<void> setManageSubscription({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  }) async {}

  @override
  @action
  Future<void> logMessage(String message) async {}
}
