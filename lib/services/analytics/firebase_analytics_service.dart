import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/services/analytics/analytics_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';

class FirebaseAnalyticsService extends AnalyticsService {
  FirebaseAnalyticsService({
    required FirebaseAnalytics analytics,
    required LocalDBService localDb,
  })  : _analytics = analytics,
        _localDb = localDb;
  final FirebaseAnalytics _analytics;
  final LocalDBService _localDb;
  @override
  Future<void> logEvent(AnalyticsEvent event, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: event.toSnakeCase, parameters: parameters);
  }

  @override
  Future<void> setUserId(String id) async {
    await _analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({required String name, required String value}) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setScreenName(String name) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

  @override
  Future<void> setSessionTimeoutDuration() async {
    await _analytics.logAppOpen();
  }

  @override
  Future<void> setLogin(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> setSignUp({required String userId, required String signUpMethod}) async {
    if (!_localDb.checkUserExistance(userId)) {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
    }
  }

  @override
  Future<void> setLogOut(String userId) async {
    await logEvent(AnalyticsEvent.logout, {'user_email': userId});
  }

  @override
  Future<void> setSearchEvent(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  @override
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

  @override
  Future<void> setVpnDisconnect({required String vpnServer}) async {
    await logEvent(
      AnalyticsEvent.vpnDisconnect,
      {
        'user_email': _localDb.userData.userId,
        'vpn_server': vpnServer,
      },
    );
  }

  @override
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

  @override
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

  @override
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

  @override
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
