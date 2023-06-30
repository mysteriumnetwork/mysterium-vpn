import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/analytics/analytics_service.dart';

part 'analytics_store.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStore = _AnalyticsStore with _$AnalyticsStore;

abstract class _AnalyticsStore with Store {
  _AnalyticsStore({required AnalyticsService analyticsService})
      : _analyticsService = analyticsService;

  final AnalyticsService _analyticsService;

  @action
  Future<void> setUserId(String id) async {
    await _analyticsService.setUserId(id);
  }

  @action
  Future<void> setUserProperty(String name, String value) async {
    await _analyticsService.setUserProperty(name: name, value: value);
  }

  @action
  Future<void> setScreenName(String name) async {
    await _analyticsService.setScreenName(name);
  }

  @action
  Future<void> setSessionTimeoutDuration() async {
    await _analyticsService.setSessionTimeoutDuration();
  }

  @action
  Future<void> setLogin([AuthMethod loginMethod = AuthMethod.email]) async {
    await _analyticsService.setLogin(loginMethod.name);
  }

  @action
  Future<void> setSignUp(String userId, [AuthMethod signUpMethod = AuthMethod.email]) async {
    await _analyticsService.setSignUp(userId: userId, signUpMethod: signUpMethod.name);
  }

  @action
  Future<void> setLogOut(String userId) async {
    await setLogOut(userId);
  }

  @action
  Future<void> setSearchEvent(String searchTerm) async {
    await _analyticsService.setSearchEvent(searchTerm);
  }

  @action
  Future<void> setVpnConnect({
    required String vpnServer,
    required Duration vpnProcessingTime,
  }) async {
    await _analyticsService.setVpnConnect(
      vpnServer: vpnServer,
      vpnProcessingTime: vpnProcessingTime,
    );
  }

  @action
  Future<void> setVpnDisconnect({required String vpnServer}) async {
    await _analyticsService.setVpnDisconnect(
      vpnServer: vpnServer,
    );
  }

  @action
  Future<void> setVpnError({
    required int errorCode,
    required String errorMessage,
    required String errorSource,
  }) async {
    await _analyticsService.setVpnError(
      errorCode: errorCode,
      errorMessage: errorMessage,
      errorSource: errorSource,
    );
  }

  @action
  Future<void> setPaymentSuccessful({
    required String paymentGateway,
    required String planType,
    required double planPrice,
    required String transactionId,
    required String transactionDate,
  }) async {
    await _analyticsService.setPaymentSuccessful(
      paymentGateway: paymentGateway,
      planType: planType,
      planPrice: planPrice,
      transactionId: transactionId,
      transactionDate: transactionDate,
    );
  }

  @action
  Future<void> setPaymentInitiated({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  }) async {
    await _analyticsService.setPaymentInitiated(
      paymentGateway: paymentGateway,
      planType: planType,
      planPrice: planPrice,
    );
  }

  @action
  Future<void> setManageSubscription({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  }) async {
    await _analyticsService.setManageSubscription(
      paymentGateway: paymentGateway,
      planType: planType,
      planPrice: planPrice,
    );
  }
}
