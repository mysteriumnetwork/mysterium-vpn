import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';

part 'analytics_store.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStore = _AnalyticsStore with _$AnalyticsStore;

abstract class _AnalyticsStore with Store {
  _AnalyticsStore({required FirebaseAnalytics analytics, required LocalDBService localDb})
      : _analytics = analytics,
        _localDb = localDb;

  final FirebaseAnalytics _analytics;
  final LocalDBService _localDb;

  @action
  Future<void> logEvent(AnalyticsEvent event, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: event.toSnakeCase, parameters: parameters);
  }

  @action
  Future<void> setUserId(String id) async {
    await _analytics.setUserId(id: id);
  }

  @action
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @action
  Future<void> setScreenName(String name) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

  @action
  Future<void> setSessionTimeoutDuration() async {
    await _analytics.logAppOpen();
  }

  @action
  Future<void> setLogin([AuthMethod loginMethod = AuthMethod.email]) async {
    await _analytics.logLogin(loginMethod: loginMethod.name);
  }

  @action
  Future<void> setSignUp(String userId, [AuthMethod signUpMethod = AuthMethod.email]) async {
    if (!_localDb.checkUserExistance(userId)) {
      await _analytics.logSignUp(signUpMethod: signUpMethod.name);
    }
  }

  @action
  Future<void> setLogOut(String userId) async {
    await logEvent(AnalyticsEvent.logout, {'user_email': userId});
  }

  @action
  Future<void> setSearchEvent(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  @action
  Future<void> setVpnConnect({
    required String vpnServer,
    required Duration vpnProcessingTime,
  }) async {
    await logEvent(
      AnalyticsEvent.vpnConnect,
      {
        'user_email': _localDb.userData.userId,
        'vpn_server': vpnServer,
        'vpn_processing_time': vpnProcessingTime.inSeconds,
      },
    );
  }

  @action
  Future<void> setVpnDisconnect({required String vpnServer}) async {
    await logEvent(
      AnalyticsEvent.vpnDisconnect,
      {
        'user_email': _localDb.userData.userId,
        'vpn_server': vpnServer,
      },
    );
  }

  @action
  Future<void> setVpnError({
    required int errorCode,
    required String errorMessage,
    required String errorSource,
  }) async {
    await logEvent(
      AnalyticsEvent.vpnConnect,
      {
        'user_email': _localDb.userData.userId,
        'error_code': errorCode,
        'error_message': errorMessage,
        'error_source': errorSource,
      },
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
    await logEvent(
      AnalyticsEvent.paymentSuccessful,
      {
        'user_email': _localDb.userData.userId,
        'payment_gateway': paymentGateway,
        'plan_type': planType,
        'plan_price': planPrice,
        'transaction_id': transactionId,
        'transaction_date': transactionDate,
      },
    );
  }

  @action
  Future<void> setPaymentInitiated({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  }) async {
    await logEvent(
      AnalyticsEvent.paymentInitiated,
      {
        'user_email': _localDb.userData.userId,
        'payment_gateway': paymentGateway,
        'plan_type': planType,
        'plan_price': planPrice,
      },
    );
  }

  @action
  Future<void> setManageSubscription({
    required String paymentGateway,
    required String planType,
    required double planPrice,
  }) async {
    await logEvent(
      AnalyticsEvent.paymentInitiated,
      {
        'user_email': _localDb.userData.userId,
        'payment_gateway': paymentGateway,
        'plan_type': planType,
        'plan_price': planPrice,
      },
    );
  }
}
