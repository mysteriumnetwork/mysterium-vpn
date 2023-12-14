import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'analytics_store_firebase.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreFirebase = _AnalyticsStoreFirebase with _$AnalyticsStoreFirebase;

abstract class _AnalyticsStoreFirebase extends AnalyticsStore with Store {
  _AnalyticsStoreFirebase({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
    required LocalDBService localDb,
  })  : _analytics = analytics,
        _crashlytics = crashlytics,
        _localDb = localDb;

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;
  final LocalDBService _localDb;

  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {
    if (fatal) {
      _crashlytics.recordFlutterFatalError(
        FlutterErrorDetails(exception: err, stack: stack),
      );
      return;
    }

    _crashlytics.recordError(
      err,
      stack,
      reason: reason,
      printDetails: true,
    );
  }

  @override
  List<NavigatorObserver> navigationObservers() => [
        FirebaseAnalyticsObserver(
          analytics: _analytics,
          nameExtractor: (settings) => settings.name,
        ),
      ];

  @override
  @action
  Future<void> logMessage(String message) async {
    _crashlytics.log(message);
  }

  @override
  @action
  Future<void> logEvent(
    AnalyticsEvent event,
    Map<String, dynamic> parameters,
  ) async {
    await _analytics.logEvent(name: event.toSnakeCase, parameters: parameters);
  }

  @override
  @action
  Future<void> setUserId(String id) async {
    await Future.wait([
      _analytics.setUserId(id: id),
      _crashlytics.setUserIdentifier(id),
    ]);
  }

  @override
  @action
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  @action
  Future<void> setScreenName(String name) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

  @override
  @action
  Future<void> setSessionTimeoutDuration() async {
    await _analytics.logAppOpen();
  }

  @override
  @action
  Future<void> setLogin([AuthMethod loginMethod = AuthMethod.email]) async {
    await _analytics.logLogin(loginMethod: loginMethod.name);
  }

  @override
  @action
  Future<void> setSignUp(
    String userId, [
    AuthMethod signUpMethod = AuthMethod.email,
  ]) async {
    if (!_localDb.checkUserExistance(userId)) {
      await _analytics.logSignUp(signUpMethod: signUpMethod.name);
    }
  }

  @override
  @action
  Future<void> setLogOut(String userId) async {
    await logEvent(AnalyticsEvent.logout, {'user_email': userId});
  }

  @override
  @action
  Future<void> setSearchEvent(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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
