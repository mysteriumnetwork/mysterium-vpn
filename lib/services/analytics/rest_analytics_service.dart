import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/analytics/analytics_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';

class RestAnalyticsService extends AnalyticsService {
  RestAnalyticsService({
    required LocalDBService localDb,
  }) : _localDb = localDb;
  final LocalDBService _localDb;
  @override
  Future<void> logEvent(AnalyticsEvent event, Map<String, dynamic> parameters) async {}

  @override
  Future<void> setUserId(String id) async {}

  @override
  Future<void> setUserProperty({required String name, required String value}) async {}

  @override
  Future<void> setScreenName(String name) async {}

  @override
  Future<void> setSessionTimeoutDuration() async {}

  @override
  Future<void> setLogin(String loginMethod) async {}

  @override
  Future<void> setSignUp({required String userId, required String signUpMethod}) async {}

  @override
  Future<void> setLogOut(String userId) async {
    await logEvent(AnalyticsEvent.logout, {'user_email': userId});
  }

  @override
  Future<void> setSearchEvent(String searchTerm) async {}

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
